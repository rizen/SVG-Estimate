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
cmp_ok $shapes->length, '>', 5000, 'shapes - length';
cmp_ok $shapes->shape_count, '==', 7, 'shapes - shape count';

my $inkscape_box_in = SVG::Estimate->new( file_path => 'var/inkscape-box-px.svg' );
$inkscape_box_in->estimate;
cmp_ok $inkscape_box_in->length, '>', 1700, 'inkscape_box_in - length';
cmp_ok $inkscape_box_in->shape_count, '==', 1, 'inkscape_box_in - shape count';

my $affinity_box_in = SVG::Estimate->new( file_path => 'var/affinity-box-in.svg' );
$affinity_box_in->estimate;
cmp_ok $affinity_box_in->length, '>', 3700, 'affinity_box_in - length';
cmp_ok $affinity_box_in->shape_count, '==', 1, 'affinity_box_in - shape count';

my $furniture = SVG::Estimate->new( file_path => 'var/furniture.svg' );
$furniture->estimate;
cmp_ok $furniture->length, '>', 63651, 'furniture - length';
cmp_ok $furniture->shape_count, '==', 563, 'furniture - shape count';

done_testing();

