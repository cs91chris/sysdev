#!/usr/bin/perl -w

#this script search for frag on a fs
use strict;

#number of files
my $files = 0;
#number of fragment
my $fragments = 0;
#number of fragmented files
my $fragfiles = 0;

#search fs for all file
open (FILES, "find " . $ARGV[0] . " -xdev -type f -print0 |");

$/ = "\0";

while (defined (my $file = <FILES>)) {
        open (FRAG, "-|", "filefrag", $file);
        my $res = <FRAG>;
        if ($res =~ m/.*:\s+(\d+) extents? found/) {
                my $fragment = $1;
                $fragments += $fragment;
                if ($fragment > 1) {
                        $fragfiles++;
                }
                $files++;
        } else {
                print ("$res : not understand for $file.\n");
        }
        close (FRAG);
}
close (FILES);

print ( $fragfiles / $files * 100 . "% non contiguous files, " . $fragments / $files . " average fragments.\n"); 
