#!/usr/bin/perl
#
#画像ファイルのRGB信号値をファイルに出力する
#

use strict;
use Image::Magick;
use File::Basename;
#use Image::ExifTool;

# usage: $0 X Y width(px) heigh(px) [files]

my $Xps = shift @ARGV;
my $Yps = shift @ARGV;

my $w_pixels = shift @ARGV; #平均化するピクセル数（横）
my $h_pixels = shift @ARGV; #平均化するピクセル数（縦）

print $Xps,"-",$Yps," ",$w_pixels,"-",$h_pixels,"\n";

my @files = @ARGV;

my ($sec,$min,$hour,$mday,$mon,$year) = (localtime(time))[0..5]; #日付取得
$year += 1900;
$mon += 1;
$mday = substr("0".$mday,-2,2); 
$hour = substr("0".$hour,-2,2); #
my $outfile = "$year"."$mon"."$mday"."$hour"."$min"."$sec.txt";

#open (OUT, ">$outfile");

foreach my $file (@files){

my $image = Image::Magick->new;
#my $exifTool = new Image::ExifTool;

#my $exifInfo = $exifTool->ImageInfo($file); 
$image->Read($file);

my ($width, $height) = $image->Get('width', 'height');
#print $width,",",$height;

# ピクセル情報を得る
my @pixels = $image->GetPixels(width=>"$w_pixels", height=>"$h_pixels", x=>$Xps, y=>$Yps, map=>'RGB');
#my @pixels = $image->GetPixels(width=>10, height=>10, x=>$width/2, y=>$height/2, map=>'RGB');

# 画像から得たピクセルごとの色情報
my $i = 0;
my $value = "";
my ($r,$g,$b) = (0,0,0);
while (@pixels > 0) {
  $r += shift @pixels;
  $g += shift @pixels;
  $b += shift @pixels;
  $i++;
}

my $R = int($r/$i/256*100)/100;
my $G = int($g/$i/256*100)/100;
my $B = int($b/$i/256*100)/100;
#print OUT $file,",",$R,",",$G,",",$B;

#print $file,$exifInfo->{Aperture},",",$exifInfo->{ShutterSpeed},",",$1,",",$R,",",$G,",",$B,"\n";
#print OUT $file,",",$date,",",$ap,",",$sh,",",$ev,",",$ag,",",$R,",",$G,",",$B,"\n";

#print OUT $file,",",$R,",",$G,",",$B,"\n";
print $file,",",$R,",",$G,",",$B,"\n";

undef $image;
#undef $exifInfo;

}

sub rgb2xyz(){
  my ($r,$g,$b) = @_;
  my $R = ($r/255)^(2.2);
  my $G = ($g/255)^(2.2);
  my $B = ($b/255)^(2.2);
}

exit;
