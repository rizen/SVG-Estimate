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

=head1 NAME

SVG::Estimate - Estimates the length of all the vectors in an SVG file.

=head1 SYNOPSIS

 my $se = SVG::Estimate->new(
    file_path   => '/path/to/file.svg',
 );

 $se->estimate; # performs all the calculations

 my $length = $se->length;


=head1 INHERITANCE

This class consumes L<SVG::Estimate::Role::Round> and L<SVG::Estimate::Role::Dpi>.

=head1 METHODS

=head2 new(properties)

Constructor.

=over

=item properties

A hash of properties for this class.

=over

=item file_path

The path to the SVG file.

=back

=back

=cut

has file_path => (
    is          => 'ro',
    required    => 1,
);

=head2 length()

Returns the length in user units (pixels) of the SVG. This is equivalent of adding C<tavel_length> and C<shape_length> together. B<NOTE:> The number of user units within any given element could be variable depending upon how the vector was specified and how the SVG editor exports its documents. For example, if you have a line that is 1 inch long in Adobe Illustrator it will export that as 72 user units, and a 1 inch line in Inkscape will export that as 90 user units. 

=cut

has length => (
    is      => 'rw',
    default => sub { 0 },
);

=head2 travel_length()

Returns the length of tool travel in user units that a toolhead would have to move to get into position for the next shape.

=cut

has travel_length => (
    is      => 'rw',
    default => sub { 0 },
);

=head2 shape_length()

Returns the length of the vectors (in user units) that make up the shapes in this document. 

=cut

has shape_length => (
    is      => 'rw',
    default => sub { 0 },
);

=head2 shape_count()

The count of all the shapes in this document.

=cut

has shape_count => (
    is      => 'rw',
    default => sub { 0 },
);

=head2 cursor()

Returns a point (an array ref with 2 values) of where the toolhead will be at the end of estimation.

=cut

has cursor => (
    is      => 'rw',
    default => sub { [0,0] },
);

=head2 min_x()

Returns the left most x value of the bounding box for this document.

=cut

has min_x => (
    is          => 'rwp',
    default     => sub { 1e10 },
);

=head2 max_x()

Returns the right most x value of the bounding box for this document.

=cut

has max_x => (
    is          => 'rwp',
    default     => sub { -1e10 },
);

=head2 min_y()

Returns the top most y value of the bounding box for this document.

=cut

has min_y => (
    is          => 'rwp',
    default     => sub { 1e10 },
);

=head2 max_y()

Returns the bottom most y value of the bounding box for this document.

=cut

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

=head2 read_svg()

Reads in the SVG document specified by C<file_path> in the constructor.

=cut

sub read_svg {
    my $self = shift;
    my $xml = read_file($self->file_path);
    my $doc = XML::LibXML->load_xml(string => $xml, load_ext_dtd => 0);
    my $hash = xml2hash($doc, order => 1); 
    return $hash;
}

=head2 estimate()

Performs all the calculations on this document. B<NOTE:> before C<estimate()> is run, none of the measurements will produce valid values.

=cut

sub estimate {
    my $self = shift;
    my $hash = $self->read_svg();
    $self->sum($hash->{svg});
    return $self;
}

=head2 sum(elements)

This is used by C<estimate> to do calculations on the various elements of the document. It recurses over a list of elements. This method is likely only useful to you if you want to evaluate only a section of a document.

=over

=item elements

An array reference of SVG elements as parsed by L<XML::Hash::LX>.

=back

=cut 

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

=head2 parse_params ( in )

Removes the C<-> added to attributes by L<XML::Hash::LX> and returns a hash with the fixed paramter names.

=over

=item in

A hash reference of parameters from L<XML::Hash::LX> with the preceeding C<-> on each key. 

=back

=cut

sub parse_params {
    my ($self, $in) = @_;
    my %out = (start_point => $self->cursor);
    foreach my $key (keys %{$in}) {
        my $newkey = substr($key, 1);
        $out{$newkey} = $in->{$key};
    }
    return %out;
}

=head1 PREREQS

L<Moo>
L<Math::Trig>
L<Image::SVG::Path>
L<Clone>
L<List::Util>
L<Ouch>
L<Test::More>
L<File::Slurp>
L<XML::LibXML>
L<XML::Hash::LX>

=head1 SUPPORT

=over

=item Repository

L<http://github.com/rizen/SVG-Estimate>

=item Bug Reports

L<http://github.com/rizen/SVG-Estimate/issues>

=back

=head1 AUTHOR

This module was created by JT Smith <jt_at_plainblack_dot_com> and Colin Kuskie <colink_at_plainblack_dot_com>.

=head1 LEGAL

SVG::Estimate is Copyright 2016 Plain Black Corporation (L<http://www.plainblack.com>) and is licensed under the same terms as Perl itself.

=cut

1;
