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
my $MODEL="0";
#my $ORGFILENAME="1";
my $ORGFILENAME="0";
my $DATE="0";
#my $ISO="1";
my $ISO="0";
my $MODE="0";
#my $APT="1";
my $APT="0";
my $SHTR="0";
#my $EV="1";
my $EV="0";
my $FLEN="0";
my $DryRun="0";

GetOptions('model' => \$MODEL,
           'org' => \$ORGFILENAME,
           'date' => \$DATE,
           'iso' => \$ISO,
           'mode' => \$MODE,
           'f' => \$APT,
           'sht' => \$SHTR,
           'ev' => \$EV,
           'li' => \$LINFO,
           'fl' => \$FLEN,
           'no' => \$DryRun
       ) or pod2usage(2);

#オプション指定がなかったら
#if($MODEL+$ORGFILENAME+$DATE+$ISO+$MODE+$APT+$SHTR+$EV+$FLEN == 0){
#  pod2usage(2);
#}

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

  if($ORGFILENAME){
    $KEY .= "$name";
  }

  
  unless($exifInfo->{Error}){   #タグが正しく読めれば以下の処理
      $Maker =  $exifInfo->{Make}; #メーカータグ
      $CameraName = ($exifInfo->{Model});  #機種名
      $CameraName =~ s/\s+$//;          #機種名をトリム
      $CameraName =~ s/\s/-/g;          #機種名のスペースを "-"に変換
    
    if($MODEL){
      $KEY .= "_"."$CameraName";
    }

    if($LINFO){
      $lensinfo = $exifInfo->{LensInfo};
      $lensinfo =~ s/ //g;
      $lensinfo =~ s/\///g;
      $KEY .= "_"."$lensinfo";
    }

    if($DATE){
      $Date = $exifInfo->{ModifyDate};
      $Date =~ s/://g;
      $Date =~ s/\s/-/g;
      $Date = substr($Date,0,8);
      $KEY .= "_"."$Date";
    }

    if($ISO){
      $iso = $exifInfo->{ISO};
      $iso = sprintf("%05d",$iso);
      $KEY .= "_ISO".$iso;
    }
    
    if($APT){
      $F = $exifInfo->{Aperture};       #F値
      $KEY .= "_F".$F;
    }

    if($SHTR){
      $Shutter = $exifInfo->{ShutterSpeed}; #シャッタースピード
      $Shutter =~ s/1\///;              #1/XX の値を XXに変換
      $Shutter = sprintf("%04d",$Shutter);
      $KEY .= "_SH".$Shutter;
    }

    if($MODE){
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


    if($FLEN){
      $focallength = $exifInfo->{FocalLength};
      $focallength =~ s/ //g;
      $focallength =~ s/\.0//g;
      $KEY .= "_"."$focallength";
    }

    if($EV){
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


#        #'.' が 1つ以上あるか
#        if( index($name, '.',  0) != -1){
#            $suffix = (split(/\./, $name))[-1];  #拡張子取出し
#        }
    

    $KEY =~ s/^_//;
    $KEY =~ s/__/_/;
    
    #機器・モード・F値・シャッタースピード をキーにしてカウントアップさせる
    $FileHeader = $KEY;
    $hush{$KEY}++;
    
    #最終的なファイル名
#    $FileName = sprintf("%s_%03d.%s",$BaseDir.$FileHeader,$hush{$FileHeader},$suffix);
    if($hush{$FileHeader} > 1){
      $FileName = sprintf("%s_%03d%s",$BaseDir.$FileHeader,$hush{$FileHeader},$suffix);
    }else{
      $FileName = sprintf("%s%s",$BaseDir.$FileHeader,$suffix);
    }

    $FileName =~ s/__/_/;
    
    unless($DryRun){ #noフラグが立っている場合、実行しない
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

