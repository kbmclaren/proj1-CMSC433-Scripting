
#file: proj1_1.pl
#author: Caleb M. McLaren
#date: June 16th, 2021
#course: CMSC 433, UMBC, Prof. J. Dixon
#description:  question 1
use strict;
use warnings;

my $randomNum = int(rand(3));
#print "$randomNum\n";

my $targetFile = 'proj1_data.txt';

open( my $fileHandle, '<', $targetFile ) 
    or die "Could not open file '$targetFile' $!";

while (my $row = <$fileHandle>) {
    chomp $row;
    if ($row =~ /<name>(.+?)<\/name>/){
        if ($randomNum == 0 ){
            print "Delicious $1\n"
        }
        elsif ($randomNum == 1){
            print "Delightful $1\n"
        }
        else {
            print "Delectable $1\n"
        }
        
    } elsif ($row =~ /<price>\$(.+?)<\/price>/){
        my $priceTemp = $1 * 100;
        $priceTemp = $priceTemp + 50; 
        $priceTemp = $priceTemp/100; 
        print "\$$priceTemp\n"
    } elsif ($row =~ /<description>(.+?)<\/description>/){
        print "\"$1\"\n"
    } elsif ($row =~ /<calories>(\d+?)<\/calories>/){
        my $temp = $1 - 125; 
        print "$temp\n"
    }

}

close($fileHandle) 
    or warn "Could not close file '$targetFile': $!" ;

print "proj1_1.pl done\n";