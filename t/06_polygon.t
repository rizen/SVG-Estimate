use strict;
use Test::More;
use Math::Trig;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate::Polygon';

my $points =  [ ##Cross shape with unit steps
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
];

my $points_string = '2,0 2,1 1,1 1,2 2,2 2,3 3,3 3,2 4,2 4,1 3,1 3,0';

my $polygon = SVG::Estimate::Polygon->new(
    start_point => [0,0],
    points  => $points_string,
);

is scalar(@{$polygon->parsed_points}), scalar(@{ $points })+1, 'added one to the list of points';
isnt $polygon->parsed_points->[0], $polygon->parsed_points->[-1], 'Did not create a duplicate reference in the points array';
is_deeply $polygon->draw_start, [2,0], 'polygon start point, dead north';
cmp_ok $polygon->shape_length,  '==', 12, 'polygon length';

done_testing();
