#!/usr/bin/perl
use strict;
use warnings;

my $consumedFilament=0;

my $pos_x = 120;
my $pos_y = 0;
my $pos_z = 20;
my $pos_e = 0;
my $feedrate = 4410;
my $max_feedrate = 4410; # 73.5 mm/s
my $time = 0;

while (<>) {
	# a regular expression for the G0/G1 commmand (click it to see what it does)
	if (/^G92(\h+X(-?\d*\.?\d+))?(\h+Y(-?\d*\.?\d+))?(\h+Z(-?\d*\.?\d+))?(\h+E(-?\d*\.?\d+))?(\h+F(\d*\.?\d+))?(\h*;\h*([\h\w_-]*)\h*)?/) {
		my $X=$2, my $Y=$4, my $Z=$6, my $E=$8, my $F=$10, my $verbose=$12;

		$pos_x = $X if $X;
		$pos_y = $Y if $Y;
		$pos_z = $Z if $Z;
		$pos_e = $E if $E;
	}
	if (/^G[01](\h+X(-?\d*\.?\d+))?(\h+Y(-?\d*\.?\d+))?(\h+Z(-?\d*\.?\d+))?(\h+E(-?\d*\.?\d+))?(\h+F(\d*\.?\d+))?(\h*;\h*([\h\w_-]*)\h*)?/) {
		# the match variables, just readable
		my $X=$2, my $Y=$4, my $Z=$6, my $E=$8, my $F=$10, my $verbose=$12;
		$feedrate = $F if $F;

		$feedrate = $max_feedrate if $feedrate > $max_feedrate;

		my ($new_x, $new_y, $new_z, $new_e) = ($pos_x, $pos_y, $pos_z, $pos_e);

		$new_x = $X if $X;
		$new_y = $Y if $Y;
		$new_z = $Z if $Z;
		$new_e = $E if $E;

		my $dist = ($pos_x - $new_x) * ($pos_x - $new_x) + ($pos_y - $new_y) * ($pos_y - $new_y) + ($pos_z - $new_z) * ($pos_z - $new_z);

		$dist = sqrt($dist);

		my $newtime = $time + sqrt(($pos_e - $new_e) * ($pos_e - $new_e)) / $feedrate;

		$newtime = $time + $dist / $feedrate if $X;
		$newtime = $time + $dist / $feedrate if $Y;
		$newtime = $time + $dist / $feedrate if $Z;

		$time = $newtime;

		($pos_x, $pos_y, $pos_z) = ($new_x, $new_y, $new_z);

		#print "$feedrate\n";
	}
}

my $hour = int($time / 60);
$time -= 60*$hour;
my $min = int($time);
$time -= $min;
my $sec = int($time * 60);

print "Print time: $hour.$min:$sec (without initial homing and extruder heat-up)\n";
