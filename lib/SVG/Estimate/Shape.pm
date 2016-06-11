package SVG::Estimate::Shape;

use Moo;

=head1 NAME

SVG::Estimate::Shape - Base class for all other shape calculations.

=head1 DESCRIPTION

There are a lot of methods and parameters shared between the various shape classes in L<SVG::Estimate>. This base class encapsulates them all.

=head1 INHERITANCE

This class consumes L<SVG::Estimate::Role::Round> and L<SVG::Estimate::Role::Pythagorean>.

=head1 METHODS

=head2 new( properties ) 

Constructor.

=over

=item properties

=over

=item start_point

An array ref that describes the position of the cursor (or CNC head) prior to drawing this shape (where it left off from the last object).

=back

=back

=cut

has start_point => (
    is          => 'ro', 
    required    => 1,
);

with 'SVG::Estimate::Role::Round';
with 'SVG::Estimate::Role::Pythagorean';

=head2 length ( )

Returns the sum of C<travel_length> and C<shape_length>.

=cut

sub length {
    my $self = shift;
    return $self->travel_length + $self->shape_length;
}

=head2 draw_start ( )

Must be overridden by subclass. Should return an x and a y value as an array ref of where the drawing will start that can be used by the C<travel_length> method.

=cut

sub draw_start {
    die "override draw_start() in subclass";
}

=head2 draw_end ( )

Returns the same as C<draw_start()>. Override this if you have an open ended shape like a line.

=cut

sub draw_end {
    my $self = shift;
    return $self->draw_start;
}

=head2 travel_length ( )

Returns the distance between C<start_point> and where the drawing of the shape begins, which the developer must define as C<draw_start()>

=cut

sub travel_length { 
    my $self = shift;
    return $self->pythagorean($self->draw_start, $self->start_point);
}

=head2 shape_length ( )

Must be overridden by the subclass. Returns the total length of the vectors in the shape.

=cut

sub shape_length { 
    die "override shape_length() in subclass";
}

=head2 min_x ( )

Must be overriden in the subclass. Returns the minimum position of C<x> that this shape will ever reach. 

=cut

sub min_x {
    die "override min_x() in the subclass";
}

=head2 max_x ( )

Must be overriden in the subclass. Returns the maximum position of C<x> that this shape will ever reach. 

=cut

sub max_x {
    die "override max_x() in the subclass";
}

=head2 min_y ( )

Must be overriden in the subclass. Returns the minimum position of C<y> that this shape will ever reach. 

=cut

sub min_y {
    die "override min_y() in the subclass";
}

=head2 max_y ( )

Must be overriden in the subclass. Returns the max position of C<y> that this shape will ever reach. 

=cut

sub max_y {
    die "override max_y() in the subclass";
}


1;
