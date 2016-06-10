package SVG::Estimate::Path::Lineto;

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
