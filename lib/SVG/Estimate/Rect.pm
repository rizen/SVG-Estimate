package SVG::Estimate::Rect;

use Moo;

extends 'SVG::Estimate::Shape';

=head1 NAME

SVG::Estimate::Rect - Handles estimating rectangles.

=head1 SYNOPIS

 my $rect = SVG::Estimate::Rect->new(
    transform   => $transform,
    start_point => [45,13],
    x           => 3,
    y           => 6,
    width       => 11.76,
    height      => 15.519,
 );

 my $length = $rect->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Shape>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item x

Float representing the top left corner x.

=item y

Float representing the top left corner y.

=item width

Float representing the width of the box.

=item height

Float representing the height of the box.

=back

=cut

has x => (
    is => 'ro',
);

has y => (
    is => 'ro',
);

has width => (
    is => 'ro',
);

has height => (
    is => 'ro',
);

sub BUILDARGS {
    my ($class, @args) = @_;
    ##Upgrade to hashref
    my $args = @args % 2 ? $args[0] : { @args };
    my $origin   = [ $args->{x}, $args->{y} ];
    my $opposite = [ $args->{x} + $args->{width}, $args->{y} + $args->{height} ];
    if ($args->{transform}->has_transforms) {
        $origin   = $args->{transform}->transform($origin);
        $opposite = $args->{transform}->transform($opposite);
        $args->{x} = $origin->[0] < $opposite->[0] ? $origin->[0] : $opposite->[0];
        $args->{y} = $origin->[1] < $opposite->[1] ? $origin->[1] : $opposite->[1];
        $args->{width}  = abs($opposite->[0] - $origin->[0]);
        $args->{height} = abs($opposite->[1] - $origin->[1]);
    }
    $args->{draw_start}   = $origin;
    $args->{draw_end}     = $origin;
    $args->{shape_length} = ($args->{width} + $args->{height}) * 2;
    $args->{min_x}        = $origin->[0];
    $args->{min_y}        = $origin->[1];
    $args->{max_x}        = $opposite->[0];
    $args->{max_y}        = $opposite->[1];
    return $args;
}

1;
