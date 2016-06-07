use strict;
use Test::More;
use lib 'lib', '../../lib';

use_ok 'SVG::Estimate::Path::HorizontalLineto';
my $hlineto = SVG::Estimate::HorizontalLineto->new(
    start_point => [4, 5],
    x => 14,
);

is_deeply $hlineto->end_point, [14,5], 'horizontallineto end point';
cmp_ok $hlineto->round($hlineto->length),  '==', 10, 'horizontallineto length';

done_testing();
