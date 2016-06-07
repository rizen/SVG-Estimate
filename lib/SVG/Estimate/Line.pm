package SVG::Estimate::Line;

use Moo;

extends 'SVG::Estimate::Shape';

has x1 => (
    is => 'ro',
);

has y1 => (
    is => 'ro',
);

has x2 => (
    is => 'ro',
);

has y2 => (
    is => 'ro',
);

sub draw_start {
    my $self = shift;
    return ($self->x1, $self->y1);
}

sub draw_end {
    my $self = shift;
    return ($self->x2, $self->y2);
}

sub shape_length {
    my $self = shift;
    my $a = $self->x2 - $self->x1;
    my $b = $self->y2 - $self->y1;
    return sqrt(($a**2)+($b**2)); 
}

1;
