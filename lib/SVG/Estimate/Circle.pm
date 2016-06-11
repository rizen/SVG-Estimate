package SVG::Estimate::Circle;

use Moo;
use Math::Trig qw/pi/;

extends 'SVG::Estimate::Shape';

=head1 NAME

SVG::Estimate::Circle - Handles estimating circles.

=head1 SYNOPIS

 my $circle = SVG::Estimate::Circle->new(
    start_point => [45,13],
    cx          => 1,
    cy          => 3,
    r           => 1,
 );

 my $length = $circle->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Shape>.

=head1 METHODS

has cx => (
    is => 'ro',
);

has cy => (
    is => 'ro',
);

has r => (
    is => 'ro',
);

sub draw_start {
    my $self = shift;
    return [$self->cx, $self->cy + 0.5*$self->r];
}

sub shape_length {
    my $self = shift;
    return 2 * pi * $self->r;
}

sub min_x {
    my $self = shift;
    return $self->cx - $self->r;
}

sub max_x {
    my $self = shift;
    return $self->cx + $self->r;
}

sub min_y {
    my $self = shift;
    return $self->cy - $self->r;
}

sub max_y {
    my $self = shift;
    return $self->cy + $self->r;
}

1;
