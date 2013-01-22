#!/bin/sh

EAGLE=/Applications/EAGLE-6.4.0/EAGLE.app/Contents/MacOS/EAGLE
DPI=1200

COVERED_COPPER=#095935
BLANK_COPPER=#c7a800
COVERED_FR4=#0f3e24
BLANK_FR4=#3c4a42
HOLES=#000000
SILK=#ffffff

$EAGLE -X -N -d GERBER_RS274X -o "outline.ger" $1 Dimension Milling
cat outline.ger | sed s/ADD10C,0.0000/ADD10C,0.0100/ > outline1.ger
gerbv --border=3 -f#ffffff -x svg -o mask.svg outline1.ger
rsvg-convert --dpi-x=$DPI --dpi-y=$DPI --format=png --output=mask.png mask.svg

gerbv --border=3 -f#ffffff -x svg -o outline.svg outline.ger
rsvg-convert --dpi-x=$DPI --dpi-y=$DPI --format=png --output=outline.png outline.svg

$EAGLE -X -N -d GERBER_RS274X -o "top.ger" $1 Dimension Top Pads Vias
gerbv --border=3 -f#ffffff -x svg -o top.svg top.ger
rsvg-convert --dpi-x=$DPI --dpi-y=$DPI --format=png --output=top.png top.svg

$EAGLE -X -N -d GERBER_RS274X -o "stop.ger" $1 Dimension tStop
gerbv --border=3 -f#ffffff -x svg -o stop.svg stop.ger
rsvg-convert --dpi-x=$DPI --dpi-y=$DPI --format=png --output=stop.png stop.svg

$EAGLE -X -N -d GERBER_RS274X -o "silk.ger" $1 Dimension tPlace tNames
gerbv --border=3 -f#ffffff -x svg -o silk.svg silk.ger
rsvg-convert --dpi-x=$DPI --dpi-y=$DPI --format=png --output=silk.png silk.svg


$EAGLE -X -N -d EXCELLON -o "drills.ger" $1 Drills Holes
gerbv --border=3 -f#ffffff -x svg -o drills.svg drills.ger outline.ger
rsvg-convert --dpi-x=$DPI --dpi-y=$DPI --format=png --output=drills.png drills.svg

rm outline1.ger outline.ger top.ger stop.ger silk.ger drills.ger
rm mask.svg outline.svg top.svg stop.svg silk.svg drills.svg
rm outline.gpi top.gpi stop.gpi silk.gpi  
rm drills.dri


#covered cooper
gm composite -compose Subtract top.png stop.png covered_copper.png
gm convert -transparent black  -transparent "#010101" -fill "$COVERED_COPPER" -opaque white covered_copper.png covered_copper_colored.png

gm composite -compose Subtract top.png covered_copper.png blank_copper.png
rm covered_copper.png
gm convert -transparent black  -transparent "#010101" -fill "$BLANK_COPPER" -opaque white blank_copper.png blank_copper_colored.png
rm blank_copper.png


#blank fr4
gm composite -compose Subtract stop.png top.png blank_fr4.png
rm top.png
gm convert -transparent black -transparent "#010101"  -fill "$BLANK_FR4" -opaque white blank_fr4.png blank_fr4_colored.png
rm blank_fr4.png

#real silk
gm composite -compose Subtract silk.png stop.png silk_cropped.png
rm silk.png stop.png
gm convert -transparent black -transparent "#010101"  -fill "$SILK" -opaque white silk_cropped.png silk_colored.png
rm silk_cropped.png

gm convert  -fill "$COVERED_FR4" -opaque none outline.png background.png
rm outline.png
gm convert -fill blue -opaque none -draw "fill black ; color 0,0 floodfill" -transparent white -transparent blue mask.png mask_colored.png
rm mask.png

gm convert -fill "$HOLES" -opaque white drills.png drills_colored.png
rm drills.png

gm composite -compose Over  covered_copper_colored.png background.png  tmp1.png
rm background.png covered_copper_colored.png
gm composite -compose Over  blank_copper_colored.png tmp1.png  tmp2.png
rm blank_copper_colored.png tmp1.png
gm composite -compose Over  blank_fr4_colored.png tmp2.png tmp3.png
rm blank_fr4_colored.png tmp2.png
gm composite -compose Over  silk_colored.png tmp3.png tmp4.png
rm silk_colored.png tmp3.png
gm composite -compose Over  drills_colored.png tmp4.png tmp5.png
rm drills_colored.png tmp4.png
gm composite -compose Over  mask_colored.png tmp5.png $2
rm mask_colored.png tmp5.png

