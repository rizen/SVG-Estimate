use strict;
use Test::More;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate::Path';
use Image::SVG::Transform;

my $transform = Image::SVG::Transform->new();
$transform->extract_transforms('scale(2,4)');
my $path = SVG::Estimate::Path->new(
    transform   => $transform,
    start_point => [0,0],
    d  => 'M 5 5 L 5 15 L 15 15 L 15 5 Z',
);

#foreach my $command (@{ $path->commands }) {
#    diag ref $command;
#    diag explain $command->start_point;
#    diag explain $command->point;
#    diag $command->length;
#}

is scalar(@{$path->commands}), 5, 'All commands correctly parsed';
is_deeply $path->draw_start, [10,20], 'start drawing at the first command (always a moveto)';
cmp_ok $path->round($path->shape_length),  '==', 142.361, 'simple path length';  ##Shape length includes the travel_length due to the moveto
##Test travel_length and length to make sure we don't count the initial moveto twice
cmp_ok $path->round($path->travel_length), '==', 0.000, 'path travel length';
cmp_ok $path->round($path->length),        '==', 142.361, 'path length total';
cmp_ok $path->min_x, '==', 10, '... min x';
cmp_ok $path->max_x, '==', 30, '... max x';
cmp_ok $path->min_y, '==', 20, '... min y';
cmp_ok $path->max_y, '==', 60, '... max y';

done_testing();
