use strict;
use Test::More;
use Math::Trig;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate::Line';

my $line = SVG::Estimate::Line->new(
    x1          => 12,
    y1          => 147,
    x2          => 58,
    y2          => 226,
    start_point => [11, 450],
);

is_deeply $line->draw_start, [12, 147], 'line start point';
is_deeply $line->draw_end, [58,226], 'line start point';
cmp_ok $line->round($line->shape_length),  '==', 91.417, 'line length';

done_testing();
