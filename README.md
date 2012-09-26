brd2png
=======

simple shell script rendering eagle .brd files to images

####dependencies:


* eagle
* graphicsmagic
* gerbv
* librsvg (rsvg-convert)

- - - 

Example 1:

![eagle](/sebseb7/brd2png/raw/master/sample/eagle.png)
![rendered](/sebseb7/brd2png/raw/master/sample/rendered.png)

####These two examples show typical mistakes not easiely visible in eagle: 

- - -

Example 2:

Sometimes one does not notice text over holes or pads:

![comp1a](/sebseb7/brd2png/raw/master/sample/comp1a.png)
![comp1b](/sebseb7/brd2png/raw/master/sample/comp1b.png)

- - - 

Example 3:

If you use the stop layer for text, it will be barely visible if you postioning it over areas with no copper. In eagle it sill looks good

![comp2a](/sebseb7/brd2png/raw/master/sample/comp2a.png)
![comp2b](/sebseb7/brd2png/raw/master/sample/comp2b.png)


