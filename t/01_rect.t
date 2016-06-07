use strict;
use Test::More;

use_ok 'SVG::Estimate::Rect';
my $rect = SVG::Estimate::Rect->new(
    starty  => 30,
    staryx  => 10,
    rate    => 250,
    y       => 310,
    x       => 0,
    height  => 741,
    width   => 943,
);
isa_ok $rect, 'SVG::Estimate::Rect';

is $rect->object_length, 2627, 'object length';
is $rect->travel_length, 



done_testing();

