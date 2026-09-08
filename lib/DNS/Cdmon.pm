package DNS::Cdmon;
use Mojo::Base -base, -signatures;
use Mojo::Log;

has mode => sub { $ENV{MOJO_MODE} || $ENV{PLACK_ENV} || 'development' };
has log  => sub {
    my $self = shift;

    # Reduced log output outside of development mode
    my $log = Mojo::Log->new;
    return $log->level( $ENV{MOJO_LOG_LEVEL} ) if $ENV{MOJO_LOG_LEVEL};
    return $self->mode eq 'development' ? $log : $log->level('info');
};

sub startup($self) {
    $self->log->trace("Booting up...");
    return $self;
}

sub new {
    my $self = shift->SUPER::new( ( ref $_[0] ? %{ shift() } : @_ ) );
    $self->startup;
    return $self;
}

1;
