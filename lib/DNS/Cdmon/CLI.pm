# Minimal Mojolicious::Commands container for cdmon dns
package DNS::Cdmon::CLI;
use Mojo::Base 'Mojolicious::Commands', -signatures;
use Mojo::Loader qw(find_modules find_packages load_class);
use Carp         qw(confess);
use DNS::Cdmon;

# subcommand classes live under Cdmon::Command::
# Maybe this isn't even needed
has namespaces => sub { ['DNS::Cdmon::CLI'] };
has message    => 'Cdmon dns crud cli client';

has app => sub {
    return DNS::Cdmon->new;
};

sub run ( $self, @args ) {
    $self->app->log->debug("Command started");
    $self->app->log->trace("With Namespace: $_") for @{ $self->namespaces };

    $self->inspect_namespace;

    return $self->SUPER::run(@args);
}

sub inspect_namespace ($self) {

    # Find all available commands
    my %all;
    for my $ns ( @{ $self->namespaces } ) {

        # $all{ substr $_, length "${ns}::" } //= $_->new->description;
        my @modules = find_modules($ns);
        $self->app->log->trace("Modules available:") if @modules;
        for my $module (@modules) {
            $self->app->log->trace("\t$module");
        }

        my @packages = find_packages($ns);
        $self->app->log->trace("Packages available:") if @packages;
        for my $package (@packages) {
            $self->app->log->trace("\t$package");
        }

        # for grep { _command($_) } find_modules($ns), find_packages($ns);
    }
}

$SIG{__DIE__} = \&confess;

1;
