package SVG::Estimate::Role::ArgsWithUnits;

use strict;
use Moo::Role;
use Ouch;

=head1 NAME

SVG::Estimate::Role::ArgsWithUnits - Validate a list of arguments that could contain units

=head1 METHODS

=head2 BUILD ( )

Validate the set of args from the class's C<args_with_units> method to make sure they don't have units

=cut

sub BUILD {
    my ($self, $args) = @_;
    foreach my $param ($self->args_with_units) {
        if ($args->{$param} =~ /\d\D+$/) {
            ouch 'units detected', "$param is not allowed to have units", $args->{$param};
        }
    }
}


1;
