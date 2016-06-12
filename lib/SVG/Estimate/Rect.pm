package SVG::Estimate::Rect;

use Moo;

extends 'SVG::Estimate::Shape';

=head1 NAME

SVG::Estimate::Rect - Handles estimating rectangles.

=head1 SYNOPIS

 my $rect = SVG::Estimate::Rect->new(
    transform   => $transform,
    start_point => [45,13],
    x           => 3,
    y           => 6,
    width       => 11.76,
    height      => 15.519,
 );

 my $length = $rect->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Shape>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item x

Float representing the top left corner x.

=item y

Float representing the top left corner y.

=item width

Float representing the width of the box.

=item height

Float representing the height of the box.

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
