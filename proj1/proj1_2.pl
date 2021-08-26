
#file: proj1_2.pl
#author: Caleb M. McLaren
#date: June 16th, 2021
#course: CMSC 433, UMBC, Prof. J. Dixon
#description:  question 2. I opted to just print search and replace results to 
# stdout rather than modify my targetFile or print the modified line to a new file. 
# But it should be really easy to see that I am prepared to do either modify the original 
# or print out to a new file. 

use strict;
use warnings;

my $targetFile = 'proj1_data_2.txt';
#my $cleanedFile = 'proj1_data_2_clean.txt';

open( my $fileHandle, '<', $targetFile ) 
    or die "Could not open file '$targetFile' $!";

#open( my $newFH, '>', $cleanedFile )
 #    or die "Could not open file '$cleanedFile' $!";


while (my $row = <$fileHandle>) {
    chomp $row;
    if ($row =~ s/(\W)(34[0-9]{9})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { # print $newFH "$row\n"
        print "$row\n"}
    elsif ($row =~ s/(\W)(37[0-9]{9})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    elsif ($row =~ s/(\W)(65[0-9]{10})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    elsif ($row =~ s/(\W)(6011[0-9]{8})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    elsif ($row =~ s/(\W)(51[0-9]{10})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    elsif ($row =~ s/(\W)(52[0-9]{10})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    elsif ($row =~ s/(\W)(53[0-9]{10})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    elsif ($row =~ s/(\W)(54[0-9]{10})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    elsif ($row =~ s/(\W)(55[0-9]{10})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    elsif ($row =~ s/(\W)(4[0-9]{8})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    elsif ($row =~ s/(\W)(4[0-9]{11})([0-9]{4})(\W)/$1\.\.\.$3$4/)
    { print "$row\n" }
    else {print "$row\n"}
}

close($fileHandle) 
    or warn "Could not close file '$targetFile': $!" ;

#close($newFH)
 #   or warn "Could not close file '$cleanedFile': $!" ;

print "proj1_2.pl done\n";