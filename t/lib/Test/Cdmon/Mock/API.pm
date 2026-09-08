package Test::Cdmon::Mock::API;
use Mojolicious::Lite -signatures;
use Mojo::JSON   qw(decode_json encode_json);
use Mojo::Loader qw(data_section);

my $dns_records =
  decode_json( data_section __PACKAGE__, 'getDndRecords.json.ep' );

post '/getDnsRecords' => sub ($c) {
    my $data = $c->req->json;
    $c->log->trace( "getDnsRecords data" . encode_json($data) );
    say "getDnsRecords: ", encode_json($data);

    # app->log->trace("foo - $_") for keys %{ data_section __PACKAGE__ };
    # app->log->debug($_)         for keys %{ data_section __PACKAGE__ };
    $c->render( json => $dns_records );
};

app->start;

1;

__DATA__

@@ getDndRecords.json.ep
{
    "status" : "ok",
      "data" : {
        "msg" : "DNS records for domain test.com",
        "result" : [
            {
                "type" : "TXT",
                "host" : "_dmarc",
                "ttl" : 900,
                "value" : "v=DMARC1; p=none; aspf=s; adkim=r;"
            },
            {
                "type" : "NS",
                "host" : "@",
                "ttl" : 3600,
                "value" : "ns1.cdmon.net"
            }
        ]
      }
}
