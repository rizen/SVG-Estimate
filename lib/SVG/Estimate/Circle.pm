package SVG::Estimate::Circle;

use Moo;
use Math::Trig qw/pi/;

extends 'SVG::Estimate::Shape';

has cx => (
    is => 'ro',
);

has cy => (
    is => 'ro',
);

has r => (
    is => 'ro',
);

sub draw_start {
    my $self = shift;
    return [$self->cx, $self->cy + 0.5*$self->r];
}

sub shape_length {
    my $self = shift;
    return 2 * pi * $self->r;
}

sub min_x {
    my $self = shift;
    return $self->cx - $self->r;
}

sub max_x {
    my $self = shift;
    return $self->cx + $self->r;
}

sub min_y {
    my $self = shift;
    return $self->cy - $self->r;
}

sub max_y {
    my $self = shift;
    return $self->cy + $self->r;
}

1;
