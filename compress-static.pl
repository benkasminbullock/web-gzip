#!/usr/local/bin/perl
use warnings;
use strict;
my $verbose = 1;
#use FindBin::Bin;
use File::Find;
find (\&wanted, ("."));
sub wanted
{
    # Files in c/forum are cgi scripts, not perl example programs.
    if ($File::Find::name =~ m!/c/forum/.*\.pl$! ||
	$File::Find::name =~ /compress-static\.pl/) {
	if ($verbose) {
	    print "$File::Find::name not ok.\n";
	}
	return;
    }
    if (/(.*\.(?:html|css|js|txt|pl|c|pod)$)/) {
        my $gz = "$_.gz";
        if (-f $gz) {
            if (age ($_) <= age ($gz)) {
                if ($verbose) {
                    print "Don't need to compress $_\n";
                }
                goto delete_file;
            }
        }
        if ($verbose) {
            print "Compressing $_\n";
        }
        system ("gzip --best --force $_");
      delete_file:
	if ($verbose) {
	    print "Deleting $_\n";
	}
	unlink $_ or warn "Could not remove $_: $!";
    }
    else {
        if ($verbose) {
            print "Rejecting $_\n";
        }
    }
}

sub age
{
    my ($file) = @_;
    my @stat = stat $file;
    return $stat[9];
}
