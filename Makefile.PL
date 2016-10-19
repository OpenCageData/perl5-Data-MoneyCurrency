use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Basename qw(dirname);
use File::Spec;

my $dirname = dirname(__FILE__);
my @required_files = (
    File::Spec->catfile("ruby-money", "config", "currency_backwards_compatible.json"),
    File::Spec->catfile("ruby-money", "config", "currency_iso.json"),
    File::Spec->catfile("ruby-money", "config", "currency_non_iso.json"),
    File::Spec->catfile("ruby-money", "LICENSE"),
    File::Spec->catfile("ruby-money", "README.md"),
);
for my $file (@required_files) {
    my $path = File::Spec->catfile($dirname, $file);
    if (! -e $path) {
        die "Expected file '$path' to exist, have you checked out the submodule?";
    }
}

WriteMakefile(
    NAME             => 'Data::MoneyCurrency',
    AUTHOR           => q{David D Lowe <daviddlowe.flimm@gmail.com>},
    VERSION_FROM     => 'lib/Data/MoneyCurrency.pm',
    ABSTRACT_FROM    => 'lib/Data/MoneyCurrency.pm',
    LICENSE          => 'mit',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Data-MoneyCurrency-*' },
);
