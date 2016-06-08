use strict;
use Test::More;
use lib 'lib', '../../lib', '../lib';

use_ok 'SVG::Estimate::Path::CubicBezier';
my $cubic = SVG::Estimate::Path::CubicBezier->new(
    start_point    => [120, 160],
    end            => [220, 40],
    control1       => [35, 200],
    control2       => [220, 260],
);
isa_ok $cubic, 'SVG::Estimate::Path::CubicBezier';

is_deeply $cubic->start_point, [120, 160], 'cubic bezier start point';
is_deeply $cubic->end_point, [220,40], 'cubic bezier end point';
cmp_ok $cubic->round($cubic->length),  '==', 272.870, 'cubic bezier length';

done_testing();

