package Data::MoneyCurrency;

use 5.006;
use strict;
use warnings;
use utf8;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(get_currency);

use File::ShareDir qw(dist_file);
use JSON qw(decode_json);
use Types::Serialiser;
use Carp;

=head1 NAME

Data::MoneyCurrency - Get currency information for different currencies

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Get currency information for different currencies.

    use Data::MoneyCurrency qw(get_currency);

    my $currency = get_currency('usd');
    # $currency = {
    #    # ...
    # }

=head1 EXPORT

=head1 SUBROUTINES/METHODS

=head2 get_currency

Takes one argument, and returns a reference to hash containing information
about that currency (character strings), or undef if the currency is not
recognised.

    my $currency = get_currency('usd');
    # $currency = {
    #    # ...
    # }

=cut

my $rh_currency_iso; # contains character strings

sub get_currency {
    croak "get_currency received no arguments" if @_ == 0;
    croak "get_currency received more than one argument" if @_ > 1;
    my $currency_abbreviation = lc($_[0]);

    if (! defined($rh_currency_iso)) {
        my $path = dist_file('Data-MoneyCurrency', 'currency_iso.json');
        open my $fh, "<:raw", $path or die $!;
        my $octet_contents = join "", readline($fh);
        close $fh or die $!;
        $rh_currency_iso = decode_json($octet_contents);
    }

    if (! $rh_currency_iso->{$currency_abbreviation}) {
        return;
    }

    # Shallow copy everytime deliberately, so that the caller can mutate the
    # return value if wished, without affecting rh_currency_iso
    my $rv = {};
    for my $key (keys %{ $rh_currency_iso->{$currency_abbreviation} }) {
        my $value = $rh_currency_iso->{$currency_abbreviation}{$key};
        if (JSON::is_bool($value) or Types::Serialiser::is_bool($value)) {
            $value = $value ? 1 : 0;
        }
        $rv->{$key} = $value;
    }
    return $rv;
}

=head1 AUTHOR

David D Lowe, C<< <daviddlowe.flimm at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-moneycurrency at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-MoneyCurrency>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::MoneyCurrency

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-MoneyCurrency>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Data-MoneyCurrency>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Data-MoneyCurrency>

=item * Search CPAN

L<http://search.cpan.org/dist/Data-MoneyCurrency/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This is licensed under the MIT license, and includes code from the
RubyMoney/Money module, which is also licensed under the MIT license.

=cut

1; # End of Data::MoneyCurrency
