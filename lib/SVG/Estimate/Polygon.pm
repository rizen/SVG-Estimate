package SVG::Estimate::Polygon;

use Moo;
use Math::Trig qw/pi/;

extends 'SVG::Estimate::Polyline';

sub BUILDARGS {
    my ($class, %args) = @_;
    push @{ $args{points}, }, $args{points}->[0];
    return \%args;
}

1;
