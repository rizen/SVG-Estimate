package SVG::Estimate::Path::Arc;

use Moo;
use Math::Trig qw/pi acos deg2rad rad2deg/;
use strict;

extends 'SVG::Estimate::Path::Command';
with 'SVG::Estimate::Role::Pythagorean';
with 'SVG::Estimate::Role::SegmentLength';
with 'SVG::Estimate::Role::EndToPoint';

=head1 NAME

SVG::Estimate::Path::Arc - Handles estimating arcs.

=head1 SYNOPSIS

 my $arc = SVG::Estimate::Path::Arc->new(
    transform   => $transform,
    start_point => [45,13],
    cx          => 1,
    cy          => 3,
    r           => 1,
 );

 my $length = $arc->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Shape>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item point

An array ref containing two floats that represent a point. 

=item rx

Float representing the x radius.

=item ry

Float representing the y radius.

=item x_axis_rotation

Float that indicates how the ellipse as a whole is rotated relative to the current coordinate system.

=item large_arc_flag



=item sweep_flag



=back

=cut

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

    my $x1prim_sq = $x1prim**2; #*
    my $y1prim_sq = $y1prim**2; #*

    my $rx = $self->rx; #*
    my $ry = $self->ry; #*

    my $rx_sq = $rx**2; #*
    my $ry_sq = $ry**2; #*

    my $t1 = $rx_sq * $y1prim_sq;
    my $t2 = $ry_sq * $x1prim_sq;
    my $ts = $t1 + $t2;
    my $c  = sqrt(abs( (($rx_sq * $ry_sq) - $ts) / ($ts) ) );

    if ($self->large_arc_flag == $self->sweep_flag) {
        $c *= -1;
    }
    my $cxprim =     $c * $rx * $y1prim / $ry;
    my $cyprim = -1 *$c * $ry * $x1prim / $rx;

    $self->_center([
        ($cosr * $cxprim - $sinr * $cyprim) + ( ($self->start_point->[0] + $self->point->[0]) / 2 ),
        ($sinr * $cxprim + $cosr * $cyprim) + ( ($self->start_point->[1] + $self->point->[1]) / 2 )
    ]);

    ##**

    ##Theta calculation
    my $ux = ($x1prim - $cxprim) / $rx;   #*
    my $uy = ($y1prim - $cyprim) / $ry;   #*
    my $n = sqrt($ux**2 + $uy**2);
    my $p = $ux;
    my $d = $p / $n;
    my $theta = rad2deg(acos($p/$n));
    if ($uy < 0) {
        $theta *= -1;
    }
    $self->_theta($theta % 360);

    my $vx = -1 * ($x1prim + $cxprim) / $rx;
    my $vy = -1 * ($y1prim + $cyprim) / $ry;
    $n = sqrt( ($ux**2 + $uy**2) * ($vx**2 + $vy**2));
    $p = $ux*$vx + $uy*$vy;
    $d = $p / $n;

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
