package SVG::Estimate::Role::SegmentLength;

use strict;
use Moo::Role;

=head2 segment_length ( t0, t1, start_point, end_point, tolerance, minimum_iterations, current_iteration)

Calculate the distance

=cut


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
