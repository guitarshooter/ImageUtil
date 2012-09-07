for dir in $1
do
  cd $dir;
  mkdir Resized
    for file in *.JPG
    do
      convert -resize 160x160 $file Resized/$file
    done
  cd ..
done