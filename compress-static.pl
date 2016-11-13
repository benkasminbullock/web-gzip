#!/usr/local/bin/perl
use warnings;
use strict;
# Set to a true value to print messages as it operates.
my $verbose = 1;
use File::Find;

# Find all the files under the current directory.

find (\& compress, ("."));
exit;

# Compress files which match a particular pattern.

sub compress
{
    # See if the file name ends in ".html", ".css", etc.
    if (! /(.*\.(?:html|css|js|txt|pl|c|pod)$)/) {
        if ($verbose) {
            print "Rejecting $_\n";
        }
	# We don't need to compress this file (for example image files).
	return;
    }
    my $gz = "$_.gz";
    if (-f $gz) {
	# A compressed version of this file exists.
	if (mdate ($_) <= mdate ($gz)) {
	    if ($verbose) {
		print "$_ is older than $gz: don't need to compress it.\n";
	    }
	    goto delete_file;
	}
    }
    if ($verbose) {
	print "Compressing $_\n";
    }
    system ("gzip --best --force $_");
    delete_file:
    # Delete the uncompressed version of the file.
    if ($verbose) {
	print "Deleting $_\n";
    }
    unlink $_ or warn "Could not remove $_: $!";
}

# Returns the last modification date of the file in epoch time.

sub mdate
{
    my ($file) = @_;
    my @stat = stat $file;
    return $stat[9];
}
