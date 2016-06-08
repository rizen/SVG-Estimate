package SVG::Estimate::Polygon;

use Moo;
use Math::Trig qw/pi/;
use Clone qw/clone/;

extends 'SVG::Estimate::Polyline';

sub BUILDARGS {
    my ($class, @args) = @_;
    ##Upgrade to hashref
    my $args = @args % 2 ? $args[0] : { @args };
    my $points = clone $class->parse_points($args->{points});
    my $start_point = clone $points->[0];
    push @{ $points }, $start_point;
    $args->{parsed_points} = $points;
    return $args;
}

1;
