#!/usr/local/bin/perl -w

use Image::Magick;

$resizepath = "./imgresize";
$size = shift;

while(<@ARGV>){
  $file = $_;
my $image = Image::Magick->new;
  $image->Read($file);

#$width = $image->Get('width'); # ‰æ‘œ‚Ì•
#$height = $image->Get('height'); # ‰æ‘œ‚Ì‚‚³

  # ’·•ÓŽw’èic‰¡”ä‚ðˆÛŽj
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