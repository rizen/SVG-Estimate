package SVG::Estimate::Rect;

use Moo;

extends 'SVG::Estimate::Shape';

has x => (
    is => 'ro',
);

has y => (
    is => 'ro',
);

has width => (
    is => 'ro',
);

has height => (
    is => 'ro',
);

sub draw_start {
    my $self = shift;
    return [$self->x, $self->y];
}

sub shape_length {
    my $self = shift;
    return ($self->width + $self->height) * 2;
}

sub min_x {
    my $self = shift;
    return $self->x;
}

sub max_x {
    my $self = shift;
    return $self->x + $self->width;
}

sub min_y {
    my $self = shift;
    return $self->y;
}

sub max_y {
    my $self = shift;
    return $self->y + $self->height;
}

1;
