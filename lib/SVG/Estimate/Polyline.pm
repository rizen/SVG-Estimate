package SVG::Estimate::Polyline;

use Moo;
use Math::Trig qw/pi/;
use Clone qw/clone/;
use List::Util qw/min max/;

extends 'SVG::Estimate::Shape';
with 'SVG::Estimate::Role::Pythagorean';

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
has points => (
    is          => 'ro',
    required    => 1,
);

has parsed_points => (
    is          => 'ro',
    lazy        => 1,
    default     => sub {
        my $self = shift;
        return $self->parse_points($self->points);
    },
);

##Precalculated when parsing points, see below
has _bounding_box => (
    is          => 'rw',
    default     => sub { [] },
);

sub parse_points {
    my ($self, $string) = @_;
    $string =~ s/^\s+|\s+$//g;
    my @pairs = split ' ', $string;
    my @points = ();
    my ($min_x, $max_x, $min_y, $max_y) = (1e10, -1e10, 1e10, -1e10);
    foreach my $pair (@pairs) {
        my ($x, $y) = split ',', $pair;
        $min_x = $x if $x < $min_x;
        $max_x = $x if $x > $max_x;
        $min_y = $y if $y < $min_y;
        $max_y = $y if $y > $max_y;
        push @points, [ $x, $y ];
    }
    $self->_bounding_box([ $min_x, $max_x, $min_y, $max_y ]);
    return \@points;
}

sub draw_start {
    my $self = shift;
    ##Start drawing at the first point
    return clone $self->parsed_points->[0];
}

sub draw_end {
    my $self = shift;
    ##Stop drawing at the last point
    return clone $self->parsed_points->[-1];
}

sub shape_length {
    my $self = shift;
    my @points = @{ $self->parsed_points };
    my $start = shift @points;
    my $length = 0;
    ##Iterate over the points and find the delta between them
    foreach my $point (@points) {
        $length += $self->pythagorean($start, $point);
        $start = $point;
    }
    return $length;
}

sub min_x {
    my $self = shift;
    return $self->_bounding_box->[0];
}

sub max_x {
    my $self = shift;
    return $self->_bounding_box->[1];
}

sub min_y {
    my $self = shift;
    return $self->_bounding_box->[2];
}

sub max_y {
    my $self = shift;
    return $self->_bounding_box->[3];
}

1;
