package SVG::Estimate::Polygon;

use Moo;
use Image::SVG::Path qw/extract_path_info/;
use SVG::Estimate::Path::Moveto;
use SVG::Estimate::Path::Lineto;
use SVG::Estimate::Path::CubicBezier;
use SVG::Estimate::Path::Closepath;
use SVG::Estimate::Path::QuadraticBezier;
use SVG::Estimate::Path::HorizontalLineTo;
use SVG::Estimate::Path::VerticalLineTo;
use SVG::Estimate::Path::Arc;
use List::Util qw/sum/;

extends 'SVG::Estimate::Shape';

has d => ( is => 'ro', required => 1, );
has commands => ( is => 'ro', );

sub BUILDARGS {
    my ($class, @args) = @_;
    ##Upgrade to hashref
    my $args = @args % 2 ? $args[0] : { @args };

    my @path_info = extract_path_info($args->{d}, { absolute => 1, no_shortcuts=> 1, });
    my @commands = ();

    foreach my $subpath (@path_info) {
        my $command = $subpath->{type} eq 'moveto'             ? SVG::Estimate::Path::Moveto->new($subpath)
                    : $subpath->{type} eq 'line-to'            ? SVG::Estimate::Path::Lineto->new($subpath)
                    : $subpath->{type} eq 'cubic-bezier'       ? SVG::Estimate::Path::CubicBezier->new($subpath)
                    : $subpath->{type} eq 'closepath'          ? SVG::Estimate::Path::Closepath->new($subpath)
                    : $subpath->{type} eq 'quadratic-bezier'   ? SVG::Estimate::Path::QuadraticBezier->new($subpath)
                    : $subpath->{type} eq 'horizontal-line-to' ? SVG::Estimate::Path::HorizontalLineTo->new($subpath)
                    : $subpath->{type} eq 'vertical-line-to'   ? SVG::Estimate::Path::VerticalLineTo->new($subpath)
                    : $subpath->{type} eq 'arc'                ? SVG::Estimate::Path::Arc->new($subpath)
                    ;
    }

    $args->{commands} = \@commands;
    return $args;
}

sub shape_length {
    my $self = shift;
    return sum { $_->shape_length } @{ $self->commands };
}

1;
