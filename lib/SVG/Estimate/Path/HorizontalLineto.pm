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
