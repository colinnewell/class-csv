use Test::Most;
use FindBin;

use_ok 'Class::CSV', 'Used Class:CSV';

TODO: {

	local $TODO = 'Should provide better error.';

	lives_ok { my $csv = Class::CSV->parse(
			filename => "$FindBin::Bin/". 'uneven.csv',
			fields => [qw/first second/],
			csv_xs_options => { binary => 1 },
			) } 'Should give a sensible error.';

}

done_testing();

