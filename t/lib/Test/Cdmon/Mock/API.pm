package Test::Cdmon::Mock::API;
use Mojolicious::Lite -signatures;
use Mojo::JSON qw(decode_json encode_json);

post '/getDnsRecords' => sub ($c) {
    my $data = $c->req->json;
    $c->log->trace( "getDnsRecords:" . encode_json($data) );
    say "getDnsRecords: ", encode_json($data);
    $c->render( json => $data );
};

app->start;

1;
