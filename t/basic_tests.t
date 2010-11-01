use Test::More;
require File::Temp;

use_ok 'Class::CSV', 'Used Class:CSV';

# test with file handle
my @expected = ( { name => 'a', last => 'b', first => 'c', suffix => 'd'} , 
                { name => '1', last => '3', first => '2', suffix => '4'} ); 
{
    my $file = create_temp_file("a,b,c,d\n1,3,2,4");
    $columns = [qw/name last first suffix/];
    my $csv = Class::CSV->parse(
            filename => $file->filename,
            fields => $columns,
            );
    ok $csv, "CSV object should be intitialized";

    foreach my $line ( @{ $csv->lines() } )
    {
        my $expect = shift @expected;
        for my $key (keys %$expect)
        {
            is $line->{$key}, $expect->{$key}, 'Checking value';
        }
    }
}
# uneven columns

# test with filename

# test blank lines
# TODO: test multi-line values.

done_testing();

sub create_temp_file
{
    my $contents = shift;
    my $fh = File::Temp->new();
    print $fh $contents;
    close $fh;
    return $fh;
}

