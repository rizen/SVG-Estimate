package SVG::Estimate::Rect;

use Moo;

extends 'SVG::Estimate::Shape';

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

has x => (
    is => 'ro',
);

has y => (
    is => 'ro',
);

has width => (
    is => 'ro',
);

has height => (
    is => 'ro',
);

sub draw_start {
    my $self = shift;
    return [$self->x, $self->y];
}

sub shape_length {
    my $self = shift;
    return ($self->width + $self->height) * 2;
}

sub min_x {
    my $self = shift;
    return $self->x;
}

sub max_x {
    my $self = shift;
    return $self->x + $self->width;
}

sub min_y {
    my $self = shift;
    return $self->y;
}

sub max_y {
    my $self = shift;
    return $self->y + $self->height;
}

1;
