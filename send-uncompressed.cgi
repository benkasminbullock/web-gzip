#!/usr/local/bin/perl
use warnings;
use strict;
use lib '/home/protected/lib';
use Gzip::Faster;

binmode STDOUT, ":crlf";

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

$file not on this server
EOF
    }
}
exit;

sub send_file
{
    my ($file) = @_;
    my $file_contents = gunzip_file ($file);
    print <<EOF;
Content-type: text/plain; charset=UTF-8
X-Requester-No-Gzip: yes

$file_contents
EOF
}
