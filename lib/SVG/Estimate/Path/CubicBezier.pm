package SVG::Estimate::Path::CubicBezier;

use Moo;

extends 'SVG::Estimate::Path::Command';
with 'SVG::Estimate::Role::Pythagorean';

has point => (
    is          => 'ro',
    required    => 1,
);

has control_point1 => (
    is          => 'ro',
    required    => 1,
);

has control_point2 => (
    is          => 'ro',
    required    => 1,
);

sub end_point {
    my $self = shift;
    return $self->point;
}

sub _this_point {
    shift;
    my ($t, $s, $c1, $c2, $p) = @_;
    return ((1 - $t)**3 * $s)
         + (3 * (1 - $t)**2  * $t    * $c1)
         + (3 * (1 - $t)     * $t**2 * $c2)
         + ($t**3  * $p)
         ;
}

sub this_point {
    my $self = shift;
    my $t    = shift;
    return [
        $self->_this_point($t, $self->start_point->[0], $self->control_point1->[0], $self->control_point2->[0], $self->point->[0]),
        $self->_this_point($t, $self->start_point->[1], $self->control_point1->[1], $self->control_point2->[1], $self->point->[1])
    ];
}


sub length {
    my $self = shift;
    my $start = $self->this_point(0);
    my $end   = $self->this_point(1);
    return $self->segment_length(0, 1, $start, $end, 1e-6, 5, 0);
}

sub segment_length {
    my $self = shift;
    my ($t0, $t1, $start, $end, $error, $min_depth, $depth) = @_;
    my $th = ($t1 + $t0) / 2;  ##half-way
    my $mid = $self->this_point($th);
    my $length = $self->pythagorean($start, $end); ##Segment from start to end
    my $left   = $self->pythagorean($start, $mid);
    my $right  = $self->pythagorean($mid,   $end);
    my $length2 = $left + $right;  ##Sum of segments through midpoint
    if ($length2 - $length > $error || $depth < $min_depth) {
        ++$depth;
        return $self->segment_length($t0, $th, $start, $mid, $error, $min_depth, $depth)
             + $self->segment_length($th, $t1, $mid,   $end, $error, $min_depth, $depth)
    }
    return $length2;
}

1;
