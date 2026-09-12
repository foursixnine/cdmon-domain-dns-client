package DNS::Cdmon::Client;
use Mojo::Base 'Mojo::UserAgent', -signatures;
use Mojo::Log;
use Time::Seconds;

# For the MonkeyPatch hack
use Mojo::Util qw(monkey_patch);

# TODO: this is repeated code, logger must be global
has log => sub {
    my $self = shift;

    # Reduced log output outside of development mode
    my $log = Mojo::Log->new;
    return $log->level( $ENV{MOJO_LOG_LEVEL} ) if $ENV{MOJO_LOG_LEVEL};
    return $log;
};

has api_url => undef;

sub build( $self, %args ) {
    $self->log->trace("Building client @{[%args]}");
    $self->api_url( $args{api_url} );
    $self->inactivity_timeout( ONE_MINUTE * 10 );
    $self->max_redirects(3);
    $self->on(
        start => sub ( $ua, $tx ) {
            my $req     = $tx->req;
            my $headers = $req->headers;
            $headers->accept('application/json')
              unless defined $headers->accept;
            $headers->content_type('application/json')
              unless defined $headers->content_type;
            $headers->add( apikey => $args{apikey} );
        }
    );
    $self->log->trace("Client instance built");
}

# Common HTTP methods - from Mojo::UserAgent - maybe there's a better way to do this
for my $name (qw(DELETE GET HEAD OPTIONS PATCH POST PUT QUERY)) {
    monkey_patch __PACKAGE__, lc $name, sub {
        my ( $self, $cb ) = ( shift, ref $_[-1] eq 'CODE' ? pop : undef );
        my $endpoint = shift @_;
        my $target   = $self->api_url() . "/" . $endpoint;
        unshift @_, $target;
        $self->log->trace("Building client: $target\n\t @_");
        return $self->start( $self->build_tx( $name, @_ ), $cb );
    };
    monkey_patch __PACKAGE__, lc($name) . '_p', sub {
        my $self = shift;
        return $self->start_p( $self->build_tx( $name, @_ ) );
    };
}

1;
