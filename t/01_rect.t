use strict;
use Test::More;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate::Rect';
my $rect = SVG::Estimate::Rect->new(
    start_y => 30,
    start_x => 10,
    y       => 310,
    x       => 0,
    height  => 741,
    width   => 943,
);
isa_ok $rect, 'SVG::Estimate::Rect';

is $rect->round(0.12351), 0.124, 'rounding works';

my @draw_start = $rect->draw_start;
is $draw_start[0], 0, 'rectangle draw start x';
is $draw_start[1], 310, 'rectangle draw start y';

is $rect->round($rect->travel_length), 280.179, 'rectangle travel length';

is $rect->shape_length, 3368, 'rectangle length';

is $rect->round($rect->length), 3648.179, 'rectangle total length';

is_deeply [$rect->draw_end], [0,310], 'rectangle end is the same as the start';


done_testing();

