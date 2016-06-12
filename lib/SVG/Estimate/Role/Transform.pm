package SVG::Estimate::Role::Transform;

use strict;
use Moo::Role;

=head2 transform

Pass in an L<Image::SVG::Transform> object if you want to transform all the consumer's points into a new coordinate space.

=cut

has transform => (
    is          => 'ro',
);

1;
