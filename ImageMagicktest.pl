#!/usr/local/bin/perl -w

use strict;
use Image::Magick;

my $image = Image::Magick->new;

# 300x250�̔����L�����o�X���쐬
$image->Set(size=>"300x200");
$image->ReadImage('xc:white');

# �܂����`��
$image->Draw(primitive=>'polyline', points=>"30,100 50,20 200,170 260,70",
             stroke=>'#DD5500');

# �O�g�ŉ摜���͂�
$image->Border(width=>1, height=>1, fill=>'black');

print "Content-type: image/png\n\n";
binmode STDOUT;
$image->Write('png:-');

undef $image;
exit;