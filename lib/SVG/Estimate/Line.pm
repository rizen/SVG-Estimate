package SVG::Estimate::Line;

use Moo;

extends 'SVG::Estimate::Shape';
with 'SVG::Estimate::Role::Pythagorean';

has x1 => (
    is => 'ro',
);

has y1 => (
    is => 'ro',
);

has x2 => (
    is => 'ro',
);

has y2 => (
    is => 'ro',
);

has transform => (
    is => 'ro',
);

sub BUILDARGS {
    my ($class, @args) = @_;
    ##Upgrade to hashref
    my $args = @args % 2 ? $args[0] : { @args };
    return $args unless exists $args->{transform};
    my $point1 = $args->{transform}->transform([$args->{x1}, $args->{y1}]);
    my $point2 = $args->{transform}->transform([$args->{x2}, $args->{y2}]);
    $args->{x1} = $point1->[0];
    $args->{y1} = $point1->[1];
    $args->{x2} = $point2->[0];
    $args->{y2} = $point2->[1];
    return $args;
}

sub draw_start {
    my $self = shift;
    return [$self->x1, $self->y1];
}

sub draw_end {
    my $self = shift;
    return [$self->x2, $self->y2];
}

sub shape_length {
    my $self = shift;
    return $self->pythagorean([$self->x1, $self->y1], [$self->x2, $self->y2]);
}

sub min_x {
    my $self = shift;
    return $self->x1 < $self->x2 ? $self->x1 : $self->x2;
}

sub max_x {
    my $self = shift;
    return $self->x1 > $self->x2 ? $self->x1 : $self->x2;
}

sub min_y {
    my $self = shift;
    return $self->y1 < $self->y2 ? $self->y1 : $self->y2;
}

sub max_y {
    my $self = shift;
    return $self->y1 > $self->y2 ? $self->y1 : $self->y2;
}

1;
