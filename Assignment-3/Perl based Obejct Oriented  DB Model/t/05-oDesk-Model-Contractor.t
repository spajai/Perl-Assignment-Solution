use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;
use Test::Exception;
use Data::Dumper;

use_ok('oDesk::DB');
use_ok('oDesk::Model::Skill');
use_ok('oDesk::Model::Country');
use_ok('oDesk::Model::Contractor');

my $db = oDesk::DB->new;

#-------------------------------------------------------------------------------

# test that constructor requires file parameter
# if the file parameter is not passed, the following string should be
# in the exception: 'Attribute (file) is required at constructor'

{
  throws_ok { oDesk::Model::Contractor->new }
    qr/Attribute \(db\) is required at constructor/,
      'db is required parameter'; 
}

#-------------------------------------------------------------------------------

# test instantiation
{
  my $model = oDesk::Model::Contractor->new(db => $db);
  isa_ok($model, 'oDesk::Model::Contractor');

} 

#-------------------------------------------------------------------------------

{
  my $model = oDesk::Model::Contractor->new(db => $db);
  isa_ok($model, 'oDesk::Model::Contractor');

  my $country = oDesk::Model::Country->new(db => $db);
  isa_ok($country, 'oDesk::Model::Country');

  my $country_id = $country->get_id_for_name('Thailand');

  my %contractor = (
    first_name  => 'John',
    last_name   => 'Smith',
    hourly_rate => '20.22',
    country_id  => $country_id,
  ); 

  # Test create method
  my $contractor_id = $model->create(%contractor);

  cmp_ok($model->id,          'eq', $contractor_id,           'create - id');
  cmp_ok($model->first_name,  'eq', $contractor{first_name},  'create - first_name');
  cmp_ok($model->last_name,   'eq', $contractor{last_name},   'create - last_name');
  cmp_ok($model->hourly_rate, '==', $contractor{hourly_rate}, 'create - hourly_rate');
  cmp_ok($model->country_id,  'eq', $contractor{country_id},  'create - country_id');

  # Test load method
  my $model2 = oDesk::Model::Contractor->new(db => $db);
  $model2->load($contractor_id);

  cmp_ok($model->id,          'eq', $model2->id,          'load - id');
  cmp_ok($model->first_name,  'eq', $model2->first_name,  'load - first_name');
  cmp_ok($model->last_name,   'eq', $model2->last_name,   'load - last_name');
  cmp_ok($model->hourly_rate, '==', $model2->hourly_rate, 'load - hourly_rate');
  cmp_ok($model->country_id,  'eq', $model2->country_id,  'load - country_id');

  # Test update method
  $model->first_name('Rick');
  $model->last_name('James');
  $model->hourly_rate('19.99');
  $country_id = $country->get_id_for_name('United States');
  $model->country_id($country_id);
  $model->update;

  my $model3 = oDesk::Model::Contractor->new(db => $db);
  $model3->load($contractor_id);

  cmp_ok($model->id,          'eq', $model3->id,          'load - id');
  cmp_ok($model->first_name,  'eq', $model3->first_name,  'load - first_name');
  cmp_ok($model->last_name,   'eq', $model3->last_name,   'load - last_name');
  cmp_ok($model->hourly_rate, '==', $model3->hourly_rate, 'load - hourly_rate');
  cmp_ok($model->country_id,  'eq', $model3->country_id,  'load - country_id');

  # Test delete
  $model->delete($contractor_id);

  # there should be zero contractor records
  my @all = $model->get_all;
  ok(@all == 0, 'delete');

}

#-------------------------------------------------------------------------------

{
  my $model = oDesk::Model::Contractor->new(db => $db);
  isa_ok($model, 'oDesk::Model::Contractor');

  my $country = oDesk::Model::Country->new(db => $db);
  isa_ok($country, 'oDesk::Model::Country');

  my $country_id = $country->get_id_for_name('Thailand');

  my %contractor = (
    first_name  => 'John',
    last_name   => 'Smith',
    hourly_rate => '20.22',
    country_id  => $country_id,
  ); 

  # Test create method
  my $contractor_id = $model->create(%contractor);

  my $skill_model = oDesk::Model::Skill->new(db => $db);
  my @skills = qw(perl mod_perl unix java php apache vi html);
  my @skill_ids_to_add = map { $skill_model->get_id_for_name($_) } @skills;
  
  for my $skill_id (@skill_ids_to_add) {
    $model->add_skill($skill_id);
  }

  my @skill_ids = $model->get_skills;

  is_deeply([sort @skill_ids], [sort @skill_ids_to_add], 'add_skill and get_skills');

  for my $skill_id ( @skill_ids ) {
    $model->delete_skill($skill_id);
  }

  my @got_skills = $model->get_skills;

  ok(@got_skills == 0, 'delete_skill');

  # delete contractor
  $model->delete($contractor_id);

  # there should be zero contractor records
  my @all = $model->get_all;
  ok(@all == 0, 'delete');
}

#-------------------------------------------------------------------------------

{
  # create first contractor
  my $model = oDesk::Model::Contractor->new(db => $db);
  isa_ok($model, 'oDesk::Model::Contractor');

  my $country = oDesk::Model::Country->new(db => $db);
  isa_ok($country, 'oDesk::Model::Country');

  my %contractor1 = (
    first_name  => 'John',
    last_name   => 'Nitiya',
    hourly_rate => '21.56',
    country_id  => $country->get_id_for_name('Thailand'),
  ); 

  my %contractor2 = (
    first_name  => 'Sara',
    last_name   => 'Schwarz',
    hourly_rate => '30.25',
    country_id  => $country->get_id_for_name('Germany'),
  ); 

  # create contractors
  my $contractor1_id = $model->create(%contractor1);
  my $contractor2_id = $model->create(%contractor2);

  my $c1 = oDesk::Model::Contractor->new(db => $db);
  $c1->load($contractor1_id);
  my $c2 = oDesk::Model::Contractor->new(db => $db);
  $c2->load($contractor2_id);

  # Test get_all method
  my @expected_all;
  push @expected_all, $c1;
  push @expected_all, $c2;

  my @all = $model->get_all;
  # is_deeply(\@all, \@expected_all, 'get_all');

  my @c1_skills = qw(perl mod_perl unix php apache vi html);
  my @c2_skills = qw(perl mod_perl unix java apache emacs html);
  # the common elements in c1_skills and c2_skills
  my @expected_common = qw(perl mod_perl unix apache html);

  my $skill_model = oDesk::Model::Skill->new(db => $db);
  my @skills = qw(perl mod_perl unix java php apache vi html);
  my @skill_ids_to_add = map { $skill_model->get_id_for_name($_) } @skills;
  
  # add skills for first contractor
  for my $skill_name (@c1_skills) {
    my $skill_id = $skill_model->get_id_for_name($skill_name);
    $c1->add_skill($skill_id);
  }

  # add skills for second contractor
  for my $skill_name (@c2_skills) {
    my $skill_id = $skill_model->get_id_for_name($skill_name);
    $c2->add_skill($skill_id);
  }

  # should return an array of skill_ids that are common to $c1 and $c2
  my @common_skill_ids = $model->get_common_skills($c1, $c2);

  # convert to names
  my @common_skill_names = map { $skill_model->get_name_for_id($_) } @common_skill_ids;

  is_deeply([sort @common_skill_names], [sort @expected_common], 'get_common_skills');

  # delete contractor
  $model->delete($c1->id);
  $model->delete($c2->id);

  # there should be zero contractor records
  @all = $model->get_all;
  ok(@all == 0, 'delete');

}

done_testing();
