package DNS::Cdmon::CLI::records;
use Mojo::Base 'DNS::Cdmon::Command', -signatures;
use Carp qw(confess);
use DNS::Cdmon;

# Short description
has description => 'Lists dns records for a given domain';

# Usage message from SYNOPSIS
has usage => sub ($self) { $self->extract_usage };

sub command( $self, @args ) {

    $self->app->log->trace( __PACKAGE__ . " called with args @args" );
    $self->app->records(@args);

}

1;
