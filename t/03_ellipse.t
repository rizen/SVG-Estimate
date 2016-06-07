use strict;
use Test::More;
use Math::Trig;

use_ok 'SVG::Estimate::Ellipse';

my $ellipse = SVG::Estimate::Ellipse->new(
    cx => 3,
    cy => 3,
    rx => 2,
    ry => 1,
    start_x => 0,
    start_y => 0,
);

is_deeply [$ellipse->draw_start], [3,3.5], 'ellipse start point, dead north';
cmp_ok $ellipse->shape_length,  '==',  9.690, 'ellipse circumerence';
cmp_ok $ellipse->travel_length, '==',  4.610, 'ellipse travel'; 
cmp_ok $ellipse->length,        '==', 14.300, 'total ellipse draw and move length';
