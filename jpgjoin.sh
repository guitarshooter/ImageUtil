#!/bin/sh

FILELIST="P6090873 P6090886 P6090899 P6090912 P6090925 P6090938 P6090951"
COLORLIST="2600K 5150K_G10 20000K"

for file in $FILELIST
do
  montage -tile 4x1 -geometry +0+0 ${file}_org_切り抜き.jpg ${file}_2600K_切り抜き.jpg ${file}_5150K_G10_切り抜き.jpg ${file}_20000K_彩度揃え_切り抜き.jpg ${file}_色変化.jpg
  for color in $COLORLIST
  do
    montage -tile 3x1 -geometry +0+0 ${file}_org_切り抜き.jpg ${file}_${color}_彩度減_切り抜き.jpg ${file}_${color}_切り抜き.jpg ${file}_${color}_彩度変化.jpg
  done
done

