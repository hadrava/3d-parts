#!/usr/bin/env perl

use strict;
use warnings;

my @header;

while (<>) {
	if (/^do-it\@green\.$/) {
		print $_;
		last;
	}
	push @header, ";$_";
}

while (<>) {
	print $_;
	last if (/^;D3D:START:START$/);
}

print "\n";
print @header;
print "\n";

while (<>) {
	print $_;
}
