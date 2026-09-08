# Minimal Mojolicious::Commands container for cdmon dns
package DNS::Cdmon::Command;
use Mojo::Base 'Mojolicious::Commands', -signatures;
use Carp qw(confess);
use DNS::Cdmon;

# subcommand classes live under Cdmon::Command::
# Maybe this isn't even needed
has namespaces => sub { ['Cdmon::Command'] };
has message    => 'Cdmon dns crud cli client';

has app => sub {
    shift->app->( DNS::Cdmon->new );
};

sub run ( $self, @args ) {
    $self->app->log("Command started");
}

$SIG{__DIE__} = \&confess;
