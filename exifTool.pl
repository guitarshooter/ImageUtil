#!/usr/bin/perl
use Image::ExifTool; 

while(@ARGV){
  my($file) = shift @ARGV;
  my($exifTool) = new Image::ExifTool; 
  my($exifInfo) = $exifTool->ImageInfo($file); 

#$exifTool->SetNewValue("UserComment","EV:-2,ANGLE:5");
#$exifTool->SetNewValue(Keywords => "yee", AddValue => 1);
#$exifTool->WriteInfo($file);
my($key); 
for $key (sort keys %$exifInfo){ 
print("$key : $exifInfo->{$key}\n");
#print("ISO : $exifInfo->{ISO}\n"); 
}
}
