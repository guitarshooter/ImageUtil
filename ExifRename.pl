#!/usr/bin/perl
use File::Basename;
use Image::ExifTool; 

# �ե饰�������Τ�ե�����̾��
my $MODEL="0";
my $ORGFILENAME="1";
my $DATE="0";
my $ISO="0";
my $MODE="0";
my $APT="0";
my $SHTR="0";
my $EV="1";

my $regex_suffix = qw/\.[^\.]+$/;


my $exifTool = new Image::ExifTool;
my $cnt = 1;

@ARGV = sort @ARGV;

open(OUT,">renamefile.txt");

while(@ARGV){

  $file = shift @ARGV;
  $exifInfo = $exifTool->ImageInfo($file); 
  $FileName; #�ǽ��ե�����̾

  $KEY = "";

  my ($name, $path, $suffix) = fileparse($file,$regex_suffix);

  if($ORGFILENAME){
    $KEY .= "$name";
  }

  
  unless($exifInfo->{Error}){   #�������������ɤ��аʲ��ν���
      $Maker =  $exifInfo->{Make}; #�᡼��������
      $CameraName = ($exifInfo->{Model});  #����̾
      $CameraName =~ s/\s+$//;          #����̾��ȥ��
      $CameraName =~ s/\s/-/g;          #����̾�Υ��ڡ����� "-"���Ѵ�
    
    if($MODEL){
      $KEY .= "$CameraName";
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
      $KEY .= "_ISO".$iso;
    }
    
    if($APT){
      $F = $exifInfo->{Aperture};       #F��
      $KEY .= "_F".$F;
    }

    if($SHTR){
      $Shutter = $exifInfo->{ShutterSpeed}; #����å������ԡ���
      $Shutter =~ s/1\///;              #1/XX ���ͤ� XX���Ѵ�
      $Shutter = sprintf("%04d",$Shutter);
      $KEY .= "_SH".$Shutter;
    }

    if($MODE){
      #�����ž夲�⡼�ɤξ��ʬ��
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

    if($EV){
      $Ev = $exifInfo->{ExposureCompensation};
      $Ev = eval($Ev);  #Ev��ʬ���ξ��ˡ��������Ѵ���
      $Ev = sprintf("%2.1f",$Ev);
#      $Ev =~ s/-/m/g;
      $Ev =~ s/\+/p/g;
      $KEY .= "_EV".$Ev;
    }

    $BaseDir = dirname($file);  #�ǥ��쥯�ȥ�����
    if ($BaseDir eq "."){       #�����Ȥʤ�ʤˤ⤷�ʤ�
      $BaseDir = "";
    }else{
      $BaseDir .= "/";
    }


#        #'.' �� 1�İʾ夢�뤫
#        if( index($name, '.',  0) != -1){
#            $suffix = (split(/\./, $name))[-1];  #��ĥ�Ҽ�Ф�
#        }
    

    $KEY =~ s/^_//;
    $KEY =~ s/__/_/;
    
    #����⡼�ɡ�F�͡�����å������ԡ��� �򥭡��ˤ��ƥ�����ȥ��åפ�����
    $FileHeader = $KEY;
    $hush{$KEY}++;
    
    #�ǽ�Ū�ʥե�����̾
#    $FileName = sprintf("%s_%03d.%s",$BaseDir.$FileHeader,$hush{$FileHeader},$suffix);
    $FileName = sprintf("%s_%03d%s",$BaseDir.$FileHeader,$hush{$FileHeader},$suffix);
    $FileName =~ s/__/_/;
    
    rename($file,$FileName);     #�ե�����̾�ѹ�
    print OUT $file." -> ".$FileName."\n";  #ɸ����Ϥ˽񤭽Ф���ǰ�Τ����
    print $file." -> ".$FileName."\n";  #ɸ����Ϥ˽񤭽Ф���ǰ�Τ����

    $cnt++;
  }
}
