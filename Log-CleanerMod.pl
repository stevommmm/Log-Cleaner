#! /usr/bin/perl

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
	$string =~ s/(.*)(SEVERE\])(.*)//g;	
	$string =~ s/(\/cmsg)\s(\S+)\s(.+)/$1 $2 #Removed#/;
	$string =~ s/(\/msg)\s(\S+)\s(.+)/$1 $2 #Removed#/;
	$string =~ s/(\/m)\s(\S+)\s(.+)/$1 $2 #Removed#/;
	$string =~ s/(\/t)\s(\S+)\s(.+)/$1 $2 #Removed#/;
	$string =~ s/(\/tell)\s(\S+)\s(.+)/$1 $2 #Removed#/;
	$string =~ s/(\/r)\s(.+)/$1 #Removed#/;
	$string =~ s/(at \(\[world\])(.*)/$1 #Removed#\)/;
	$string =~ s/(at \(\[world_nether\])(.*)/$1 #Removed#\)/;
	$string =~ s/\[[a-z0-9]+m//g;
	if ($string =~ m/(\d+)\.(\d+)\.(\d+)\.(\d+)/) {
		$string =~ s/(\d+)\.(\d+)\.(\d+)\.(\d+)/$1 . "." . $2 . "." . "##.##"/e;
		# . crypt($3,"s") . "." . crypt($4,"s")/e;
	}
	if ($string =~ m/(lwc -c password)(.+)/) {
		$string =~ s/(lwc -c password)(.+)/$1 #Removed#/;
	}
	if ($string =~ m/(cpassword)(.+)/) {
		$string =~ s/(cpassword)(.+)/$1 #Removed#/;
	}
	if ($string =~ m/(lwc -u)(.+)/) {
		$string =~ s/(lwc -u)(.+)/$1 #Removed#/;
	}
	if ($string =~ m/(lwc -unlock)(.+)/) {
		$string =~ s/(lwc -unlock)(.+)/$1 #Removed#/; 
	}
	if ($string =~ m/(cunlock)(.+)/) {
		$string =~ s/(cunlock)(.+)/$1 #Removed#/;
	}
	chomp $string;
	if ($string =~ /[a-zA-Z0-1]+/) {
		print OUT "$string\n";
	}
}
close (OUT);
