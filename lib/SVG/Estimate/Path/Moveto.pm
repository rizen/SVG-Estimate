package SVG::Estimate::Path::Moveto;

use Moo;

extends 'SVG::Estimate::Path::Command';
with 'SVG::Estimate::Role::Pythagorean';

=head1 NAME

SVG::Estimate::Path::Moveto - Handles estimating non-drawn movement.

=head1 SYNOPSIS

 my $move = SVG::Estimate::Path::Moveto->new(
    transform       => $transform,
    start_point     => [13, 19],
    point           => [45,13],
 );

 my $length = $move->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Path::Command> and consumes L<SVG::Estimate::Role::Pythagorean>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item point

An array ref containing two floats that represent a point. 

=back

=cut

has point => (
    is          => 'ro',
    required    => 1,
);

sub BUILDARGS {
    my ($class, @args) = @_;
    ##Upgrade to hashref
    my $args = @args % 2 ? $args[0] : { @args };
    my $point  = $args->{point};
    if ($args->{transform}->has_transforms) {
        $point   = $args->{transform}->transform($point);
    }
    $args->{start_point}  = $args->{start_point};
    $args->{end_point}    = $point;
    $args->{length}       = $class->pythagorean($args->{start_point}, $args->{end_point});
    $args->{min_x}        = $point->[0];
    $args->{min_y}        = $point->[1];
    $args->{max_x}        = $point->[0];
    $args->{max_y}        = $point->[1];
    return $args;
}

1;
