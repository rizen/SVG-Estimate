package SVG::Estimate::Path::QuadraticBezier;

use Moo;

extends 'SVG::Estimate::Path::Command';

has point => (
    is          => 'ro',
    required    => 1,
);

has control_point => (
    is          => 'ro',
    required    => 1,
);

sub end_point {
    my $self = shift;
    return $self->point;
}

sub length {
    my $self = shift;
    my $start = $self->start_point;
    my $control = $self->control_point;
    my $end   = $self->point;

    my $a_x = $start->[0] - 2 * $control->[0] + $end->[0];
    my $a_y = $start->[1] - 2 * $control->[1] + $end->[1];
    my $b_x = 2 * ($end->[0] - $start->[0]);
    my $b_y = 2 * ($end->[1] - $start->[1]);

    my $A = 4 * ($a_x**2 + $a_y**2);
    my $B = 4 * ($a_x*$b_x + $a_y*$b_y);
    my $C = $b_x**2 + $b_y**2;

    my $SABC = 2 * sqrt($A + $B +$C);
    my $SA   = sqrt($A);
    my $A32  = 2 * $A * $SA;
    my $SC   = 2*sqrt($C);
    my $BA   = $B / $SA;

    my $length = ( $A32 + $SA*$B*($SABC-$SC) + (4*$C*$A - $B*$B)*log( (2*$SA + $BA + $SABC)/($BA + $SC) ) ) / (4*($A32));
}

1;
