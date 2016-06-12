package SVG::Estimate::Circle;

use Moo;
use Math::Trig qw/pi/;

extends 'SVG::Estimate::Shape';

=head1 NAME

SVG::Estimate::Circle - Handles estimating circles.

=head1 SYNOPSIS

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

sub BUILDARGS {
    my ($class, @args) = @_;
    ##Upgrade to hashref
    my $args = @args % 2 ? $args[0] : { @args };
    my $center   = [ $args->{cx}, $args->{cy} ];
    my $opposite = [ $args->{x} + $args->{width}, $args->{y} + $args->{height} ];
    if ($args->{transform}->has_transforms) {
        $center   = $args->{transform}->transform($center);
        $opposite = $args->{transform}->transform($opposite);
        $args->{x} = $origin->[0] < $opposite->[0] ? $origin->[0] : $opposite->[0];
        $args->{y} = $origin->[1] < $opposite->[1] ? $origin->[1] : $opposite->[1];
        $args->{width}  = abs($opposite->[0] - $origin->[0]);
        $args->{height} = abs($opposite->[1] - $origin->[1]);
    }
    $args->{draw_start}   = $center;
    $args->{draw_end}     = $center;
    $args->{shape_length} = ($args->{width} + $args->{height}) * 2;
    $args->{min_x}        = $origin->[0];
    $args->{min_y}        = $origin->[1];
    $args->{max_x}        = $opposite->[0];
    $args->{max_y}        = $opposite->[1];
    return $args;
}
1;
