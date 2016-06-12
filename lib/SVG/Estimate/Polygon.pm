package SVG::Estimate::Polygon;

use Moo;
use Math::Trig qw/pi/;
use Clone qw/clone/;

extends 'SVG::Estimate::Polyline';

=head1 NAME

SVG::Estimate::Polygon - Handles estimating shapes of more than 3 points with straight lines between the points.

=head1 SYNOPSIS

 my $polygon = SVG::Estimate::Polygon->new(
    transform   => $transform,
    start_point => [45,13],
    points      => '20,20 40,25 60,40 80,120 120,140 200,180',
 );

 my $length = $polygon->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Polyline>.

=cut

around parsed_points => sub {
    my $orig = shift;
    my $self = shift;
    my $points = $self->$orig();
    my $start_point = clone $points->[0];
    push @{ $points }, $start_point;
    return $points;
};

1;
