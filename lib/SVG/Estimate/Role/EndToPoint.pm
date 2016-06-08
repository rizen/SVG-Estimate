package SVG::Estimate::Role::EndToPoint;

use strict;
use Moo::Role;

=head2 BUILDARGS ( )

Change arguments from "end" to "point", mainly for Path command objects

=cut

sub BUILDARGS {
    my ($class, @args) = @_;
    my $args = @args % 2 ? $args[0] : { @args };
    $args->{point} = $args->{end};
    return $args;
}


1;

