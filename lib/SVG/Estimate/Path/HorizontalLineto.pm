package SVG::Estimate::Path::HorizontalLineto;

use Moo;
use Clone qw/clone/;

extends 'SVG::Estimate::Path::Command';

has x => (
    is          => 'ro',
    required    => 1,
);

sub end_point {
    my $self = shift;
    my $point = clone $self->start_point;
    $point->[0] += $self->x;
    return $point;
}

sub length {
    my $self = shift;
    return $self->x; 
}

1;
