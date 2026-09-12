This was a nice learning excersice to create a Mojo based CLI application without using the Mojolicious bits.

While this works, there is the limitation that one must have the domain registered with cdmon for the DNS API to work which makes all of these exercise kind of futile for now.

So far only listing domains registered to an api key and listing dns records for that key are supported.

See: https://gist.github.com/foursixnine/bcea1040442301979c10fd8c27445474

Rudimentary usage:

```
export CDMON_API_KEY=plzdonthackme
export CDMON_API_URL=https://api-domains.cdmon.services/api-domains
perl bin/cdmon-dclient records
```

This is very far from being production ready, but I hope to use the experience to do something similar for another provider (even if there's one already)
