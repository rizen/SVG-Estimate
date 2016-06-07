use strict;
use Test::More;
use Math::Trig;

use_ok 'SVG::Estimate::Circle';

my $circle = SVG::Estimate::Circle->new(
    cx => 2,
    cy => 2,
    r  => 1,
    start_x => 0,
    start_y => 0,
    rate    => 250,
);

is $circle->shape_length, 6.283, 'circle circumerence';
is $circle->travel_length, 3.606, 'circle travel'; 
is $circle->length, 9.889, 'total circle draw and move length';

is $circle->shape_time, 1570.796, 'circle circumference draw time';
is $circle->travel_time, 901.500, 'circle travel draw time';
is $circle->time, 2472.296, 'total circle time';
