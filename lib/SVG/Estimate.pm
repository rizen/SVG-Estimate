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

has transform_stack => (
    is          => 'rwp',
    default     => sub { [] },
);

sub push_transform {
    my $self = shift;
    my $stack = $self->transform_stack;
    push @{ $stack }, @_;
    $self->_set_transform_stack($stack);
    $self->clear_transform_string;
}

sub pop_transform {
    my $self = shift;
    my $stack = $self->transform_stack;
    my $element = pop @{ $stack };
    $self->_set_transform_stack($stack);
    $self->clear_transform_string;
    return $element;
}

has combined_transform_string => (
    is => 'lazy',
    predicate => 'has_transforms',
    clearer => 'clear_transform_string',
    default => sub {
        my $self = shift;
        my $cts = join ' ', map { $_ } @{ $self->transform_stack };
        $self->transform->extract_transforms($cts);
        return $cts;
    },
);

sub get_transform_string {
    my $self = shift;
}

has transform => (
    is => 'lazy',
);

sub _builder_transform {
    return Image::SVG::Transform->new();
}

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
    my $has_transform = 0; ##Flag for g/svg element having a transform
    if (ref $elements eq 'ARRAY') {
        foreach my $element (@{$elements}) {
            my @keys = keys %{$element};
            if ($keys[0] ~~ [qw(g svg)]) {
                #warn '__________'.$keys[0];
                $self->sum($element->{$keys[0]});
            }
            elsif ($keys[0] ~~ [qw(line ellipse rect circle polygon polyline path)]) {
                $shape_count++;
                my $class = 'SVG::Estimate::'.ucfirst($keys[0]);
                my %params = $self->parse_params($element->{$keys[0]});
                ##Handle transforms on an element
                if (exists $params{transform}) {
                    $self->push_transform($params{transform});
                }
                if ($self->has_transforms) {
                    $params{transform} = $self->transform;
                }
                my $shape = $class->new(%params);
                $shape_length  += $shape->shape_length;
                $travel_length += $shape->travel_length;
                $length        += $shape->length;
                $self->cursor($shape->draw_end);
                $self->_set_min_x($shape->min_x) if $shape->min_x < $self->min_x;
                $self->_set_max_x($shape->max_x) if $shape->max_x > $self->max_x;
                $self->_set_min_y($shape->min_y) if $shape->min_y < $self->min_y;
                $self->_set_max_y($shape->max_y) if $shape->max_y > $self->max_y;
                if (exists $params{transform}) {
                    $self->pop_transform;
                }
            }
            ##Handle transforms on a containing svg or g element
            else {
                if (exists $element->{'-transform'}) {
                    $self->push_transform($element->{'-transform'});
                    $has_transform = 1;
                }
            }
        }
    }
    elsif (ref $elements eq 'HASH') {
        foreach my $key (keys $elements) {
            $self->sum($elements->{$key});
        }
    }
    $self->length($self->length + $length);
    $self->shape_length($self->shape_length + $shape_length);
    $self->travel_length($self->travel_length + $travel_length);
    $self->shape_count($self->shape_count + $shape_count);
    $self->pop_transform if $has_transform;
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
