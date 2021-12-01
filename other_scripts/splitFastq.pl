       #!/usr/bin/perl

## Creates files for each individual from one or more fastq files. Individuals ids are given in a separate file with one ID per line.

use warnings;

$idfile = shift (@ARGV);
open (IDS, $idfile) or die;
while (<IDS>){
	chomp;
	$fh = "FQ"."$_";
	open ($fh, "> $_".".fastq") or die "Could not write\n";
	$files{$_} = $fh;
}
close (IDS);

foreach $in (@ARGV){
	open (IN, $in) or die;
	while (<IN>){
	chomp;
	if (/^\@([A-Z+\d]+_[A-Z+\d]+_[0-9]+)/){
		$id = $1;
		print "$id\n";
		if (defined $files{$id}){
			$flag = 1;
			print {$files{$id}} "$_\n";
		}
		else{
			$flag = 0;
		}
		foreach $i (0..2){
			$line = <IN>;
			if ($flag == 1){
				print {$files{$id}} "$line";
			}	
		}	
	}
	else{
		print "Error -- $_\n";
	}
	}
	close (IN);
}
foreach $id (keys %files){
    close ($files{$id});
}

