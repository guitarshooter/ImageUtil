#!/usr/local/bin/perl -w

use strict;
use Image::Magick;

my $image = Image::Magick->new;

# 300x250‚Ì”’‚¢ƒLƒƒƒ“ƒoƒX‚ðì¬
$image->Set(size=>"300x200");
$image->ReadImage('xc:white');

# Ü‚êü‚ð•`‚­
$image->Draw(primitive=>'polyline', points=>"30,100 50,20 200,170 260,70",
             stroke=>'#DD5500');

# ŠO˜g‚Å‰æ‘œ‚ðˆÍ‚Þ
$image->Border(width=>1, height=>1, fill=>'black');

print "Content-type: image/png\n\n";
binmode STDOUT;
$image->Write('png:-');

undef $image;
exit;