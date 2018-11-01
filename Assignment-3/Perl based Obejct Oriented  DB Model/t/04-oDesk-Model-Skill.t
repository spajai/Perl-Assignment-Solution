use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;
use Test::Exception;
use Data::Dumper;

my $expected_skill_hashref = {
          '6' => 'c',
          '11' => 'javascript',
          '3' => 'unix',
          '7' => 'c++',
          '9' => 'html',
          '12' => 'apache',
          '2' => 'mod_perl',
          '15' => 'eclipse',
          '14' => 'vi',
          '8' => 'sql',
          '1' => 'perl',
          '4' => 'java',
          '13' => 'emacs',
          '10' => 'css',
          '5' => 'php'
        };

my $skill_names_sorted_aref = [
          'apache',
          'c',
          'c++',
          'css',
          'eclipse',
          'emacs',
          'html',
          'java',
          'javascript',
          'mod_perl',
          'perl',
          'php',
          'sql',
          'unix',
          'vi'
        ];

use_ok('oDesk::DB');
use_ok('oDesk::Model::Skill');

my $db = oDesk::DB->new;

#-------------------------------------------------------------------------------

# test that constructor requires file parameter
# if the file parameter is not passed, the following string should be
# in the exception: 'Attribute (file) is required at constructor'

{
  throws_ok { oDesk::Model::Skill->new }
    qr/Attribute \(db\) is required at constructor/,
      'db is required parameter'; 
}

#-------------------------------------------------------------------------------

# test instantiation
{
  my $model = oDesk::Model::Skill->new(db => $db);
  isa_ok($model, 'oDesk::Model::Skill');

} 

#-------------------------------------------------------------------------------

{
  my $model = oDesk::Model::Skill->new(db => $db);
  isa_ok($model, 'oDesk::Model::Skill');
  
  my $href = $model->get_all_hashref;
  is_deeply($href, $expected_skill_hashref, 'get_all_hashref');
}

#-------------------------------------------------------------------------------

{
  my $model = oDesk::Model::Skill->new(db => $db);
  isa_ok($model, 'oDesk::Model::Skill');
  
  my $aref = $model->get_skill_names;
  ok(ref $aref eq 'ARRAY', 'arrayref returned in scalar context');
  is_deeply($aref, $skill_names_sorted_aref, 'contents of arrayref are correct'); 

  my @array = $model->get_skill_names;
  ok(@array == @{ $skill_names_sorted_aref }, 'array returned has correct number of elements');
  is_deeply(\@array, $skill_names_sorted_aref, 'contents of arrayref are correct'); 
}

#-------------------------------------------------------------------------------

{
  my $model = oDesk::Model::Skill->new(db => $db);
  isa_ok($model, 'oDesk::Model::Skill');

  for my $id (sort { $a <=> $b } keys %{ $expected_skill_hashref } ) {
    my $expected_name = $expected_skill_hashref->{$id};

    my $name = $model->get_name_for_id($id);

    cmp_ok($name, 'eq', $expected_name, "get_name_for_id - $id $name");

    my $found_id = $model->get_id_for_name($name);

    cmp_ok($found_id, '==', $id, "get_id_for_name - $id $name");
  }
}

#-------------------------------------------------------------------------------

done_testing();
