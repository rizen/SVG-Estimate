package SVG::Estimate::Path::HorizontalLineto;

use Moo;

extends 'SVG::Estimate::Path::Command';

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

1;
