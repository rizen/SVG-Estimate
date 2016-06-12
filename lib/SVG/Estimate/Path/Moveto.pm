package SVG::Estimate::Path::Moveto;

use Moo;

extends 'SVG::Estimate::Path::Command';
with 'SVG::Estimate::Role::Pythagorean';

=head1 NAME

SVG::Estimate::Path::Moveto - Handles estimating non-drawn movement.

=head1 SYNOPSIS

 my $move = SVG::Estimate::Path::Moveto->new(
    transform       => $transform,
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

sub end_point {
    my $self = shift;
    return $self->point;
}

sub length {
    my $self = shift;
    return $self->pythagorean($self->start_point, $self->point);
}

sub min_x {
    my $self = shift;
    return $self->point->[0];
}

sub max_x {
    my $self = shift;
    return $self->point->[0];
}

sub min_y {
    my $self = shift;
    return $self->point->[1];
}

sub max_y {
    my $self = shift;
    return $self->point->[1];
}

1;
