package SVG::Estimate::Role::Dpi;

use strict;
use Moo::Role;

=head2 dpi ( value [, dpi | 72 ] )

Converts from pixels to dpi

=cut

sub dpi {
    my ($self, $value, $dpi) = @_;
    $dpi ||= 72;
    return $value / $dpi;
}


1;
