use strict;
use Test::More;
use lib 'lib', '../../lib', '../lib';
use Image::SVG::Transform;

use_ok 'SVG::Estimate::Path::VerticalLineto';
my $transform = Image::SVG::Transform->new();
$transform->extract_transforms('translate (10,-5)');
my $vlineto = SVG::Estimate::Path::VerticalLineto->new(
    transform   => $transform,
    start_point => [4, 5],
    y => 15,
);

is_deeply $vlineto->end_point, [4,10], 'verticallineto end point';
is_deeply $vlineto->start_point, [4, 5], 'checking that we did not stomp on the starting point';
cmp_ok $vlineto->round($vlineto->length),  '==', 5, 'verticallineto length';

is $vlineto->min_x, 4, 'min_x';
is $vlineto->max_x, 4, 'max_x';
is $vlineto->min_y, 5, 'min_y';
is $vlineto->max_y, 10, 'max_y';

done_testing();
