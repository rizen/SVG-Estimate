package SVG::Estimate::Ellipse;

use Moo;
use Math::Trig qw/pi/;

extends 'SVG::Estimate::Shape';

has cx => (
    is => 'ro',
);

has cy => (
    is => 'ro',
);

has rx => (
    is => 'ro',
);

has rx => (
    is => 'ro',
);

sub draw_start {
    my $self = shift;
    return ($self->cx, $self->cy + 0.5*$self->ry);
}

sub shape_length {
    my $self = shift;
    my $h = ($self->rx - $self->ry)**2 / ($self->rx + $self->ry) **2;
    my $len = 2 * pi * ( 1 + $h/4 + ($h**2)/64 + ($h**3)/256 + ($h**4 * (25/16384)));
    return $len;
}
