#!/usr/bin/perl w
#Date 2009/3/10
#ExifDataの書き出しスクリプト

use File::Basename;
use Image::ExifTool;

my $exifTool = new Image::ExifTool;
my $imgfilepath = "Resized";
#my $imglink ="file://cnt-nasred/OIMC/テーマ別/目標設定/142PA/N1向けアルゴリズム評価/20090403_本番撮影2日";
#my $imglink ="file://D:/home/Kisogijyutsu/200804_目標設定/評価検討/work/";
#my $imglink ="file://D:/home/Kisogijyutsu/200804_目標設定/評価検討/work/";

@ARGV = sort @ARGV;
#open(H,">> sim_analyzer.txt");
print "<html><body><table>";
print ("<tr><th>画像</th><th>シーン</th><th>処理前ファイル</th><th>処理後ファイル</th><th>ISO</th><th>F値</th><th>シャッター</th><th>焦点距離</th><th>FocusDistance</th><th>中央高彩度色相[0]</th><th>周辺色相[0]</th><th>中央高彩度色相[1]</th><th>周辺色相[1]</th><th>中央高彩度色相[2]</th><th>周辺色相[2]</th><th>中央高彩度色相[3]</th><th>周辺色相[3]</th><th>中央高彩度色相[4]</th><th>周辺色相[4]</th><th>中央高彩度色相[5]</th><th>周辺色相[5]</th><th>中央高彩度色相[6]</th><th>周辺色相[6]</th><th>中央高彩度色相[7]</th><th>周辺色相[7]</th><th>中央全色相</th><th>周辺全色相</th><th>色差信号最小値(Cb)</th><th>色差信号最小値(Cr)</th><th>色差信号最大値(Cb)</th><th>色差信号最大値(Cr)</th><th>①最小値(0-255):</th><th>②中央値(0-255):</th><th>③最大値(0-255):</th><th>④暗部中間値(①+②)/2:</th><th>⑤明部中間値(②+③)/2:</th><th>区間④-⑤の度数集中度(0-1):</th><th>①中央高彩色度数による重み:</th><th>②中央/周辺高彩色比率による重み:</th><th>③高彩色輝度による重み:</th><th>計(①×②×③):</th><th>①輝度最大値-最小値幅による重み:</th><th>②中央値付近ヒストグラム集中度による重み:</th><th>③ガンマ持上げシーン重みによる差分:</th><th>計(①×②×③):</th><th>①(コントラスト抑制シーン＋ガンマ持上げシーン)重みの差分:</th><th>①中央高彩色度数(順位1)による重み:</th><th>②中央/周辺高彩色比率による重み:</th><th>③中央高彩色(順位1)/(順位2)比率による重み:</th><th>計(①×②×③):</th><th>①中央高彩色度数(順位1)による重み:</th><th>②中央/周辺高彩色比率による重み:</th><th>③周辺高彩色度数(順位1)による重み:</th><th>計①×②×③:</th><th>色差ニー抑制MAX重み(CKNEE_DEHANCE_MAX_RATIO):</th><th>特定色補正シーン差分×色差ニー抑制差分:</th><th>肌色数:</th><th>高輝度無彩色度数:</th><th>肌色彩度強調量(0-2):</th><th>特定色補正量1(Org):</th><th>特定色補正量2(Org):</th><th>特定色補正量1(重み補正後)</th><th>特定色補正量2(重み補正後)</th></tr>");
print "\r\n";
while(@ARGV){

  $file = shift @ARGV;
  $exifInfo = $exifTool->ImageInfo($file); 
  $KEY = "";
  
  unless($exifInfo->{Error}){   #タグが正しく読めれば以下の処理
    $Maker =  $exifInfo->{Make}; #メーカータグ
    $CameraName = ($exifInfo->{Model});  #機種名
    $CameraName =~ s/\s+$//;          #機種名をトリム
    $CameraName =~ s/\s/-/g;          #機種名のスペースを "-"に変換
    
    $iso = $exifInfo->{ISO};

    $F = $exifInfo->{Aperture};       #F値

    $Shutter = $exifInfo->{ShutterSpeed}; #シャッタースピード
#      $Shutter =~ s/\//／/;              #1/XX の値を XXに変換
#      $Shutter = sprintf("%04d",$Shutter);
#      $KEY .= "_SH".$Shutter;


    $Ev = $exifInfo->{ExposureCompensation};
    $LensType =  $exifInfo->{LensType};
    $FocalLength =  $exifInfo->{FocalLength};
    $FocusDistance = $exifInfo->{FocusDistance};
    $FocusDistance =~ s/\s//g;
    
#    $BaseDir = dirname($file);  #ディレクトリを取得
#    if ($BaseDir eq "."){       #カレントならなにもしない
#      $BaseDir = "";
#    }else{
#      $BaseDir .= "/";
#    }

    my ($datfile, $path, $suffix) = fileparse($file);

        #'.' が 1つ以上あるか
        if( index($datfile, '.',  0) != -1){
            $suffix = (split(/\./, $datfile))[-1];  #拡張子取出し
        }
    $basename = $datfile;
    $datfile =~ s/$suffix/txt/;
    $datfile = $path.$datfile;
    
    $image = "<img src = '".$path.$imgfilepath."/".$basename."'>";
#    $file = "<a href=".$imglink.$file.">".$file."</a>";

    $procfile = $basename;
    $procfile =~ s/.JPG/_proc.bmp/i;
    $path =~ s/\///;
    $linkname = "=hyperlink\(\"\\\\cnt-nasred\\OIMC\\テーマ別\\目標設定\\142PA\\N1向けアルゴリズム評価\\撮影画像\\".$path."\\".$basename."\"".","."\"".$basename.'")';
    $linkname_after = "=hyperlink\(\"\\\\cnt-nasred\\OIMC\\テーマ別\\目標設定\\142PA\\N1向けアルゴリズム評価\\撮影画像\\".$path."\\".$procfile."\"".","."\"".$procfile.'")';
#    @out = ($image,$path,$basename,$CameraName,$iso,$F,$Shutter,$FocalLength,$FocusDistance);
    @out = ($image,$path,$linkname,$linkname_after,$iso,$F,$Shutter,$FocalLength,$FocusDistance);    
      open(IN,$datfile);
#  while(<IN>){
#    $all_data .= $_;
#  }

  @lines = <IN>;
  while(@lines){
    $_ = shift @lines;

#    $_ = shift @str;
    unless((/^\/\//) || (/^\s/) || (/^\w/) || (/^\./) ||(/^\t/) || (/^\r\n/) || (/カウント/)){
      @str = split(/\t/,$_);
      #      @str = split(/\t/,$_);
      #      print $str[1],"\r\n";
      $_ = $str[0];
      if(/色相/ || /色差信号/ || /特定色補正量/){
        push (@out, ($str[1],$str[2]));
      }else{
        push (@out,$str[1]);
      }
    }
  }
#  @out2 = map {"<td style='mso-number-format:\"\\\@\";'>".$_."</td>"} @out;
    @out2 = map {"<td>".$_."</td>"} @out;
    $shut = $out2[6];
    $shut =~ s/<td>/<td style='mso-number-format:\"\\\@\";'>/;
    $out2[6] = $shut;
#  @out2 = map(s/\r\n//,@out);
    $_ = join(" ",@out2);    
#    $_ = join(",",@out);
    $_ =~ s/\r\n//g;
    print "<tr>".$_."</tr>";    
#    print $_;
    print "\r\n";
  }
}
print "</table></body></html>";
