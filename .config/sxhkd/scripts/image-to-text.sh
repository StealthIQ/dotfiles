#!/bin/bash 
# Dependencies: tesseract-ocr tesseract flameshot xclip tesseract-data-eng

#removes the pic from ~/.cache
mkdir ~/.cache/image-text/
rm ~/.cache/image-text/image.png

# select tesseract_lang in eng rus equ ;do break;done
# quick language menu, add more if you need other languages. -- not needed but uncomment if above line to check usage

#flameshot cropped clipboard to .cache path
flameshot gui --path ~/.cache/image-text/image 

#should increase detection rate
mogrify -modulate 100,0 -resize 400% ~/.cache/image-text/image.png

#convert image to text
tesseract ~/.cache/image-text/image.png - | xclip -selection clipboard 

#output clipboard content
sleep 0.2;
text_in_image=`xclip -o`
#send notification
notify-send -i /home/i0xfce/.icons/Papirus-Custom/48x48/apps/screengrab.svg "✔ Extracted text from image, Copied it to clipboard" "$text_in_image" & 

exit
