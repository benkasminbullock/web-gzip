#!/usr/local/bin/perl
use warnings;
use strict;
use HTTP::Date;
use lib '/home/protected/lib';
use Gzip::Faster;

my %mimetypes = (
    html => 'text/html',
    js => 'application/javascript',
    css => 'text/css',
);

my $query = $ENV{REDIRECT_QUERY_STRING};

if (! defined $query) {
    print <<EOF;
Content-Type: text/plain
Status: 200

No request received.
EOF
}
else {
    my $file = "$query.gz";
    if (-f $file) {
	send_file ($file);
    }
    else {
	print <<EOF;
Status: 404

Requested file '$file' was not found on this server.
EOF
    }
}
exit;

sub mtime
{
    my ($file) = @_;
    my @stat = stat ($file);
    return $stat[9];
}

sub send_file
{
    my ($file) = @_;
    my $mtime = mtime ($file);
    my $if_modified_since = $ENV{HTTP_IF_MODIFIED_SINCE};
    if ($if_modified_since) {
	my $if_modified_since_epoch = str2time ($if_modified_since);
	if ($if_modified_since_epoch > $mtime) {
	    # Print not modified header.
	    print <<EOF;
Status: 304

EOF
	    return;
	}
    }
    my $mimetype = 'text/plain';
    if ($file =~ /.*?\.(\w+)\.gz$/) {
	my $ext = lc $1;
	if ($mimetypes{$ext}) {
	    $mimetype = $mimetypes{$ext};
	}
    }
    # Send the ungzipped file
    my $file_contents = gunzip_file ($file);
    my $http_date = time2str ($mtime);
    print <<EOF;
Content-type: $mimetype; charset=UTF-8
Last-Modified: $http_date
X-Requester-No-Gzip: yes

$file_contents
EOF
    return;
}
