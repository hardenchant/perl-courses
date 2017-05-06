use utf8;
package Local::Schema::Result::Relation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Schema::Result::Relation

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<relations>

=cut

__PACKAGE__->table("relations");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 friend_id

  data_type: 'integer'
  is_nullable: 0

=head2 uniq_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "friend_id",
  { data_type => "integer", is_nullable => 0 },
  "uniq_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</uniq_id>

=back

=cut

__PACKAGE__->set_primary_key("uniq_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-05-05 19:18:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qgb+twrrqjAXy4C7zB7EpA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
