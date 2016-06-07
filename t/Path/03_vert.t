use strict;
use Test::More;
use lib 'lib', '../../lib';

use_ok 'SVG::Estimate::Path::VerticalLineto';
my $vlineto = SVG::Estimate::VerticalLineto->new(
    start_point => [4, 5],
    y => 15,
);

is_deeply $vlineto->draw_end, [4,15], 'verticallineto end point';
cmp_ok $vlineto->round($vlineto->length),  '==', 10, 'verticallineto length';

done_testing();
