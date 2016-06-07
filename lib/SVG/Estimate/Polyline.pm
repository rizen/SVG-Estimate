package SVG::Estimate::Polyline;

use Moo;
use Math::Trig qw/pi/;

extends 'SVG::Estimate::Shape';

has points => (
    is          => 'ro',
    required    => 1,
);

sub draw_start {
    my $self = shift;
    ##Start drawing at the first point
    return $self->points->[0];
}

sub draw_end {
    my $self = shift;
    ##Stop drawing at the last point
    return $self->points->[-1];
}

sub shape_length {
    my $self = shift;
    my @points = @{ $self->points };
    my $start = shift @points;
    my $length = 0;
    ##Iterate over the points and find the delta between them
    foreach my $point (@points) {
        my $dx = $point->[0] - $start->[0];
        my $dy = $point->[1] - $start->[1];
        $length += sqrt ($dx**2 + $dy**2);
        $start = $point;
    }
    return $length;
}

1;
