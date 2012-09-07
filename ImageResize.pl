#!/usr/local/bin/perl -w

use Image::Magick;

$resizepath = "./imgresize";
$size = shift;

while(<@ARGV>){
  $file = $_;
my $image = Image::Magick->new;
  $image->Read($file);

#$width = $image->Get('width'); # �摜�̕�
#$height = $image->Get('height'); # �摜�̍���

  # ���ӎw��i�c������ێ��j
  $gmt = $size."x".$size;
$image->Resize(
    geometry => $gmt,
);
  
if (!-d $resizepath){
  mkdir $resizepath;
}

$imgpath = $resizepath."/".$file;

$image->Write($imgpath);
  
undef $image;  
#  if($width > $height){
#    
#  }
  
}


exit;