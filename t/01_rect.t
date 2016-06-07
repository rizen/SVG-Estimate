use strict;
use Test::More;

use_ok 'SVG::Estimate::Rect';
my $rect = SVG::Estimate::Rect->new(
    starty  => 30,
    staryx  => 10,
    y       => 310,
    x       => 0,
    height  => 741,
    width   => 943,
);
isa_ok $rect, 'SVG::Estimate::Rect';

is $rect->round(0.1235), 0.124, 'rounding works';

my @draw_start = $rect->draw_start;
is $draw_start[0], 0, 'rectangle draw start x';
is $draw_start[1], 310, 'rectangle draw start y';

is $rect->round($rect->travel_length), 281.603, 'rectangle travel length';

is $rect->object_length, 2627, 'rectangle length';

is $rect->length, 2908.603, 'rectangle total length';

done_testing();

