#!/usr/bin/perl w
#Date 2009/3/10
#ExifData�̏����o���X�N���v�g

use File::Basename;
use Image::ExifTool;

my $exifTool = new Image::ExifTool;
my $imgfilepath = "Resized";
#my $imglink ="file://cnt-nasred/OIMC/�e�[�}��/�ڕW�ݒ�/142PA/N1�����A���S���Y���]��/20090403_�{�ԎB�e2��";
#my $imglink ="file://D:/home/Kisogijyutsu/200804_�ڕW�ݒ�/�]������/work/";
#my $imglink ="file://D:/home/Kisogijyutsu/200804_�ڕW�ݒ�/�]������/work/";

@ARGV = sort @ARGV;
#open(H,">> sim_analyzer.txt");
print "<html><body><table>";
print ("<tr><th>�摜</th><th>�V�[��</th><th>�����O�t�@�C��</th><th>������t�@�C��</th><th>ISO</th><th>F�l</th><th>�V���b�^�[</th><th>�œ_����</th><th>FocusDistance</th><th>�������ʓx�F��[0]</th><th>���ӐF��[0]</th><th>�������ʓx�F��[1]</th><th>���ӐF��[1]</th><th>�������ʓx�F��[2]</th><th>���ӐF��[2]</th><th>�������ʓx�F��[3]</th><th>���ӐF��[3]</th><th>�������ʓx�F��[4]</th><th>���ӐF��[4]</th><th>�������ʓx�F��[5]</th><th>���ӐF��[5]</th><th>�������ʓx�F��[6]</th><th>���ӐF��[6]</th><th>�������ʓx�F��[7]</th><th>���ӐF��[7]</th><th>�����S�F��</th><th>���ӑS�F��</th><th>�F���M���ŏ��l(Cb)</th><th>�F���M���ŏ��l(Cr)</th><th>�F���M���ő�l(Cb)</th><th>�F���M���ő�l(Cr)</th><th>�@�ŏ��l(0-255):</th><th>�A�����l(0-255):</th><th>�B�ő�l(0-255):</th><th>�C�Õ����Ԓl(�@+�A)/2:</th><th>�D�������Ԓl(�A+�B)/2:</th><th>��ԇC-�D�̓x���W���x(0-1):</th><th>�@�������ʐF�x���ɂ��d��:</th><th>�A����/���Ӎ��ʐF�䗦�ɂ��d��:</th><th>�B���ʐF�P�x�ɂ��d��:</th><th>�v(�@�~�A�~�B):</th><th>�@�P�x�ő�l-�ŏ��l���ɂ��d��:</th><th>�A�����l�t�߃q�X�g�O�����W���x�ɂ��d��:</th><th>�B�K���}���グ�V�[���d�݂ɂ�鍷��:</th><th>�v(�@�~�A�~�B):</th><th>�@(�R���g���X�g�}���V�[���{�K���}���グ�V�[��)�d�݂̍���:</th><th>�@�������ʐF�x��(����1)�ɂ��d��:</th><th>�A����/���Ӎ��ʐF�䗦�ɂ��d��:</th><th>�B�������ʐF(����1)/(����2)�䗦�ɂ��d��:</th><th>�v(�@�~�A�~�B):</th><th>�@�������ʐF�x��(����1)�ɂ��d��:</th><th>�A����/���Ӎ��ʐF�䗦�ɂ��d��:</th><th>�B���Ӎ��ʐF�x��(����1)�ɂ��d��:</th><th>�v�@�~�A�~�B:</th><th>�F���j�[�}��MAX�d��(CKNEE_DEHANCE_MAX_RATIO):</th><th>����F�␳�V�[�������~�F���j�[�}������:</th><th>���F��:</th><th>���P�x���ʐF�x��:</th><th>���F�ʓx������(0-2):</th><th>����F�␳��1(Org):</th><th>����F�␳��2(Org):</th><th>����F�␳��1(�d�ݕ␳��)</th><th>����F�␳��2(�d�ݕ␳��)</th></tr>");
print "\r\n";
while(@ARGV){

  $file = shift @ARGV;
  $exifInfo = $exifTool->ImageInfo($file); 
  $KEY = "";
  
  unless($exifInfo->{Error}){   #�^�O���������ǂ߂�Έȉ��̏���
    $Maker =  $exifInfo->{Make}; #���[�J�[�^�O
    $CameraName = ($exifInfo->{Model});  #�@�햼
    $CameraName =~ s/\s+$//;          #�@�햼���g����
    $CameraName =~ s/\s/-/g;          #�@�햼�̃X�y�[�X�� "-"�ɕϊ�
    
    $iso = $exifInfo->{ISO};

    $F = $exifInfo->{Aperture};       #F�l

    $Shutter = $exifInfo->{ShutterSpeed}; #�V���b�^�[�X�s�[�h
#      $Shutter =~ s/\//�^/;              #1/XX �̒l�� XX�ɕϊ�
#      $Shutter = sprintf("%04d",$Shutter);
#      $KEY .= "_SH".$Shutter;


    $Ev = $exifInfo->{ExposureCompensation};
    $LensType =  $exifInfo->{LensType};
    $FocalLength =  $exifInfo->{FocalLength};
    $FocusDistance = $exifInfo->{FocusDistance};
    $FocusDistance =~ s/\s//g;
    
#    $BaseDir = dirname($file);  #�f�B���N�g�����擾
#    if ($BaseDir eq "."){       #�J�����g�Ȃ�Ȃɂ����Ȃ�
#      $BaseDir = "";
#    }else{
#      $BaseDir .= "/";
#    }

    my ($datfile, $path, $suffix) = fileparse($file);

        #'.' �� 1�ȏ゠�邩
        if( index($datfile, '.',  0) != -1){
            $suffix = (split(/\./, $datfile))[-1];  #�g���q��o��
        }
    $basename = $datfile;
    $datfile =~ s/$suffix/txt/;
    $datfile = $path.$datfile;
    
    $image = "<img src = '".$path.$imgfilepath."/".$basename."'>";
#    $file = "<a href=".$imglink.$file.">".$file."</a>";

    $procfile = $basename;
    $procfile =~ s/.JPG/_proc.bmp/i;
    $path =~ s/\///;
    $linkname = "=hyperlink\(\"\\\\cnt-nasred\\OIMC\\�e�[�}��\\�ڕW�ݒ�\\142PA\\N1�����A���S���Y���]��\\�B�e�摜\\".$path."\\".$basename."\"".","."\"".$basename.'")';
    $linkname_after = "=hyperlink\(\"\\\\cnt-nasred\\OIMC\\�e�[�}��\\�ڕW�ݒ�\\142PA\\N1�����A���S���Y���]��\\�B�e�摜\\".$path."\\".$procfile."\"".","."\"".$procfile.'")';
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
    unless((/^\/\//) || (/^\s/) || (/^\w/) || (/^\./) ||(/^\t/) || (/^\r\n/) || (/�J�E���g/)){
      @str = split(/\t/,$_);
      #      @str = split(/\t/,$_);
      #      print $str[1],"\r\n";
      $_ = $str[0];
      if(/�F��/ || /�F���M��/ || /����F�␳��/){
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
