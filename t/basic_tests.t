use Test::Most;
use FindBin;

use_ok 'Class::CSV', 'Used Class:CSV';

# test with file handle
my $tests = [
{
    fname => 'simple.csv',
    columns => [qw/name last first suffix/],
    expected => [ 
            { name => 'a', last => 'b', first => 'c', suffix => 'd' }, 
            { name => '1', last => '3', first => '2', suffix => '4' }, 
        ], 
},
{
    fname => 'blank_lines.csv',
    columns => [qw/test a b/],
    expected => [ 
            { test => '1', a => '3', b => '4' }, 
            { test => 'a', a => 'b', b => 'c' }, 
        ], 
},
{
    fname => 'uneven.csv',
    columns => [qw/third second one/],
    expected => [ 
            { third => '1', second => '2', one => '3' }, 
            { third => 'a'} , 
            { third => 'b', second => '' } , 
        ], 
},
{
    fname => 'multi-line.csv',
    columns => [qw/rabbits kangaroos koalas/],
    expected => [ 
            { rabbits => 'a', kangaroos => 'b', koalas => 'c' }, 
            { rabbits => 'a', kangaroos => "multi \nline\nvalue", koalas => 'here' }, 
            { rabbits => 'd', kangaroos => 'e', koalas => 'f' }, 
        ], 
},
];
my $todo = [
];

for my $test (@$tests)
{
    run_test($test);
}

TODO: {
    local $TODO = 'Need to implement functionality';

    for my $test (@$todo)
    {
        lives_ok { run_test($test) } 'Shouldn"t die';
    }

}

done_testing();

sub run_test
{
    my $test = shift;
    note 'Testing file ' . $test->{fname};
    my $csv = Class::CSV->parse(
            filename => "$FindBin::Bin/". $test->{fname},
            fields => $test->{columns},
            csv_xs_options => { binary => 1 },
            );
	check_results($csv, $test->{expected});
	ok open (my $fh, '<', "$FindBin::Bin/". $test->{fname}), 'Opened file for testing file handle';
    my $csv2 = Class::CSV->parse(
            filehandle => $fh,
            fields => $test->{columns},
            csv_xs_options => { binary => 1 },
            );
	check_results($csv2, $test->{expected});
	ok close $fh => 'Should be able to close handle, i.e. it shouldn\'t be closed already';
}

sub check_results
{
	my $csv = shift;
	my $expected = shift;
    ok $csv, "CSV object should be intitialized";

	is scalar @{ $csv->lines() }, scalar @$expected, 'Should have right number of lines';
	my @expectClone = @$expected;
    foreach my $line ( @{ $csv->lines() } )
    {
        my $expect = shift @expectClone;
        for my $key (keys %$expect)
        {
            eq_or_diff $line->{$key}, $expect->{$key}, 'Checking value';
        }
    }
}
