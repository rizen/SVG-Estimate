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

1;
