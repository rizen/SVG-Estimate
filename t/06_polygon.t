use strict;
use Test::More;
use Math::Trig;

use_ok 'SVG::Estimate::Polygon';

my $poly_gon = SVG::Estimate::Polygon->new(
    start_x => 0,
    start_y => 0,
    points  => [ ##Cross shape with unit steps
        [2, 0],
        [2, 1],
        [1, 1],
        [1, 2],
        [2, 2],
        [2, 3],
        [3, 3],
        [3, 2],
        [4, 2],
        [4, 1],
        [3, 1],
        [3, 0],
    ],
);

is_deeply [$polygon->draw_start], [2,0], 'polygon start point, dead north';
cmp_ok $polygon->shape_length,  '==', 12, 'polygon length';
cmp_ok $polygon->travel_length, '==',  2, 'polygon travel'; 
cmp_ok $polygon->length,        '==', 14, 'total polygon draw and move length';
