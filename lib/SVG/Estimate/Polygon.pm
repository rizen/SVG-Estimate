package SVG::Estimate::Polygon;

use Moo;
use Math::Trig qw/pi/;
use Clone qw/clone/;

extends 'SVG::Estimate::Polyline';

sub BUILDARGS {
    my ($class, @args) = @_;
    ##Upgrade to hashref
    my $args = @args % 2 ? $args[0] : { @args };
    my $points = clone $args->{points};
    my $start_point = clone $points->[0];
    push @{ $points }, $start_point;
    $args->{points} = $points;
    return $args;
}

1;
