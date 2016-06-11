#!/usr/bin/env perl

use 5.24.0;
use warnings;

use ScalewayHelper;
use Sys::Hostname;

sub main {
    my $scaleway = ScalewayHelper->get_scaleway_helper();

    die q{couldn't extract ip from `ifconfig eth0`} unless
    my ($eth0_ip) = map { m/inet addr:([0-9.]+)/ ? $1 : () } qx{ifconfig eth0};

    my @servers = $scaleway->list_servers();

    die qq{couldn't find server with private_ip=$eth0_ip} unless
    my ($this_server) = grep { $_->{private_ip} eq $eth0_ip } @servers;

    my $current_hostname = Sys::Hostname::hostname();
    my $supposed_hostname = $this_server->{hostname};

    if ( $supposed_hostname eq $current_hostname ) {
        warn "looks like our hostname ($current_hostname) is just fine";
    }
    else {
        warn "current_hostname ($current_hostname) != supposed_hostname ($supposed_hostname)";
        my @commands = (
            [sudo => hostname => $supposed_hostname],
            [sudo => vim      => '/etc/hostname'   ],
        );
        printf q{press enter to run `%s` and `%s`}, map { join " " => @$_ } @commands;
        <STDIN>;
        foreach my $command (@commands) {
            # system @$command;
        }
    }
}

main();
