#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use FindBin;
my $file = 'test';
$ENV{REDIRECT_QUERY_STRING} = $file;
system ("perl $FindBin::Bin/send-uncompressed.cgi");
