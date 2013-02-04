#!/usr/bin/perl
use File::Basename;
use Image::ExifTool; 
use Getopt::Long;
use Pod::Usage;
use utf8;

# Check ARGV.
if (-1 == $#ARGV) {
 pod2usage(2);
}
 


# フラグがあるものをファイル名に
GetOptions(\%opt,'model', 'org','date','iso','mode',
                 'f','sht','ev','li','fl','no') or pod2usage(2);

my $regex_suffix = qw/\.[^\.]+$/;

my $exifTool = new Image::ExifTool;
my $cnt = 1;

@ARGV = sort @ARGV;

open(OUT,">renamefile.txt");

while(@ARGV){

  $file = shift @ARGV;
  $exifInfo = $exifTool->ImageInfo($file); 
  $FileName; #最終ファイル名

  $KEY = "";

  my ($name, $path, $suffix) = fileparse($file,$regex_suffix);

  if($opt{org}){
    $KEY .= "$name";
  }

  unless($exifInfo->{Error}){   #タグが正しく読めれば以下の処理
      $Maker =  $exifInfo->{Make}; #メーカータグ

    if($opt{model}){
      $CameraName = ($exifInfo->{Model});  #機種名
      $CameraName =~ s/\s+$//;          #機種名をトリム
      $CameraName =~ s/\s/-/g;          #機種名のスペースを "-"に変換
      $KEY .= "_"."$CameraName";
    }

    if($opt{li}){
      $lensinfo = $exifInfo->{LensInfo};
      $lensinfo =~ s/ //g;
      $lensinfo =~ s/\///g;
      $KEY .= "_"."$lensinfo";
    }

    if($opt{date}){
      $Date = $exifInfo->{ModifyDate};
      $Date =~ s/://g;
      $Date =~ s/\s/-/g;
      $Date = substr($Date,0,8);
      $KEY .= "_"."$Date";
    }

    if($opt{iso}){
      $iso = $exifInfo->{ISO};
      $iso = sprintf("%05d",$iso);
      $KEY .= "_ISO".$iso;
    }
    
    if($opt{f}){
      $F = $exifInfo->{Aperture};       #F値
      $KEY .= "_F".$F;
    }

    if($opt{sht}){
      $Shutter = $exifInfo->{ShutterSpeed}; #シャッタースピード
      $Shutter =~ s/1\///;              #1/XX の値を XXに変換
      $Shutter = sprintf("%04d",$Shutter);
      $KEY .= "_SH".$Shutter;
    }

    if($opt{mode}){
      #画像仕上げモードの場合分け
      if( $Maker =~ /NIKON/i  ) {
        if( $CameraName =~ /D/i ){
          $PicMode = "$exifInfo->{PictureControlName}";
        }else{
          $PicMode = "$exifInfo->{ImageOptimization}";
        }
      }elsif( $Maker =~ /OLYMPUS/i ){
        $PicMode = "$exifInfo->{PictureMode}";
        $PicMode =~ s/;.*$//;
        if($PicMode eq "Unknown (1 2)"){
          $PicMode = "Vivid";
        }elsif($PicMode eq "Unknown (2 2)"){
          $PicMode = "Natural";
        }elsif($PicMode eq "Unknown (4 2)"){
          $PicMode = "Portrait";          
        }
      }elsif( $Maker =~ /Canon/i ){
        $PicMode = "$exifInfo->{PictureStyle}";
      }elsif( $Maker =~ /FUJIFILM/i ){
        $PicMode = "$exifInfo->{FilmMode}";
        $PicMode =~ s/^F.*\///;
      }elsif( $Maker =~ /SONY/i ){
        $PicMode = "$exifInfo->{ColorMode}";
      }elsif( $Maker =~ /PENTAX/i ){
        $PicMode = "$exifInfo->{ImageTone}";
      }
      $PicMode =~ s/ //g;
      $KEY .= "_"."$PicMode";
    }


    if($opt{fl}){
      $focallength = $exifInfo->{FocalLength};
      $focallength =~ s/ //g;
      $focallength =~ s/\.0//g;
      $KEY .= "_"."$focallength";
    }

    if($opt{ev}){
      $Ev = $exifInfo->{ExposureCompensation};
      $Ev = eval($Ev);  #Evが分数の場合に、小数に変換。
      $Ev = sprintf("%2.1f",$Ev);
#      $Ev =~ s/-/m/g;
      $Ev =~ s/\+/p/g;
      $KEY .= "_EV".$Ev;
    }

    $BaseDir = dirname($file);  #ディレクトリを取得
    if ($BaseDir eq "."){       #カレントならなにもしない
      $BaseDir = "";
    }else{
      $BaseDir .= "/";
    }


    $KEY =~ s/^_//;
    $KEY =~ s/__/_/;

    #機器・モード・F値・シャッタースピード をキーにしてカウントアップさせる
    $FileHeader = $KEY;
    $hush{$KEY}++;

    #最終的なファイル名
    if($hush{$FileHeader} > 1){
      $FileName = sprintf("%s_%03d%s",$BaseDir.$FileHeader,$hush{$FileHeader},$suffix);
    }else{
      $FileName = sprintf("%s%s",$BaseDir.$FileHeader,$suffix);
    }

    $FileName =~ s/__/_/;
    
    unless($opt{no}){ #noフラグが立っている場合、実行しない
      rename($file,$FileName);     #ファイル名変更
    }
    print OUT $file." -> ".$FileName."\n";  #ログファイルに書き出す
    print $file." -> ".$FileName."\n";  #標準出力に書き出す

    $cnt++;
  }
}

__END__


=head1 NAME

Exif Rename Tool

=head1 SYNOPSIS

ExifRename.pl [options] [file ...]

 RenameMode:
   --model  CameraModelName
   --org    Original Filename
   --fl     FocalLength
   --date   Date
   --iso    ISO
   --mode   PictureMode
   --f      Apature
   --sht    ShutterSpeed
   --li     LensInfo
   --ev     ExposureCompensation
 Options:
   --no     Display Only(Dry Run)

=cut

