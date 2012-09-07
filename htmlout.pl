#!/usr/bin/perl
#Date 2009/3/10
#ExifDataの書き出しスクリプト

use File::Basename;
use Image::ExifTool;

#my $imglink ="file://cnt-nasred/OIMC/テーマ別/目標設定/142PA/N1向けアルゴリズム評価/20090403_本番撮影2日";
#my $imglink ="file://D:/home/Kisogijyutsu/200804_目標設定/評価検討/work/";
#my $imglink ="file://D:/home/Kisogijyutsu/200804_目標設定/評価検討/work/";

@ARGV = sort @ARGV;
print "<html><body><table>";
print ("<tr><th>画像</th><th>ファイル名</th></tr>");
print "\r\n";
while(@ARGV){

  $file = shift @ARGV;
    
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
    
    $image = "<img src = '".$path."/".$basename."'>";
#    $file = "<a href=".$imglink.$file.">".$file."</a>";

    @out = ($image);
    push (@out,$basename);

#  @out2 = map {"<td style='mso-number-format:\"\\\@\";'>".$_."</td>"} @out;
    @out2 = map {"<td>".$_."</td>"} @out;

#  @out2 = map(s/\r\n//,@out);
    $_ = join(" ",@out2);    
#    $_ = join(",",@out);
    $_ =~ s/\n//g;
    print "<tr>".$_."</tr>";    
#    print $_;
    print "\n";
  }
print "</table></body></html>";
