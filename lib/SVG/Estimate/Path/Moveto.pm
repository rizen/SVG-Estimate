package SVG::Estimate::Path::Moveto;

use Moo;

extends 'SVG::Estimate::Path::Command';
with 'SVG::Estimate::Role::Pythagorean';

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

1;
