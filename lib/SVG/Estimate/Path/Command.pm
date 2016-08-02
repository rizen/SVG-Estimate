package SVG::Estimate::Path::Command;

use Moo;
with 'SVG::Estimate::Role::Round';


=head1 NAME

SVG::Estimate::Path::Command - Base class for all path calculations.

=head1 DESCRIPTION

There are a lot of methods and parameters shared between the various shape classes in L<SVG::Estimate::Path>. This base class encapsulates them all.

=head1 INHERITANCE

This class consumes L<SVG::Estimate::Role::Round>.

=head1 METHODS

=head2 new( properties ) 

Constructor.

=over

=item properties

=over

=item start_point

An array ref that describes the position of the cursor (or CNC head) prior to drawing this path (where it left off from the last object).

=item transformer

A reference to a L<Image::SVG::Transform> object that contains all the transforms for this path segment.

=back

=back

=cut

has start_point => (
    is          => 'ro', 
    required    => 1,
);

has transformer => (
    is          => 'ro',
    required    => 1,
);

=head2 end_point ( )

Returns an array ref that contains an end point of where this command left off to fill the C<start_point> of the next command.

=cut

has end_point => (
    is          => 'ro',
    required    => 1,
);

=head2 shape_length ( )

Returns the total shape length of the vector in the path command.

=cut

has shape_length => (
    is          => 'ro',
    required    => 1,
);

=head2 travel_length ( )

Returns the total travel length of the vector in the path command.

=cut

has travel_length => (
    is          => 'ro',
    required    => 1,
);

=head2 min_x ( )

Returns the minimum position of C<x> that this path segment will ever reach. 

=cut

has min_x => (
    is          => 'ro',
    required    => 1,
);

=head2 max_x ( )

Returns the maximum position of C<x> that this path segment will ever reach. 

=cut

has max_x => (
    is          => 'ro',
    required    => 1,
);

=head2 min_y ( )

Returns the minimum position of C<y> that this path segment will ever reach. 

=cut

has min_y => (
    is          => 'ro',
    required    => 1,
);

=head2 max_y ( )

Returns the max position of C<y> that this path segment will ever reach. 

=cut

has max_y => (
    is          => 'ro',
    required    => 1,
);


1;
