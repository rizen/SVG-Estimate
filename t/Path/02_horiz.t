use strict;
use Test::More;
use lib 'lib', '../../lib';

use_ok 'SVG::Estimate::Path::HorizontalLineto';
my $hlineto = SVG::Estimate::Path::HorizontalLineto->new(
    start_point => [4, 5],
    x => 10,
);

is_deeply $hlineto->end_point, [14,5], 'horizontallineto end point';
is_deeply $hlineto->start_point, [4, 5], 'checking that we did not stomp on the starting point';
cmp_ok $hlineto->round($hlineto->length),  '==', 10, 'horizontallineto length';

done_testing();
