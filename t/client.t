use Mojo::Base -strict;
use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/lib";

use Test::More;
use Test::Mojo;
use Mojo::JSON qw(decode_json encode_json);
use Test::Cdmon::Mock::API;

my $app = Test::Cdmon::Mock::API->new;

subtest 'mock_server_can_list_domains' => sub {

    # my $t    = Test::Mojo->new('CdmonApi');
    my $t = Test::Mojo->new();
    $t->app($app);

    my $data = '{"data": { "domain": "test.com" }}';

    $t->post_ok( '/getDnsRecords', json => decode_json($data) )
      ->status_is( 200, "Can talk to server" )->json_like(
        '/data/msg' => qr/test.com/,
        'Domain is present in response'
    )->or(
        sub {
            diag explain $t->tx->res;
        }
    );
};

done_testing;
