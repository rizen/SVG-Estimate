package SVG::Estimate::Path::Command;

use Moo;

=head1 NAME

SVG::Estimate::Path::Command - Base class for all path calculations.

=head1 DESCRIPTION

There are a lot of methods and parameters shared between the various shape classes in L<SVG::Estimate::Path>. This base class encapsulates them all.

=head1 METHODS

=head2 new( properties ) 

Constructor.

=over

=item properties

=over

=item start_point

An array ref that describes the position of the cursor (or CNC head) prior to drawing this path (where it left off from the last object).

=back

=back

=cut

has start_point => (
    is          => 'ro', 
    required    => 1,
);

=head2 end_point ( )

Must be overridden by subclass. Should return an array ref that contains an end point of where this command left off to fill the C<start_point> of the next command.

=cut

sub end_point {
    die "override end_point() in sub class";
}

=head2 length ( )

Must be overridden by the subclass. Returns the total length of the vector in the path command.

=cut

sub length { 
    die "override length() in sub class";
}

=head2 round ( value [, significant ] )

Rounds to the nearest 1000th of a unit unless you specify a different significant digit.

=cut

sub round {
    my ($self, $value, $significant) = @_;
    return sprintf '%.'.($significant || 3).'f', $value;
}

1;
