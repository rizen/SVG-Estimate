use strict;
use Test::More;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate';
my $shapes = SVG::Estimate->new(
    file_path        => 'var/shapes.svg',
);
isa_ok $shapes, 'SVG::Estimate';

$shapes->estimate;
cmp_ok $shapes->length, '==', 40, 'shapes - length';
cmp_ok $shapes->shape_count, '==', 6, 'shapes - shape count';

done_testing();

