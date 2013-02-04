#!/usr/bin/perl
use Image::ExifTool;
use Getopt::Long;
use Pod::Usage;
use strict;
use warnings;

# Check ARGV.

my $DISP = 0;
my $SHOW = 0;
my $exifkey = "";
my $exifvalue = "";
GetOptions('disp' => \$DISP,
           'show' => \$SHOW,
           'key=s' => \$exifkey,
           'value=s' => \$exifvalue
       ) or pod2usage(2);

my $label="";

while(@ARGV){
  my($file) = shift @ARGV;
  my($exifTool) = new Image::ExifTool; 
  my($exifInfo) = $exifTool->ImageInfo($file); 
  #$exifTool->Options(Sort => 'Group0');
  my @tags = $exifTool->GetTagList($exifInfo, 'Group0'); #タグ情報
  my $key = "";

  # --show フラグの場合、ファイル名とExif情報を表示。
  if($SHOW){
    foreach $key (@tags){
      print "$file : $key : $exifInfo->{$key}\n";
    }
    next;
  }

  #指定したキーが存在しない場合はエラー
  if(!exists $exifInfo->{$exifkey}){
    print "$exifkey"." is not exist in Exif.\n";
    exit 9;
  }

  if($exifInfo->{$exifkey} =~ /$exifvalue/){
  # --disp フラグの場合、指定した引数と値を確認表示
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

ExifGrep.pl [--show] [[--disp] [ExifKey] [Value]] [file ...]

  Options:
    --show  Show All Exif Infomation.
    --disp  Print ExifKey and Value.

=cut

