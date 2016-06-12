package SVG::Estimate::Path::CubicBezier;

use Moo;
use List::Util qw/min max/;

extends 'SVG::Estimate::Path::Command';
with 'SVG::Estimate::Role::Pythagorean';
with 'SVG::Estimate::Role::SegmentLength';
with 'SVG::Estimate::Role::EndToPoint';

=head1 NAME

SVG::Estimate::Path::CubicBezier - Handles estimating cubic bezier curves.

=head1 SYNOPSIS

 my $curve = SVG::Estimate::Path::CubicBezier->new(
    transform       => $transform,
    start_point     => [13, 19],
    point           => [45,13],
    control1        => [10,3],
    control2        => [157,40],
 );

 my $length = $curve->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Path::Command> and consumes L<SVG::Estimate::Role::Pythagorean>, L<SVG::Estimate::Role::SegmentLength>, and L<SVG::Estimate::Role::EndToPoint>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item point

An array ref containing two floats that represent a point. 

=item control1

An array ref containing two floats that represent a point. 

=item control2

An array ref containing two floats that represent a point. 

=back

=cut

has point => (
    is          => 'ro',
    required    => 1,
);

has control1 => (
    is          => 'ro',
    required    => 1,
);

has control2 => (
    is          => 'ro',
    required    => 1,
);

##Precalculated when parsing points, see below
has min_x => (
    is          => 'rwp',
    default     => sub { 1e10 },
);
has max_x => (
    is          => 'rwp',
    default     => sub { -1e10 },
);
has min_y => (
    is          => 'rwp',
    default     => sub { 1e10 },
);
has max_y => (
    is          => 'rwp',
    default     => sub { -1e10 },
);

sub end_point {
    my $self = shift;
    return $self->point;
}

sub _this_point {
    shift;
    my ($t, $s, $c1, $c2, $p) = @_;
    return ((1 - $t)**3 * $s)
         + (3 * (1 - $t)**2  * $t    * $c1)
         + (3 * (1 - $t)     * $t**2 * $c2)
         + ($t**3  * $p)
         ;
}

sub this_point {
    my $self = shift;
    my $t    = shift;
    return [
        $self->_this_point($t, $self->start_point->[0], $self->control1->[0], $self->control2->[0], $self->point->[0]),
        $self->_this_point($t, $self->start_point->[1], $self->control1->[1], $self->control2->[1], $self->point->[1])
    ];
}


sub length {
    my $self = shift;
    my $start = $self->this_point(0);
    my $end   = $self->this_point(1);
    $self->_set_min_x( $start->[0] < $end->[0] ? $start->[0] : $end->[0]);
    $self->_set_max_x( $start->[0] > $end->[0] ? $start->[0] : $end->[0]);
    $self->_set_min_y( $start->[1] < $end->[1] ? $start->[1] : $end->[1]);
    $self->_set_max_y( $start->[1] > $end->[1] ? $start->[1] : $end->[1]);
    return $self->segment_length(0, 1, $start, $end, 1e-4, 5, 0);
}

1;
