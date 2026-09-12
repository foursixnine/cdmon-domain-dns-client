package DNS::Cdmon;
use Mojo::Base -base, -signatures;
use Mojolicious::Plugins;
use Mojo::Log;
use DNS::Cdmon::Client;

# To handle data
use Mojo::JSON qw(decode_json encode_json);

has mode    => sub { $ENV{MOJO_MODE} || $ENV{PLACK_ENV} || 'development' };
has plugins => sub { Mojolicious::Plugins->new };
has client  => sub { DNS::Cdmon::Client->new };
has api_url => sub {
    $ENV{CDMON_API_URL}
      || 'https://private-31a292-domainsapi1.apiary-mock.com'
      || die "CDMON_API_SERVER must be set";
};
has apikey => sub { $ENV{CDMON_API_KEY} || die "CDMON_API_KEY must be set" };

# TODO: this is repeated code, logger must be global
has log => sub {
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
    $self->client->build( apikey => $self->apikey, api_url => $self->api_url );
    return $self;
}

sub records( $self, @args ) {
    $self->log->trace( __PACKAGE__ . "records() called with args @args" );
    my $data = { data => { domain => 'foursixnine.dev' } };
    my $txn  = $self->client->post( 'getDnsRecords', json => $data );
    $self->log->debug( encode_json( $txn->result->json ) );
    $self->log->trace( __PACKAGE__ . "records() finished" );
    return 0;
}

sub domains( $self, @args ) {
    my $data = { data => { extended_info => 1 } };
    $self->log->trace( __PACKAGE__ . "domains() called with args @args" );
    my $txn = $self->client->post( 'domains/list', json => $data );
    $self->log->trace( encode_json( $txn->result->json ) );
    $self->log->trace( __PACKAGE__ . "domains() finished" );
    return 0;
}

#
# sub list( $self, @args ) {
#     # perl-lsp bug: 'log' is not defined in DNS::Cdmon
#     $self->log->trace( __PACKAGE__ . "list() called with args @args" );
#     # perl-lsp bug: 'client' is not defined in DNS::Cdmon
#     my $txn = $self->client->get('getDnsRecords');
#     say sprintf "url =>  %s", $txn->req->url->to_abs;
#     $self->log->debug( encode_json( $txn->result->json ) );
#
#     # perl-lsp bug: $res is undefined
#     $self->log->debug( Dumper( { res => $res } ) );
#     $self->log->trace( __PACKAGE__ . "list() finished" );
#     return 0;
# }

1;
