#! C:\xampp\perl\bin\perl.exe

# Log censoring script.
#     - Lwc password censoring
#     - IP censoring (possibly use a salt?)
#
# Usage: perl Log-Cleaner.pl [logfile] 
#
# Stephen McGregor (c45y) 17/06/2011
#

$RESOURCE = $ARGV[0];
open DATA, "$RESOURCE" or die "can't open $RESOURCE $!";
$outfile = $RESOURCE;
my @loglist = <DATA>;
close (DATA);
$outfile =~ /(.+)(\.)(.+)/;
open (OUT, ">> $1clean$2$3") or die "can't open file $!";
print "Output: $1clean$2$3\n";
foreach $string (@loglist) {
	if ($string =~ m/(\d+)\.(\d+)\.(\d+)\.(\d+)/) {
		$string =~ s/(\d+)\.(\d+)\.(\d+)\.(\d+)/$1\.$2\.###\.###/;
	}
	if ($string =~ m/(lwc -c password)(.+)/) {
		$string =~ s/(lwc -c password)(.+)/$1 ###/;
	}
	if ($string =~ m/(cpassword)(.+)/) {
		$string =~ s/(cpassword)(.+)/$1 ###/;
	}
	if ($string =~ m/(lwc -u)(.+)/) {
		$string =~ s/(lwc -u)(.+)/$1 ###/;
	}
	if ($string =~ m/(lwc -unlock)(.+)/) {
		$string =~ s/(lwc -unlock)(.+)/$1 ###/; 
	}
	if ($string =~ m/(cunlock)(.+)/) {
		$string =~ s/(cunlock)(.+)/$1 ###/;
	}
	print OUT "$string";
}
close (OUT);