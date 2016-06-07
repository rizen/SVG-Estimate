package SVG::Estimate::Shape;

use Moo;

=head1 NAME

SVG::Estimate::Shape - Base class for all other shape calculations.

=head1 DESCRIPTION

There are a lot of methods and parameters shared between the various shape classes in L<SVG::Estimate>. This base class encapsulates them all.

=head1 METHODS

=head2 new( properties ) 

Constructor.

=over

=item properties

=over

=item startx

Where is the cursor (or CNC head) prior to drawing this shape on the x-axis.

=item starty

Where is the cursor (or CNC head) prior to drawing this shape on the x-axis.

=back

=back

=cut

has startx => (
    is          => 'ro', 
    required    => 1,
);

has starty => (
    is          => 'ro', 
    required    => 1,
);

=head2 length ( )

Returns the sum of C<travel_length> and C<shape_length>.

=cut

sub length {
    my $self = shift;
    return $self->travel_length + $self->shape_length;
}

=head2 draw_start ( )

Must be overridden by subclass. Should return an x and a y value of where the drawing will start that can be used by the C<travel_length> method.

=cut

sub draw_start {
    die "override draw_start() in sub class"
}

=head2 travel_length ( )

Returns the distance between C<startx>,C<starty> and where the drawing of the shape begins, which the developer must define as C<draw_start()>

=cut

sub { 
    my $self = shift;
    my ($drawx, $drawy) = $self->draw_start;
    my $a = $drawx - $self->startx;
    my $b = $drawy - $self->starty;
    return sqrt(($a**2)+($b**2)); 
}

=head2 shape_length ( )

Must be overridden by the subclass. Returns the total length of the vectors in the shape.

=cut

sub { 
    die "override shape_length() in sub class"
}


1;
