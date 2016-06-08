use strict;
use Test::More;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate::Path';

my $path = SVG::Estimate::Path->new(
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
is_deeply $path->draw_start, [5,5], 'start drawing at the first command (always a moveto)';
cmp_ok $path->round($path->shape_length),  '==', 47.071, 'simple path length';  ##Shape length includes the travel_length due to the moveto
##Test travel_length and length to make sure we don't count the initial moveto twice
cmp_ok $path->round($path->travel_length), '==', 0.000, 'path travel length';
cmp_ok $path->round($path->length),        '==', 47.071, 'path length total';

done_testing();
