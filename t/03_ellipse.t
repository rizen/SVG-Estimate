use strict;
use Test::More;
use Math::Trig;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate::Ellipse';

my $ellipse = SVG::Estimate::Ellipse->new(
    cx          => 3,
    cy          => 3,
    rx          => 10,
    ry          => 5,
    start_point => [0,0],
);

is_deeply $ellipse->draw_start, [3,5.5], 'ellipse start point, dead north';
cmp_ok $ellipse->round($ellipse->shape_length),  '==', 48.442, 'ellipse circumerence';

done_testing();
