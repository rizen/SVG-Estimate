use strict;
use Test::More;
use lib 'lib', '../../lib', '../lib';

use_ok 'SVG::Estimate::Path::QuadraticBezier';
my $quad = SVG::Estimate::Path::QuadraticBezier->new(
    start_point   => [1, 1],
    end           => [6, 6],
    control       => [8, 3.5],
);
isa_ok $quad, 'SVG::Estimate::Path::QuadraticBezier';

is_deeply $quad->start_point, [1, 1], 'quadratic bezier start point';
is_deeply $quad->end_point, [6,6], 'quadratic bezier end point';
cmp_ok $quad->round($quad->length),  '==', 5.105, 'quadratic bezier length';

done_testing();

