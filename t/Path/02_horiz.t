use strict;
use Test::More;
use lib 'lib', '../../lib', '../lib';

use_ok 'SVG::Estimate::Path::HorizontalLineto';
my $hlineto = SVG::Estimate::Path::HorizontalLineto->new(
    start_point => [4, 5],
    x => 14,
);

is_deeply $hlineto->end_point, [14,5], 'horizontallineto end point';
is_deeply $hlineto->start_point, [4, 5], 'checking that we did not stomp on the starting point';
cmp_ok $hlineto->round($hlineto->length),  '==', 10, 'horizontallineto length';

is $hlineto->min_x, 14, 'min_x';
is $hlineto->max_x, 14, 'max_x';
is $hlineto->min_y,  5, 'min_y';
is $hlineto->max_y,  5, 'max_y';

done_testing();
