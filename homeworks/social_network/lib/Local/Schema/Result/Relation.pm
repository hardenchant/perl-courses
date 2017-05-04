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

=head2 id_users

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 friend_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "id_users",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "friend_id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 id_user

Type: belongs_to

Related object: L<Local::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "id_user",
  "Local::Schema::Result::User",
  { id => "id_users" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-05-03 11:50:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Hz5tqbIrWZ91u27BdzWRrQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
