##  Author  : Wojciech Kuchta <wojciech.kuchta@gmail.com>
##  Created : 2014-09-21
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.

## Info:
## This script is used for batch joining two images together (left-right orientation).
## It's dedicated for calling photos eg. 9x13 cm which can be cut ina a half for 9x6,5 cm cards.

## Usage:
## - PNG/ - directory with images (files)
## - list.txt - list of files prom PNG/ directory
## - out/ - directory with result files

use GD;

startImageJoin();

sub startImageJoin()
{
    if (! -e "list.txt")
    {
        die("File with list of images list.txt not found!\n");
    }


    open (LI, "list.txt");
    while (<LI>)
    {
        $im1 = $_;
        $im2 = <LI>; 
        chomp $im1;
        chomp $im2;
        pair($i++,"PNG/".$im1,"PNG/".$im2);
        print "$i OK\n";
    }
    close(LI);
}

sub pair()
{
        my ($i, $file1src, $file2src)=	@_;
        print "$i, $file1src, $file2src OK\n";

        if (undef eq $file2src)
        {return;}

        if (! -e $file2src)
        {return;}

        #$im = new GD::Image(2980, 2090);
        $im = new GD::Image(3245, 2246);

        $white = $im->colorAllocate(255,255,255);
        #$im->transparent($white);
        $im->interlaced('true');
        $im->rectangle(0,0,11,11,$white);
        $im->fill(2,2,$white);

        $image1src = GD::Image->newFromPng($file1src);
        $image2src = GD::Image->newFromPng($file2src);

        $im->copy($image1src,118,77,0,0,1490,2090);
        $im->copy($image2src,1490+120+12,77,0,0,1490,2090);

        binmode STDOUT;

        # Image to PNG
        open (OU, "> out/".$i.".png");
        print OU $im->png;
        close OU;
}
