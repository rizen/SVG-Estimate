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

done_testing();

