package SVG::Estimate::Path::VerticalLineto;

use Moo;

extends 'SVG::Estimate::Path::Command';

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

1;
