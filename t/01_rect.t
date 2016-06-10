use strict;
use Test::More;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate::Rect';
my $rect = SVG::Estimate::Rect->new(
    start_point => [10,30],
    x           => 0,
    y           => 310,
    width       => 943,
    height      => 741,
);
isa_ok $rect, 'SVG::Estimate::Rect';

is $rect->round(0.12351), 0.124, 'rounding works';

is_deeply $rect->draw_start, [0,310], 'rectangle draw start';

is $rect->round($rect->travel_length), 280.179, 'rectangle travel length';

is $rect->shape_length, 3368, 'rectangle length';

is $rect->round($rect->length), 3648.179, 'rectangle total length';

is_deeply $rect->draw_end, [0,310], 'rectangle end is the same as the start';

is $rect->min_x, 0, 'min_x';
is $rect->max_x, 943, 'max_x';
is $rect->min_y, 310, 'min_y';
is $rect->max_y, 1051, 'max_y';

done_testing();

