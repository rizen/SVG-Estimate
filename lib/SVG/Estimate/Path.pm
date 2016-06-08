package SVG::Estimate::Polygon;

use Moo;
use Image::SVG::Path qw/extract_path_info/;
use SVG::Estimate::Path::Moveto;
use SVG::Estimate::Path::Lineto;
use SVG::Estimate::Path::CubicBezier;
use SVG::Estimate::Path::QuadraticBezier;
use SVG::Estimate::Path::HorizontalLineTo;
use SVG::Estimate::Path::VerticalLineTo;
use SVG::Estimate::Path::Arc;
use List::Util qw/sum/;
use Clone qw/clone/;

extends 'SVG::Estimate::Shape';

has d => ( is => 'ro', required => 1, );
has commands => ( is => 'ro', );

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
        $subpath->{start_point} = clone $cursor;
        my $command = $subpath->{type} eq 'moveto'             ? SVG::Estimate::Path::Moveto->new($subpath)
                    : $subpath->{type} eq 'line-to'            ? SVG::Estimate::Path::Lineto->new($subpath)
                    : $subpath->{type} eq 'cubic-bezier'       ? SVG::Estimate::Path::CubicBezier->new($subpath)
                    : $subpath->{type} eq 'quadratic-bezier'   ? SVG::Estimate::Path::QuadraticBezier->new($subpath)
                    : $subpath->{type} eq 'horizontal-line-to' ? SVG::Estimate::Path::HorizontalLineTo->new($subpath)
                    : $subpath->{type} eq 'vertical-line-to'   ? SVG::Estimate::Path::VerticalLineTo->new($subpath)
                    : $subpath->{type} eq 'arc'                ? SVG::Estimate::Path::Arc->new($subpath)
                    : $subpath->{type} eq 'closepath'          ? '' #See below
                    : '' ;  ##Something bad happened
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
    my $length = sum map { $_->length()+0 } @{ $self->commands };
    return $length;
}

1;
