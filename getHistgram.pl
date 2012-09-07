#
#画像ファイルのヒストグラムを出力
#
use GD::Graph::bars;
use GD::Graph::lines;
use Image::Magick;
use File::Basename;

my @files = @ARGV;

print "全ピクセル平均","\n";
print "filename,R,G,B,Y,Cb,Cr,|Cb||Cr|","\n";
while(<@files>){
  $file = $_;

  my ($filename, $filepath, $filesuffix) = fileparse($_, ());
  my $image = Image::Magick->new;
$image->Read($file);

my ($width, $height) = $image->Get('width', 'height');

($w_pixels,$h_pixels,$Xps,$Yps) = ($width,$height,0,0);
  
#print "Size:",$width,",",$height," XpsYps:(",$Xps,",",$Yps,")","Pixels:",$w_pixels,",",$h_pixels,"\n";

  
# ピクセル情報を得る
my @pixels = $image->GetPixels(width=>"$w_pixels", height=>"$h_pixels", x=>$Xps, y=>$Yps, map=>'RGB');

# 画像から得たピクセルごとの色情報
my $i = 0;
my $value = "";
my ($r_,$g_,$b_) = (0,0,0);
my ($r_sum,$g_sum,$b_sum) = (0,0,0);
my %rh=();
  for($i=0;$i<=255;$i++){
    $rh{$i}=0;
  }
my @label=();
my @data=();
my @dataset=();
my $i = 0;
while (@pixels > 0) {
  $r_ = shift @pixels;
  $g_ = shift @pixels;
  $b_ = shift @pixels;
  $r_ =int($r_/256);
  $g_ =int($g_/256);
  $b_ =int($b_/256);

  ($Y,$Cb,$Cr) = rgb2ycbcr($r_,$g_,$b_);
  
  $rh{$Y}=$rh{$Y}+1;
  $r_sum += $r_;
  $g_sum += $g_;
  $b_sum += $b_;
  $i++;
}
my $R = int($r_sum/$i*100)/100;
my $G = int($g_sum/$i*100)/100;
my $B = int($b_sum/$i*100)/100;

my ($Y,$Cb,$Cr) = rgb2ycbcr($R,$G,$B);

print $filename,",",$R,",",$G,",",$B,",",$Y,",",$Cb,",",$Cr,"\n";
for ( sort { $a <=> $b }  keys %rh  ) {
#  $l = int($_/256);
#  print "$_ , $rh{$_}\n";
  push (@label,$_);
  push(@data,$rh{$_});
}

my @dataset = (\@label,\@data);

my $graph = GD::Graph::lines->new( 800, 600 );
$graph->set(y_max_value => 15000,
            x_label_skip => 10,
            line_width => 3);
my $graphimage = $graph->plot( \@dataset );
open( OUT, "> histgram_$filename") or die( "Cannot open file: graph.jpg" );
binmode OUT;
print OUT $graphimage->jpeg();
close OUT;

undef $image;


}

sub rgb2xyz(){
  my ($r_,$g_,$b_) = @_;
  my $R = ($r_/255)^(2.2);
  my $G = ($g_/255)^(2.2);
  my $B = ($b_/255)^(2.2);
}

sub rgb2ycbcr(){
  my ($r_,$g_,$b_) = @_;
  my $Y = int(0.299*$r_+0.587*$g_+0.114*$b_);
  my $Cb = int(0.500*$r_-0.419*$g_-0.081*$b_);
  my $Cr = int(-0.169*$r_-0.332*$g_+0.500*$b_);
  return ($Y,$Cb,$Cr);
}

exit;
