use strict;
use Test::More;
use lib 'lib', '../../lib', '../lib';

use_ok 'SVG::Estimate::Path::Arc';
my $arc = SVG::Estimate::Path::Arc->new(
    start_point     => [7, 5],
    rx              => 2,
    ry              => 2,
    x_axis_rotation => 0,
    sweep_flag      => 0,
    large_arc_flag  => 0,
    end             => [5, 7],
);
isa_ok $arc, 'SVG::Estimate::Path::Arc';

is_deeply $arc->start_point, [7, 5], 'arc start point';
is_deeply $arc->end_point, [5,7], 'arc end point';
cmp_ok $arc->round($arc->length),  '==', 3.142, 'arc length';

cmp_ok $arc->round($arc->min_x), '==', 5, 'min_x';
cmp_ok $arc->round($arc->max_x), '==', 7, 'max_x';
cmp_ok $arc->round($arc->min_y), '==', 3, 'min_y';
cmp_ok $arc->round($arc->max_y), '==', 5, 'max_y';

done_testing();

