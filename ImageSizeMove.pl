#!/usr/local/bin/perl -w

use Image::Magick;
use File::Copy;

$Yoko_path = "./Yoko";
$Tate_path = "./Tate";

if (!-d $Yoko_path){
  mkdir $Yoko_path;
}
if(!-d $Tate_path){
  mkdir $Tate_path;
}

while(<@ARGV>){
  $file = $_;
  my $image = Image::Magick->new;
  $image->Read($file);

  $width = $image->Get('width'); # �摜�̕�
  $height = $image->Get('height'); # �摜�̍���

  if($width > $height){
    move($file,$Yoko_path);
  }else{
    move($file,$Tate_path);
  }
  
undef $image;  
#  if($width > $height){
#    
#  }
  
}


exit;