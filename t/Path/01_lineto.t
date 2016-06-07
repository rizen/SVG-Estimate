use strict;
use Test::More;
use lib 'lib', '../../lib';

use_ok 'SVG::Estimate::Path::Lineto';
my $lineto = SVG::Estimate::Lineto->new(
    start_point => [4, 5],
    point => [14, 15],
);
isa_ok $lineto, 'SVG::Estimate::Path::Lineto';

is_deeply $lineto->draw_start, [4, 5], 'lineto start point';
is_deeply $lineto->draw_end, [14,15], 'lineto end point';
cmp_ok $lineto->round($lineto->length),  '==', 14.142, 'lineto length';

done_testing();
