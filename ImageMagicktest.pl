#!/usr/local/bin/perl -w

use strict;
use Image::Magick;

my $image = Image::Magick->new;

# 300x250の白いキャンバスを作成
$image->Set(size=>"300x200");
$image->ReadImage('xc:white');

# 折れ線を描く
$image->Draw(primitive=>'polyline', points=>"30,100 50,20 200,170 260,70",
             stroke=>'#DD5500');

# 外枠で画像を囲む
$image->Border(width=>1, height=>1, fill=>'black');

print "Content-type: image/png\n\n";
binmode STDOUT;
$image->Write('png:-');

undef $image;
exit;