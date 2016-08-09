#!/usr/bin/perl

##  Author  : Wojciech Kuchta <wojciech.kuchta@gmail.com>
##  Created : 2016-08-09
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
## Script used to dump MongoDB collection to a file.

use strict;
use MongoDB;

mongo_dump();

sub mongo_dump {

    my $mongo_host = 'example.local';
    my $mongo_user = 'user';
    my $mongo_pass = 'password';
    my $mongo_db_name = 'database_name';
    my $collection = 'exampleCollection';

    my $client     = MongoDB::MongoClient->new(
                        host => $mongo_host,
                        port => 27017,
                        username => $mongo_user,
                        password => $mongo_pass,
                        db_name => $mongo_db_name
                    );
    my $database   = $client->get_database( $mongo_db_name );
    my $collection = $database->get_collection( $collection );
    my $data       = $collection->find({ });

    # use Data::Dumper;

    while (my $doc = $data->next) {
        print $doc->{'_id'} . "\n";
        #print Dumper($doc);
    }
}
