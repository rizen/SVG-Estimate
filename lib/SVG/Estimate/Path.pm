package SVG::Estimate::Path;

use Moo;
use Image::SVG::Path qw/extract_path_info/;
use SVG::Estimate::Path::Moveto;
use SVG::Estimate::Path::Lineto;
use SVG::Estimate::Path::CubicBezier;
use SVG::Estimate::Path::QuadraticBezier;
use SVG::Estimate::Path::HorizontalLineto;
use SVG::Estimate::Path::VerticalLineto;
use SVG::Estimate::Path::Arc;
use List::Util qw/sum/;
use Clone qw/clone/;
use Carp qw/croak/;

extends 'SVG::Estimate::Shape';

=head1 NAME

SVG::Estimate::Circle - Handles estimating circles.

=head1 SYNOPIS

 my $circle = SVG::Estimate::Circle->new(
    start_point => [45,13],
    cx          => 1,
    cy          => 3,
    r           => 1,
 );

 my $length = $circle->length;

=head1 INHERITANCE

This class extends L<SVG::Estimate::Shape>.

=head1 METHODS

=head2 new()

Constructor.

=over

=item cx

Float representing center x.

=item cy

Float representing center y.

=item r

Float representing the radius.

=back

=cut
has d => ( is => 'ro', required => 1, );
has commands => ( is => 'ro', );
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


sub BUILDARGS {
    my ($class, @args) = @_;
    ##Upgrade to hashref
    my $args = @args % 2 ? $args[0] : { @args };

    my @path_info = extract_path_info($args->{d}, { absolute => 1, no_shortcuts=> 1, });
    my @commands = ();

    my $first_flag = 1;
    my $first;
    my $cursor  = [0, 0];  ##Updated after every command
    foreach my $subpath (@path_info) {
        ##On the first command, set the start point to the moveto destination, otherwise the travel length gets counted twice.
        $subpath->{start_point} = clone $cursor;
        my $command = $subpath->{type} eq 'moveto'             ? SVG::Estimate::Path::Moveto->new($subpath)
                    : $subpath->{type} eq 'line-to'            ? SVG::Estimate::Path::Lineto->new($subpath)
                    : $subpath->{type} eq 'cubic-bezier'       ? SVG::Estimate::Path::CubicBezier->new($subpath)
                    : $subpath->{type} eq 'quadratic-bezier'   ? SVG::Estimate::Path::QuadraticBezier->new($subpath)
                    : $subpath->{type} eq 'horizontal-line-to' ? SVG::Estimate::Path::HorizontalLineto->new($subpath)
                    : $subpath->{type} eq 'vertical-line-to'   ? SVG::Estimate::Path::VerticalLineto->new($subpath)
                    : $subpath->{type} eq 'arc'                ? SVG::Estimate::Path::Arc->new($subpath)
                    : $subpath->{type} eq 'closepath'          ? '' #Placeholder so we don't fall through
                    : croak "Unknown subpath type ".$subpath->{type}."\n" ;  ##Something bad happened
        if ($subpath->{type} eq 'closepath') {
            $subpath->{point} = clone $first->point;
            $command = SVG::Estimate::Path::Lineto->new($subpath);
        }
        $cursor = clone $command->end_point;
        if ($first_flag) {
            $first_flag = 0;
            $first = $command; ##According to SVG, this will be a Moveto.
        }
        push @commands, $command;
    }

    $args->{commands} = \@commands;
    return $args;
}

sub shape_length {
    my $self = shift;
    my $length = 0;
    foreach my $command ( @{ $self->commands } ) {
        $length += $command->length;
        $self->_set_min_x( $command->min_x ) if $command->min_x < $self->min_x;
        $self->_set_max_x( $command->max_x ) if $command->max_x > $self->max_x;
        $self->_set_min_y( $command->min_y ) if $command->min_y < $self->min_y;
        $self->_set_max_y( $command->max_y ) if $command->max_y > $self->max_y;
    }
    return $length;
}

sub travel_length {
    return 0;
}

sub draw_start {
    my $self = shift;
    return $self->commands->[0]->point;
}

1;
