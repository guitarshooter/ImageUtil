#!/usr/bin/perl
use Image::ExifTool; 
use Getopt::Long;
use Pod::Usage;

# Check ARGV.
if ($#ARGV < 3){
 pod2usage(3);
}

GetOptions('disp' => \$DISP) or pod2usage(2);

my $exifkey = shift @ARGV;
my $exifvalue = shift @ARGV;

while(@ARGV){
  my($file) = shift @ARGV;
  my($exifTool) = new Image::ExifTool; 
  my($exifInfo) = $exifTool->ImageInfo($file); 

  if($exifInfo->{$exifkey} =~ /$exifvalue/){
    if($DISP){
      $label = ":".$exifkey.":".$exifInfo->{$exifkey};
    }
    print $file.$label."\n";
  }
}

__END__


=head1 NAME

Exif Rename Tool

=head1 SYNOPSIS

ExifGrep.pl [--disp] [ExifKey] [Value] [file ...]

=cut

