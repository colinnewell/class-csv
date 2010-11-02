use inc::Module::Install;

name     'Class-CSV';
all_from 'lib/Class/CSV.pm';
author   q{David Radunz <dj@office.netspace.net.au>};
license  'perl';

requires 'Text::CSV_XS' => 0.23;
requires 'Class::Accessor' => 0.18;


build_requires 'Test::Most';

auto_install;

WriteAll;

