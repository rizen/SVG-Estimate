package SVG::Estimate::Polygon;

use Moo;
use Math::Trig qw/pi/;
use Clone qw/clone/;

extends 'SVG::Estimate::Polyline';

=head1 NAME

SVG::Estimate::Circle - Handles estimating circles.

=head1 SYNOPIS

 my $circle = SVG::Estimate::Circle->new(
    transform   => $transform,
    start_point => [45,13],
    cx          => 1,
    cy          => 3,
    r           => 1,
 );

 my $length = $circle->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Shape>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item cx

Float representing center x.

=item cy

Float representing center y.

=item r

Float representing the radius.

=back

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
