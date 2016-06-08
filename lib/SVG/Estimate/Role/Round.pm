package SVG::Estimate::Role::Round;

use strict;
use Moo::Role;

=head2 round ( value [, significant ] )

Rounds to the nearest 1000th of a unit unless you specify a different significant digit.

=cut

sub round {
    my ($self, $value, $significant) = @_;
    return sprintf '%.'.($significant || 3).'f', $value;
}


1;
