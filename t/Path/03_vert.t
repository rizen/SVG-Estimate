use strict;
use Test::More;
use lib 'lib', '../../lib';

use_ok 'SVG::Estimate::Path::VerticalLineto';
my $vlineto = SVG::Estimate::Path::VerticalLineto->new(
    start_point => [4, 5],
    y => 15,
);

is_deeply $vlineto->end_point, [4,15], 'verticallineto end point';
cmp_ok $vlineto->round($vlineto->length),  '==', 10, 'verticallineto length';

done_testing();
