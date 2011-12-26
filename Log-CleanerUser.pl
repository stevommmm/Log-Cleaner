#! /usr/bin/perl
use File::stat;
# Log censoring script.
#     - Lwc password censoring
#     - IP censoring (possibly use a salt?)
#
# Usage: perl Log-Cleaner.pl [logfile] 
#
# Stephen McGregor (c45y) 17/06/2011
#
$RESOURCE = $ARGV[0];
$OUTFILE = $ARGV[1];
$olderthan = 2;
if ($RESOURCE eq '' || $OUTFILE eq ''){
	die "USE: Log-CleanerUser.pl INFILE OUTFILE";
}
if ( -M $RESOURCE > $olderthan ) {
	die "Over $olderthan days old, I cant fap to that.\n";
}
open DATA, "$RESOURCE" or die "can't open $RESOURCE $!";
my @loglist = <DATA>;
close (DATA);
if (-e $OUTFILE) {
	unlink($OUTFILE);
}
open (OUT, "> $OUTFILE") or die "can't open file $!";
foreach $string (@loglist) {
	$string =~ s/§[a-f0-9]//g;
	$string =~ s/\[[a-z0-9]+m//g;
	if ($string =~ /\[INFO\] \</) {
		print OUT "$string";
	}elsif ($string =~ /\[Broadcast\]/) {
		print OUT "$string";
	}
}
close (OUT);