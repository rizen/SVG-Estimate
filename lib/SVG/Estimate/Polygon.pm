package SVG::Estimate::Polygon;

use Moo;
use Math::Trig qw/pi/;
use Clone qw/clone/;

extends 'SVG::Estimate::Polyline';

around parsed_points => sub {
    my $orig = shift;
    my $self = shift;
    my $points = $self->$orig();
    my $start_point = clone $points->[0];
    push @{ $points }, $start_point;
    return $points;
};

1;
