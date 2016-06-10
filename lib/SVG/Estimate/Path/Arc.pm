package SVG::Estimate::Path::Arc;

use Moo;
use Math::Trig qw/pi acos deg2rad rad2deg/;

extends 'SVG::Estimate::Path::Command';
with 'SVG::Estimate::Role::Pythagorean';
with 'SVG::Estimate::Role::SegmentLength';
with 'SVG::Estimate::Role::EndToPoint';

has rx => (
    is          => 'ro',
    required    => 1,
);

has ry => (
    is          => 'ro',
    required    => 1,
);

has x_axis_rotation => (
    is          => 'ro',
    required    => 1,
);

has large_arc_flag => (
    is          => 'ro',
    required    => 1,
);

has sweep_flag => (
    is          => 'ro',
    required    => 1,
);

has point => (
    is          => 'ro',
    required    => 1,
);

##Precalculated when parsing points, see below
has min_x => (
    is          => 'rwp',
    default     => sub { 1e10 },
);
has max_x => (
    is          => 'rwp',
    default     => sub { -1e10 },
);
has min_y => (
    is          => 'rwp',
    default     => sub { 1e10 },
);
has max_y => (
    is          => 'rwp',
    default     => sub { -1e10 },
);

##Used for conversion from endpoint to center parameterization
has _delta => (
    is          => 'rw',
);

has _theta => (
    is          => 'rw',
);

has _center => (
    is          => 'rw',
);

sub BUILD {
    my $self = shift;
    my $rotr = deg2rad($self->x_axis_rotation);
    my $cosr = cos $rotr;
    my $sinr = sin $rotr;
    my $dx   = ($self->start_point->[0] - $self->point->[0] ) / 2; #*
    my $dy   = ($self->start_point->[1] - $self->point->[1] ) / 2; #*

    my $x1prim = $cosr * $dx + $sinr * $dy; #*
    my $y1prim = -1*$sinr * $dx + $cosr * $dy; #*

    warn "x1prime: $x1prim\n";
    warn "y1prime: $y1prim\n";

    my $x1prim_sq = $x1prim**2; #*
    my $y1prim_sq = $y1prim**2; #*

    my $rx = $self->rx; #*
    my $ry = $self->ry; #*

    my $rx_sq = $rx**2; #*
    my $ry_sq = $ry**2; #*

    #my $radius_check = ($x1prim_sq / $rx_sq) + ($y1prim_sq / $ry_sq);
    #if ($radius_check > 1) {
    #    $rx *= sqrt($radius_check);
    #    $ry *= sqrt($radius_check);
    #    $rx_sq = $rx**2;
    #    $ry_sq = $ry**2;
    #}

    my $t1 = $rx_sq * $y1prim_sq;
    my $t2 = $ry_sq * $x1prim_sq;
    my $ts = $t1 + $t2;
    my $c  = sqrt(abs( (($rx_sq * $ry_sq) - $ts) / ($ts) ) );

    warn "rx^2ry^2: ".($rx_sq * $ry_sq);
    warn "ts: $ts\n";
    warn "c: $c\n";
    
    if ($self->large_arc_flag == $self->sweep_flag) {
        $c *= -1;
    }
    my $cxprim =     $c * $rx * $y1prim / $ry;
    my $cyprim = -1 *$c * $ry * $x1prim / $rx;

    $self->_center([
        ($cosr * $cxprim - $sinr * $cyprim) + ( ($self->start_point->[0] + $self->point->[0]) / 2 ),
        ($sinr * $cxprim + $cosr * $cyprim) + ( ($self->start_point->[1] + $self->point->[1]) / 2 )
    ]);

    my $ux = ($x1prim - $cxprim) / $rx;
    my $uy = ($y1prim - $cyprim) / $ry;
    my $vx = -1 * ($x1prim + $cxprim) / $rx;
    my $vy = -1 * ($y1prim + $cyprim) / $ry;
    my $n = sqrt($ux**2 + $uy**2);
    my $p = $ux;
    my $theta = rad2deg(acos($p/$n));
    if ($uy < 0) {
        $theta *= -1;
    }
    $self->_theta($theta % 360);

    $n = sqrt( ($ux**2 + $uy**2) * ($vx**2 + $vy**2));
    $p = $ux*$vx + $uy*$vy;
    my $d = $p / $n;

    if ($d > 1) {
        $d = 1;
    }
    elsif ($d < -1) {
        $d = -1;
    }
    my $delta = rad2deg(acos($d));
    if (($ux * $vy - $uy * $vx) < 0 ) {
        $delta *= -1;
    }
    $delta = $delta % 360;

    if (! $self->sweep_flag) {
        $delta -= 360;
    }
    $self->_delta($delta);
}

sub end_point {
    my $self = shift;
    return $self->point;
}

=head2 this_point (t)

Calculate a point on the graph, normalized from start point to end point as t, in 2-D space

=cut

sub this_point {
    my $self = shift;
    my $t    = shift;
    my $angle = deg2rad($self->_theta + ($self->_delta * $t));
    my $rotr  = deg2rad($self->x_axis_rotation);
    my $cosr  = cos $rotr;
    my $sinr  = sin $rotr;
    my $x     = ($cosr * cos($angle) * $self->rx - $sinr * sin($angle) * $self->ry + $self->_center->[0]);
    my $y     = ($sinr * cos($angle) * $self->rx + $cosr * sin($angle) * $self->ry + $self->_center->[1]);
    return [$x, $y];
}

sub length {
    my $self = shift;
    my $start = $self->this_point(0);
    my $end   = $self->this_point(1);
    $self->_set_min_x( $start->[0] < $end->[0] ? $start->[0] : $end->[0]);
    $self->_set_max_x( $start->[0] > $end->[0] ? $start->[0] : $end->[0]);
    $self->_set_min_y( $start->[1] < $end->[1] ? $start->[1] : $end->[1]);
    $self->_set_max_y( $start->[1] > $end->[1] ? $start->[1] : $end->[1]);
    return $self->segment_length(0, 1, $start, $end, 1e-4, 5, 0);
}

1;
