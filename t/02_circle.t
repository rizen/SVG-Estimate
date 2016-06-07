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

cmp_ok $circle->shape_length,  '==', 6.283, 'circle circumerence';
cmp_ok $circle->travel_length, '==', 3.606, 'circle travel'; 
cmp_ok $circle->length,        '==', 9.889, 'total circle draw and move length';

cmp_ok $circle->shape_time,    '==', 1570.796, 'circle circumference draw time';
cmp_ok $circle->travel_time,   '==',  901.500, 'circle travel draw time';
cmp_ok $circle->time,          '==', 2472.296, 'total circle time';
