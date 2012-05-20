#!/usr/local/bin/perl
use warnings;
use strict;
use IO::Uncompress::Gunzip qw/gunzip $GunzipError/;

my $query = $ENV{REDIRECT_QUERY_STRING};
if (! defined $query) {
    $query = 'no query';
}

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
exit;

sub send_file
{
    my ($file) = @_;
    print <<EOF;
Content-type: text/plain; charset=UTF-8
X-Requester-Is-Wanker: yes

EOF
    gunzip $file, \*STDOUT;
}


for my $k (sort keys %ENV) {
    print "$k $ENV{$k}\n";
}
