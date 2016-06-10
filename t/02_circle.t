use strict;
use Test::More;
use Math::Trig;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate::Circle';

my $circle = SVG::Estimate::Circle->new(
    cx          => 2,
    cy          => 2,
    r           => 1,
    start_point => [0,0],
);

is_deeply $circle->draw_start, [2,2.5], 'circle draw start';
cmp_ok $circle->round($circle->shape_length),  '==', 6.283, 'circle circumerence';

is $circle->min_x, 1, 'min_x';
is $circle->max_x, 3, 'max_x';
is $circle->min_y, 1, 'min_y';
is $circle->may_y, 3, 'may_y';

done_testing();
