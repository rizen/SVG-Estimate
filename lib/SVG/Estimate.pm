use strict;
use warnings;
package SVG::Estimate;
use XML::Hash::LX;
use XML::LibXML;
use File::Slurp;
use Moo;
use SVG::Estimate::Line;
use SVG::Estimate::Rect;
use SVG::Estimate::Circle;
use SVG::Estimate::Ellipse;
use SVG::Estimate::Polyline;
use SVG::Estimate::Polygon;
use SVG::Estimate::Path;

with 'SVG::Estimate::Role::Round';
with 'SVG::Estimate::Role::Dpi';

has file_path => (
    is          => 'ro',
    required    => 1,
);

has length => (
    is      => 'rw',
    default => sub { 0 },
);

has travel_length => (
    is      => 'rw',
    default => sub { 0 },
);

has shape_length => (
    is      => 'rw',
    default => sub { 0 },
);

has shape_count => (
    is      => 'rw',
    default => sub { 0 },
);

has cursor => (
    is      => 'rw',
    default => sub { [0,0] },
);

sub read_svg {
    my $self = shift;
    my $xml = read_file($self->file_path);
    my $doc = XML::LibXML->load_xml(string => $xml, load_ext_dtd => 0);
    my $hash = xml2hash($doc, order => 1); 
    return $hash;
}

sub estimate {
    my $self = shift;
    my $hash = $self->read_svg();
    $self->sum($hash->{svg});
    return $self;
}

sub sum {
    my ($self, $elements) = @_;
    my $length = 0;
    my $shape_length = 0;
    my $travel_length = 0;
    my $shape_count = 0;
    foreach my $element (@{$elements}) {
        my @keys = keys %{$element};
        if ($keys[0] ~~ [qw(g svg)]) {
            $self->sum($element->{$keys[0]});
        }
        elsif ($keys[0] ~~ [qw(line ellipse rect circle polygon polyline path)]) {
            $shape_count++;
            my $class = 'SVG::Estimate::'.ucfirst($keys[0]);
            my $shape = $class->new($self->parse_params($element->{$keys[0]}));
            $shape_length  += $shape->shape_length;
            $travel_length += $shape->travel_length;
            $length        += $shape->length;
            $self->cursor($shape->draw_end);
        }
    }
    $self->length($self->length + $length);
    $self->shape_length($self->shape_length + $shape_length);
    $self->travel_length($self->travel_length + $travel_length);
    $self->shape_count($self->shape_count + $shape_count);
}

sub parse_params {
    my ($self, $in) = @_;
    my %out = (start_point => $self->cursor);
    foreach my $key (keys %{$in}) {
        my $newkey = substr($key, 1);
        $out{$newkey} = $in->{$key};
    }
    return %out;
}

1;
