use strict;
use Test::More;
use Math::Trig;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate::Circle';

my $circle = SVG::Estimate::Circle->new(
    cx => 2,
    cy => 2,
    r  => 1,
    start_x => 0,
    start_y => 0,
);

my @draw_start = $circle->draw_start;
is $draw_start[0], 2, 'circle draw start x';
is $draw_start[1], 2.5, 'circle draw start y';
cmp_ok $circle->round($circle->shape_length),  '==', 6.283, 'circle circumerence';

done_testing();
