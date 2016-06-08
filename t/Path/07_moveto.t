use strict;
use Test::More;
use lib 'lib', '../../lib', '../lib';

use_ok 'SVG::Estimate::Path::Moveto';
my $moveto = SVG::Estimate::Path::Moveto->new(
    start_point => [4, 5],
    point => [14, 15],
);
isa_ok $moveto, 'SVG::Estimate::Path::Moveto';

is_deeply $moveto->start_point, [4, 5], 'moveto start point';
is_deeply $moveto->end_point, [14,15], 'moveto end point';
cmp_ok $moveto->round($moveto->length),  '==', 14.142, 'moveto length';

done_testing();
