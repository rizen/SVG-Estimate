package SVG::Estimate::Role::Pythagorean;

use strict;
use Moo::Role;

=head2 pythagorean ( point1, point2 )

Calculates the distance between two points.

=cut

sub pythagorean {
    my ($self, $p1, $p2) = @_;
    my $dy = $p2->[1] - $p1->[1];
    my $dx = $p2->[0] - $p1->[0];
    return sqrt(($dx**2)+($dy**2)); 
}


1;
