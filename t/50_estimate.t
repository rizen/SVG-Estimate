use strict;
use Test::More;
use lib 'lib', '../lib';

use_ok 'SVG::Estimate';
my $onesquare = SVG::Estimate->new( file_path => 'var/onesquare.svg' );
isa_ok $onesquare, 'SVG::Estimate';
$onesquare->estimate;
cmp_ok $onesquare->round($onesquare->length), '==', 1226.979, 'one square - length';
cmp_ok $onesquare->shape_count, '==', 1, 'one square - shape count';

my $shapes = SVG::Estimate->new( file_path => 'var/shapes.svg' );
$shapes->estimate;
cmp_ok $shapes->length, '>', 3800, 'shapes - length';
cmp_ok $shapes->shape_count, '==', 6, 'shapes - shape count';

done_testing();

