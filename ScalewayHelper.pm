package ScalewayHelper;

use 5.24.0;
use warnings;

use Term::ReadKey;
use WebService::Scaleway;
use IO::File;

*STDOUT->autoflush(1);

sub get_credentials {
    my $username = 'matt.koscica@gmail.com';

    print "enter password for $username: ";
    Term::ReadKey::ReadMode('noecho');
    chomp(my $password = <STDIN>);
    Term::ReadKey::ReadMode('original');
    say "";

    return ($username, $password);
}

sub get_scaleway_helper {
    my ($username, $password) = get_credentials();
    my $scaleway = WebService::Scaleway->new($username, $password);
    return $scaleway;
}

1;
