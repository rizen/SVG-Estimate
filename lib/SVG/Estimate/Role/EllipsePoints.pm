package SVG::Estimate::Role::EllipsePoints;


use strict;
use Moo::Role;
use Math::Trig qw/deg2rad/;

=head2 this_point (t)

Calculate a point on an ellipse, normalized from start point to end point as t, in 2-D space

=cut

sub this_point
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

1;
