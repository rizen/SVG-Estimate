package SVG::Estimate::Path::QuadraticBezier;

use Moo;
use List::Util qw/min max/;

extends 'SVG::Estimate::Path::Command';
with 'SVG::Estimate::Role::EndToPoint';

=head1 NAME

SVG::Estimate::Path::QuadraticBezier - Handles estimating quadratic bezier curves.

=head1 SYNOPSIS

 my $curve = SVG::Estimate::Path::QuadraticBezier->new(
    transform       => $transform,
    point           => [45,13],
    control         => [10,3],
 );

 my $length = $curve->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Path::Command> and consumes L<SVG::Estimate::Role::EndToPoint>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item point

An array ref containing two floats that represent a point. 

=item control

An array ref containing two floats that represent a point. 

=back

=cut

has point => (
    is          => 'ro',
    required    => 1,
);

has control => (
    is          => 'ro',
    required    => 1,
);

sub end_point {
    my $self = shift;
    return $self->point;
}

sub length {
    my $self = shift;
    my $start = $self->start_point;
    my $control = $self->control;
    my $end   = $self->point;

    ##http://www.malczak.info/blog/quadratic-bezier-curve-length/
    my $a_x = $start->[0] - 2 * $control->[0] + $end->[0];
    my $a_y = $start->[1] - 2 * $control->[1] + $end->[1];
    my $b_x = 2 * ($end->[0] - $start->[0]);
    my $b_y = 2 * ($end->[1] - $start->[1]);

    my $A = 4 * ($a_x**2 + $a_y**2);
    my $B = 4 * ($a_x*$b_x + $a_y*$b_y);
    my $C = $b_x**2 + $b_y**2;

    my $SABC = 2 * sqrt($A + $B +$C);
    my $SA   = sqrt($A);
    my $A32  = 2 * $A * $SA;
    my $SC   = 2*sqrt($C);
    my $BA   = $B / $SA;

    my $length = ( $A32 + $SA*$B*($SABC-$SC) + (4*$C*$A - $B*$B)*log( (2*$SA + $BA + $SABC)/($BA + $SC) ) ) / (4*($A32));
    return $length;
}

##Bouding box points approximated by the control points.

sub min_x {
    my $self = shift;
    return min $self->start_point->[0], $self->control->[0], $self->point->[0];
}

sub max_x {
    my $self = shift;
    return max $self->start_point->[0], $self->control->[0], $self->point->[0];
}

sub min_y {
    my $self = shift;
    return min $self->start_point->[1], $self->control->[1], $self->point->[1];
}

sub max_y {
    my $self = shift;
    return max $self->start_point->[1], $self->control->[1], $self->point->[1];
}

1;
