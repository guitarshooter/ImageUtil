#!/usr/bin/perl -w

use strict;
use Image::Magick;

#my $file = "PA226620.JPG";
my $w_pixels = 10; #平均化するピクセル数（横）
my $h_pixels = 10; #平均化するピクセル数（縦）

#open (OUT, ">Pixels_RAW.txt");

foreach my $file (@ARGV){
my $image = Image::Magick->new;

$image->Read($file);

my ($width, $height) = $image->Get('width', 'height');
#print $width,",",$height;


# ピクセル情報を得る
#my @pixels = $image->GetPixels(width=>"$w_pixels", height=>"$h_pixels", x=>$width/2, y=>$height/2, map=>'RGB');
my @pixels = $image->GetPixels(width=>10, height=>10, x=>$width/2, y=>$height/2, map=>'RGB');

# 画像から得たピクセルごとの色情報
my $i = 0;
my $value = "";
my ($r,$g,$b) = (0,0,0);
while (@pixels > 0) {
  $r += shift @pixels;
  $g += shift @pixels;
  $b += shift @pixels;
  $i++;
#  print OUT $value;
#  if($i%3 == 0){
#    print OUT "\n";
#  }else{
#    print OUT ",";
#  }

}
my $R = $r/$i/256;
my $G = $g/$i/256;
my $B = $b/$i/256;
#print OUT $file,",",$R,",",$G,",",$B;
print $file,",",$R,",",$G,",",$B,"\n";

undef $image;

}

exit;
