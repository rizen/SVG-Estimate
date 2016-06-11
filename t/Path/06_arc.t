use strict;
use Test::More;
use lib 'lib', '../../lib', '../lib';

use_ok 'SVG::Estimate::Path::Arc';
my $arc = SVG::Estimate::Path::Arc->new(
    start_point     => [275, 25],
    rx              => 150,
    ry              => 150,
    x_axis_rotation => 0,
    sweep_flag      => 0,
    large_arc_flag  => 0,
    end             => [125, 175],
);
isa_ok $arc, 'SVG::Estimate::Path::Arc';

is_deeply $arc->start_point, [275, 25], 'arc start point';
is_deeply $arc->end_point, [125,175], 'arc end point';
is_deeply $arc->_center,   [275,175],  'calculated center point';
cmp_ok $arc->round($arc->_theta), '==', 270, 'calculated theta (angle to initial point on x-axis)';
cmp_ok $arc->round($arc->_delta), '==', -90, 'calculated delta (angle to initial point on x-axis)';
cmp_ok $arc->round($arc->length),  '==', 235.618, 'arc length'; #( 2* pi * r / 4);

cmp_ok $arc->round($arc->min_x), '==', 125, 'min_x';
cmp_ok $arc->round($arc->max_x), '==', 275, 'max_x';
cmp_ok $arc->round($arc->min_y), '==', 25, 'min_y';
cmp_ok $arc->round($arc->max_y), '==', 175, 'max_y';

done_testing();

