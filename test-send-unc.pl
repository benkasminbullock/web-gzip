#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use FindBin;
my $file = 'test';
$ENV{REDIRECT_QUERY_STRING} = $file;
system ("perl $FindBin::Bin/send-uncompressed.cgi");
$ENV{HTTP_IF_MODIFIED_SINCE} = "Mon, 1 Jan 2014 00:00:00 GMT";
system ("perl $FindBin::Bin/send-uncompressed.cgi");
$ENV{HTTP_IF_MODIFIED_SINCE} = "Mon, 1 Jan 2011 00:00:00 GMT";
system ("perl $FindBin::Bin/send-uncompressed.cgi");
