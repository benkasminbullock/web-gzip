#!/home/ben/software/install/bin/perl

# This tests that the CGI script works correctly.

use warnings;
use strict;
use FindBin '$Bin';
use Test::More;
use Test::CGI::External;
my $tester = Test::CGI::External->new ();
my $file = 'test';

# We need to deal with this, because of alterations made by .htaccess.

$ENV{REDIRECT_QUERY_STRING} = $file;

my %options = (
    QUERY_STRING => $file,
    REQUEST_METHOD => 'GET',
);

$tester->set_cgi_executable ("$Bin/send-uncompressed.cgi");
$tester->run (\%options);
$tester->do_caching_test (1);
$tester->run (\%options);
done_testing ();
