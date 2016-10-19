#!perl -T
use 5.006;
use strict;
use warnings;
use utf8;
use Test::More;
use Test::Exception;
use Data::MoneyCurrency qw(get_currency);
use Data::Dumper;

binmode STDOUT, ":encoding(UTF-8)";
binmode STDERR, ":encoding(UTF-8)";
binmode Test::More->builder->output, ":encoding(UTF-8)";
binmode Test::More->builder->failure_output, ":encoding(UTF-8)"; 
binmode Test::More->builder->todo_output, ":encoding(UTF-8)";

local $Data::Dumper::Sortkeys = 1;

{
    my $got = get_currency('usd');
    my $expected = {
        'alternate_symbols' => ['US$'],
        'decimal_mark' => '.',
        'disambiguate_symbol' => 'US$',
        'html_entity' => '$',
        'iso_code' => 'USD',
        'iso_numeric' => '840',
        'name' => 'United States Dollar',
        'priority' => 1,
        'smallest_denomination' => 1,
        'subunit' => 'Cent',
        'subunit_to_unit' => 100,
        'symbol' => '$',
        'symbol_first' => 1,
        'thousands_separator' => ',',
    };
    is_deeply($got, $expected, "usd")
        or diag(Data::Dumper->Dump([$got, $expected], ['got', 'expected']));
}

{
    my $got = get_currency("blablabla");
    is($got, undef, "get_currency('blablabla') returns undef");
}

throws_ok {
    get_currency();
} qr/no arguments/, "get_currency() throws exception";

throws_ok {
    get_currency("one", "two");
} qr/more than one argument/, "get_currency('one', 'two') throws exception";

done_testing();
