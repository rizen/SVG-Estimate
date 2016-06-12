package SVG::Estimate::Ellipse;

use Moo;
use Math::Trig qw/pi/;

extends 'SVG::Estimate::Shape';
with 'SVG::Estimate::Role::EllipsePoints';

=head1 NAME

SVG::Estimate::Ellipse - Handles estimating ellipses.

=head1 SYNOPSIS

 my $ellipse = SVG::Estimate::Ellipse->new(
    transform   => $transform,
    start_point => [45,13],
    cx          => 1,
    cy          => 3,
    rx          => 1,
    ry          => 1.5,
 );

 my $length = $ellipse->length;

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

=item rx

Float representing the x radius.

=item ry

Float representing the y radius.

=back

=cut

has cx => (
    is => 'ro',
);

has cy => (
    is => 'ro',
);

has rx => (
    is => 'ro',
);

has ry => (
    is => 'ro',
);

sub draw_start {
    my $self = shift;
    return [$self->cx, $self->cy + 0.5*$self->ry];
}

##https://www.mathsisfun.com/geometry/ellipse-perimeter.html, Series #2

sub shape_length {
    my $self = shift;
    my $h = ($self->rx - $self->ry)**2 / ($self->rx + $self->ry) **2;
    my $len = pi * ( $self->rx + $self->ry ) * ( 1 + $h/4 + ($h**2)/64 + ($h**3)/256 + ($h**4 * (25/16384)));
    return $len;
}

sub min_x {
    my $self = shift;
    return $self->cx - $self->rx;
}

sub max_x {
    my $self = shift;
    return $self->cx + $self->rx;
}

sub min_y {
    my $self = shift;
    return $self->cy - $self->ry;
}

sub max_y {
    my $self = shift;
    return $self->cy + $self->ry;
}

1;
