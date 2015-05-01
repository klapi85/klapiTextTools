#!/usr/bin/perl

##  Author  : Wojciech Kuchta <wojciech.kuchta@gmail.com>
##  Created : 2010-07-18
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
## This is very simple cgi web template in Perl


use strict;
use CGI qw(:standard);
use utf8;

    binmode(STDIN,":utf8");
    binmode(STDOUT,":utf8");

    print "Content-type: text/html; charset=utf-8\n\n";
    print h1('Hello world');

    my $code = param('code');

    print '<hr> $code <br><small>Klapi 2010</small>';
    print end_html;
