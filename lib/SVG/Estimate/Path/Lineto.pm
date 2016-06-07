package SVG::Estimate::Path::Lineto;

use Moo;

extends 'SVG::Estimate::Path::Command';

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
    my $a = $self->point->[0] - $self->start_point->[0];
    my $b = $self->point->[1] - $self->start_point->[1];
    return sqrt(($a**2)+($b**2)); 
}

1;
