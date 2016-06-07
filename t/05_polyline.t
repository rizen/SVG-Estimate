use strict;
use Test::More;
use Math::Trig;

use_ok 'SVG::Estimate::Polyline';

my $poly_line = SVG::Estimate::Polyline->new(
    start_x => 0,
    start_y => 0,
    points  => [  ##unit staircase
        [5, 3],
        [5, 4],
        [6, 4],
        [6, 5],
        [6, 6],
        [7, 6],
        [7, 7],
    ],
);

is_deeply [$polyline->draw_start], [5,3], 'polyline start point, dead north';
cmp_ok $polyline->shape_length,  '==',  7.000, 'polyline length';
cmp_ok $polyline->travel_length, '==',  5.831, 'polyline travel'; 
cmp_ok $polyline->length,        '==', 12.831, 'total polyline draw and move length';
