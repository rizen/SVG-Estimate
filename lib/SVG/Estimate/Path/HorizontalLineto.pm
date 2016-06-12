package SVG::Estimate::Path::HorizontalLineto;

use Moo;

extends 'SVG::Estimate::Path::Command';

=head1 NAME

SVG::Estimate::Path::HorizontalLineto - Handles estimating horizontal lines.

=head1 SYNOPSIS

 my $line = SVG::Estimate::Path::HorizontalLineto->new(
    transform       => $transform,
    start_point     => [13, 19],
    x               => 13,
 );

 my $length = $line->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Path::Command>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item x

A float indicating what to change the x value to.

=back

=cut

has x => (
    is          => 'ro',
    required    => 1,
);

sub end_point {
    my $self = shift;
    return [$self->x, $self->start_point->[1]];
}

sub length {
    my $self = shift;
    return abs($self->x - $self->start_point->[0]); 
}

sub min_x {
    my $self = shift;
    return $self->x;
}

sub max_x {
    my $self = shift;
    return $self->x;
}

sub min_y {
    my $self = shift;
    return $self->start_point->[1];
}

sub max_y {
    my $self = shift;
    return $self->start_point->[1];
}

1;
