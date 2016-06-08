package SVG::Estimate::Polyline;

use Moo;
use Math::Trig qw/pi/;
use Clone qw/clone/;

extends 'SVG::Estimate::Shape';
with 'SVG::Estimate::Role::Pythagorean';

has points => (
    is          => 'ro',
    required    => 1,
);

has parsed_points => (
    is          => 'ro',
    lazy        => 1,
    default     => sub {
        my $self = shift;
        return $self->parse_points($self->points);
    },
);

sub parse_points {
    my ($class, $string) = @_;
    $string =~ s/^\s+|\s+$//g;
    my @pairs = split ' ', $string;
    my @points = ();
    foreach my $pair (@pairs) {
        push @points, [ split ',', $pair ];
    }
    return \@points;
}

sub draw_start {
    my $self = shift;
    ##Start drawing at the first point
    return clone $self->parsed_points->[0];
}

sub draw_end {
    my $self = shift;
    ##Stop drawing at the last point
    return clone $self->parsed_points->[-1];
}

sub shape_length {
    my $self = shift;
    my @points = @{ $self->parsed_points };
    my $start = shift @points;
    my $length = 0;
    ##Iterate over the points and find the delta between them
    foreach my $point (@points) {
        $length += $self->pythagorean($start, $point);
        $start = $point;
    }
    return $length;
}

1;
