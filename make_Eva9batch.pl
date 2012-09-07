#!/usr/bin/perl
use Cwd;
use Image::ExifTool;

#Eva7のパラメータファイルパス
$parampath = 'D:\home\bin\Eva\Eva9\Data\paramdt';
#i-FINISHを適応するdc9ファイルのファイル名（パラメータパスにおいてあること）
$EMParam = '差分_iFINISH.dc9';
$YKParam = 'S0019_VIVID_彩度+2差分_sRGB.dc7';
#$CsParam = 'yokuseiEva9.dc7';
$CsParam = '差分_yokuseiEva9.dc9';
$CsParam2 = '差分_NV_肌＆緑残し.dc9';
@OldModel = ('E-3', 'E-300', 'E-410','E-420', 'E-450', 'E-520', 'E-510', 'E-500'); #センサが異なる機種
$OldParam = '差分_old_camera.dc9'; #センサが異なる機種用差分パラメータファイル
$OldCsParam = '差分_yokuseiEva9_old_camera.dc9'; #センサが異なる機種用差分パラメータファイル

my $exifTool = new Image::ExifTool;

#i-FINISHフラグ。0:Natural,1:i-FINISH で現像。
$mode = shift(@ARGV);

#引数チェック
if($mode !~ m/^\d{1}$/){
  print "Usage:$0 ModeName[1:i-FINISH,0:Natural,2:Vivid+2,9:カスタマイズ] File"."\n";
  exit;
}

@ARGV = sort @ARGV;

while(@ARGV) {
  $file = shift @ARGV;
  $file = Cwd::abs_path("$file");    
  #cygwinのドライブレター変更
  if($file =~ /^\/cygdrive\// ){
    $file =~ s/\/cygdrive\/([a-zA-Z])/uc($1).":"/e;
    $file =~ s/\//\\/g;
  }  
  #ORFファイル以外はスキップする
  unless($file =~ m/.orf$/i) {
    print "//".$file." is not ORF file."."\n";
  #ORFファイルなら
  }else{
#    my @list = (0,0,B,UP,BIG,12,655360); #バッチファイルの固定部分    
    @list = (3720, 2800, R, UP, LITTLE, 12, 0); # S0027_ISO***_sRGBNatural.dc9,<OB>,<WBGain>,<ColorMatrix>
      #Eva9Prm.exe を実行。実行したディレクトリに filename.dc7 ファイルが作成される
      #system $Eva9Prmpath,$file;

    $exifInfo = $exifTool->ImageInfo($file); 
  
    unless($exifInfo->{Error}){   #タグが正しく読めれば以下の処理
      $iso = $exifInfo->{ISO};
      
      #Eva9パラメータファイル選択
      if($iso <= 160){
        $iso = 100;
      }elsif(($iso > 160) && ($iso <= 250) ){
        $iso = 200;      
      }elsif(($iso > 250) && ($iso <= 600) ){
        $iso = 400;
      }elsif(($iso > 600) && ($iso <= 1150)){
        $iso = 800;
      }elsif(($iso > 1200) && ($iso <= 2400)){
        $iso = 1600;
      }elsif(($iso > 2400) && ($iso <= 4800)){
        $iso = 3200;      
      }elsif(($iso > 4800)){
        $iso = 6400;    
      }

      $model = $exifInfo->{Model};
      $oldmodelcnt = grep(/^$model$/,@OldModel);
    }
    $iso = sprintf("%04d",$iso);    
    
    # パラメータファイル名
    $param = $parampath.'\S0027_ISO'.$iso.'_sRGBNatural.dc9';

#    #DC7差分ファイルのパス
#    $dc7file = $file;
#    $dc7file =~ s/.orf$/.dc7/i;
#    @paramlist = ($param,$dc7file);
    @paramlist = ($param,"<OB>","<WBGain>","<ColorMatrix>");

    if($oldmodelcnt > 0 && $mode != 9){
        push(@paramlist,$parampath."\\".$OldParam);
    }
  }
    
    #現像した画像のファイル名
    $file =~  s|/|\\|g;
    $bmpfile = $file;
#    $bmpfile =~ s|/|\\|g;
    if($mode == 0){
      $bmpfile =~ s/.orf$/_0Natural.jpg/i;
    }elsif($mode == 1){
      #iFINISH現像の場合
      $bmpfile =~ s/.orf$/_1iFINISH.jpg/i;
      push(@paramlist,$parampath."\\".$EMParam); 
    }elsif($mode == 2){
      $bmpfile =~ s/.orf$/_2Vivid2.jpg/i;
      push(@paramlist,$parampath."\\".$YKParam); 
    }else{
      $bmpfile =~ s/.orf$/_9yokusei緑＆肌残しEva9.jpg/i;
      if($oldmodelcnt > 0){
        push(@paramlist,$parampath."\\".$OldCsParam);
        push(@paramlist,$parampath."\\".$CsParam2);       
      }else{
        push(@paramlist,$parampath."\\".$CsParam);
        push(@paramlist,$parampath."\\".$CsParam2);
      }
    }

  unshift(@list,$file,$bmpfile);
  push(@list,@paramlist);
  $batch = join(",",@list);
  print $batch."\n";
}

