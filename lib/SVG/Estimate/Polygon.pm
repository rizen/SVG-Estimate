package SVG::Estimate::Polygon;

use Moo;
use Math::Trig qw/pi/;
use Clone qw/clone/;

extends 'SVG::Estimate::Polyline';

=head1 NAME

SVG::Estimate::Polygon - Handles estimating shapes of more than 3 points with straight lines between the points.

=head1 SYNOPSIS

 my $polygon = SVG::Estimate::Polygon->new(
    transformer => $transform,
    start_point => [45,13],
    points      => '20,20 40,25 60,40 80,120 120,140 200,180',
 );

 my $length = $polygon->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Polyline>.

=cut

##Take the first pair, and make it the last to close the shape.
around _get_pairs => sub {
    my $orig = shift;
    my $self = shift;
    my @pairs = $self->$orig(@_);
    push @pairs, $pairs[0];
    return @pairs
};

1;
