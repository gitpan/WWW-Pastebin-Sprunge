use strict;
use warnings;
use utf8;
use Test::More tests => 2;

my $builder = Test::More->builder;
binmode $builder->output,         ':encoding(UTF-8)';
binmode $builder->failure_output, ':encoding(UTF-8)';
binmode $builder->todo_output,    ':encoding(UTF-8)';

use WWW::Pastebin::Sprunge::Create;
use WWW::Pastebin::Sprunge::Retrieve;

my $reader = WWW::Pastebin::Sprunge::Retrieve->new();
my $writer = WWW::Pastebin::Sprunge::Create->new();

my $paste = <<'';
1: one
2: two
3: three - Testing «ταБЬℓσ»: 1<2 & 4+1>3, now 20% off!
Ævar Arnfjörð Bjarmason

SKIP: {
    my $id = $writer->paste($paste) or do {
        diag 'Got an error on ->paste(): ' . $writer->error;
        skip 'Got error', 2;
    };
    # print STDERR $id, "\n";
    my $test = $reader->retrieve($id) or do {
        diag 'Got an error on ->retrieve(): ' . $reader->error;
        skip 'Get error', 2;
    };
    is($test, "$paste\n", 'unicode survived a round-trip OK');

    my $test2 = $reader->retrieve('GGOD') or do {
        diag 'Got an error on ->retrieve(): ' . $reader->error;
        skip 1;
    };
    is($test2, $test, q{We didn't get symmetrical corruption});
}
