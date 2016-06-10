package SVG::Estimate::Line;

use Moo;

extends 'SVG::Estimate::Shape';
with 'SVG::Estimate::Role::Pythagorean';

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
    return [$self->x1, $self->y1];
}

sub draw_end {
    my $self = shift;
    return [$self->x2, $self->y2];
}

sub shape_length {
    my $self = shift;
    return $self->pythagorean([$self->x1, $self->y1], [$self->x2, $self->y2]);
}

sub min_x {
    my $self = shift;
    return $self->x1 < $self->x2 ? $self->x1 : $self->x2;
}

sub max_x {
    my $self = shift;
    return $self->x1 > $self->x2 ? $self->x1 : $self->x2;
}

sub min_y {
    my $self = shift;
    return $self->y1 < $self->y2 ? $self->y1 : $self->y2;
}

sub max_y {
    my $self = shift;
    return $self->y1 > $self->y2 ? $self->y1 : $self->y2;
}

1;
