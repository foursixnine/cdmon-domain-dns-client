package DNS::Cdmon::Command;
use Mojo::Base 'Mojolicious::Command', -signatures;
use Carp qw(confess);
use DNS::Cdmon;

# Short description
has description => 'Lists records';

# Usage message from SYNOPSIS
has usage => sub ($self) { $self->extract_usage };

has options => undef;

sub run( $self, @args ) {
    my %options = ( quiet => 0, verbose => 0 );
    $self->app->log->trace("run() from baseclass");
    $self->app->log->trace( __PACKAGE__ . "run() from baseclass" );
    return $self->options( \%options )->command(@args);
}

1;
