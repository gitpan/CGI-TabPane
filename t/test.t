use Test::More tests => 3;

# ------------------------

BEGIN{ use_ok('CGI::TabPane'); }

my($pane) = CGI::TabPane -> new(data => []);

ok(defined $pane, 'new() returned something');
ok($pane -> isa('CGI::TabPane'), 'new() returned an object of type CGI::TabPane');
