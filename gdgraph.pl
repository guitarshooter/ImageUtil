#!/usr/bin/perl

use GD::Graph::lines;
use File::Basename;


@ARGV = sort @ARGV;

while(@ARGV){
  $file = shift @ARGV;
  open(IN,$file);

@lines = <IN>;
while(@lines){
  $_ = shift @lines;
  @str = split(/\t/,$_);
print $str[0];
  push (@labels,$str[0]);
  push (@rdata,$str[1]);
  push (@gdata,$str[2]);
  push (@bdata,$str[3]);
  $rgb=$str[1]+$str[2]+$str[3];
  push (@rgbdata,$rgb);
}
@data = (\@labels,\@rdata,\@gdata,\@bdata,\@rgbdata);
$graph = GD::Graph::lines->new(400,300);
#$graph = GD::Graph::bars->new(400,300);
$image = $graph->plot(\@data);
my $regex_suffix = qw(¥.[^¥.]+$);
$basefilename = basename($file);
open( OUT, "> graph.jpg") or die( "Cannot open file: graph2.png" );
binmode OUT;
print OUT $image->jpeg();
close OUT;
}
