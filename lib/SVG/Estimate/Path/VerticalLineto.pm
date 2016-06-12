package SVG::Estimate::Path::VerticalLineto;

use Moo;

extends 'SVG::Estimate::Path::Command';

=head1 NAME

SVG::Estimate::Path::VerticalLineto - Handles estimating vertical lines.

=head1 SYNOPSIS

 my $line = SVG::Estimate::Path::VerticalLineto->new(
    transform       => $transform,
    start_point     => [13, 19],
    y               => 45,
 );

 my $length = $line->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Path::Command>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item y

A float representing what to change the y value to.

=back

=cut

has y => (
    is          => 'ro',
    required    => 1,
);

sub end_point {
    my $self = shift;
    return [$self->start_point->[0], $self->y];
}

sub length {
    my $self = shift;
    return abs($self->y - $self->start_point->[1]); 
}

sub min_x {
    my $self = shift;
    return $self->start_point->[0];
}

sub max_x {
    my $self = shift;
    return $self->start_point->[0];
}

sub min_y {
    my $self = shift;
    return $self->y;
}

sub max_y {
    my $self = shift;
    return $self->y;
}

1;
