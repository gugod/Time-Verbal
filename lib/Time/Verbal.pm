package Time::Verbal;
# ABSTRACT: Convert time distance to words.

=encoding utf8

=head1 SYNOPSIS

    use Time::Verbal;

    my $now = time;

    # Print the distance of two times in words.
    say Time::Verbal::distance($now, $now);
    #=> less the a minute

    # The second argument must not be less the the first one.
    say Time::Verbal::distance($now, $now + 4200);
    #=> about 1 hour

=head1 DESCRIPTION

Time::Verbal trys to represent time-related info as verbal text.

=cut

use strict;
use warnings;
use encoding 'utf8';
use Object::Tiny qw(locale);
use File::Spec;
use Locale::Wolowitz;

=method distance($from_time, $to_time)

Returns the distance of two timestamp in words.

The possible outputs are:

    - less than a minute
    - 1 minute
    - 3 minutes
    - about 1 hour
    - 6 hours
    - yesterday
    - 177 days
    - over a year

For time distances larger the a year, it'll always be "over a year".

The returned string is a localized string if the object is constructed with locale
parameter:

    my $tv = Time::Verbal->new(locale => "zh-TW");
    say $tv->distance(time, time + 3600);
    #=> 一小時

Internally l10n is done with L<Locale::Wolowitz>, which means the dictionary
files are just a bunch of JSON text files that you can locate with this command:

    perl -MTime::Verbal -E 'say Time::Verbal->i18n_dir'

In case you need to provide your own translation JSON files, you may specify
the value of i18n_dir pointing to your own dir:

    my $tv = Time::Verbal->new(locale => "xx", i18n_dir => "/app/awesome/i18n");

=cut

sub distance {
    my $self = shift;
    unless (ref($self)) {
        unshift(@_, $self);
        $self = __PACKAGE__->new;
    }

    my ($from_time, $to_time) = @_;

    die "The arguments should be (\$from_time, \$to_time), both are required." unless defined($from_time) && defined($to_time);

    my $delta = abs($to_time - $from_time);

    if ($delta < 30) {
        return $self->loc("less then a minute")
    }
    if ($delta < 90) {
        return $self->loc("1 minute");
    }
    if ($delta < 3600) {
        return $self->loc('%1 minutes', int(0.5+$delta / 60));
    }
    if ($delta < 5400) {
        return $self->loc("about 1 hour");
    }
    if ($delta < 86400) {
        return $self->loc('%1 hours', int(0.5+ $delta / 3600));
    }
    if ($delta > 86400 && $delta < 86400 * 2) {
        return $self->loc("one day");
    }
    if ($delta < 86400 * 365) {
        return $self->loc('%1 days', int($delta / 86400));
    }

    return $self->loc("over a year");
}

sub loc {
    my ($self, $msg, @args) = @_;
    return $self->wolowitz->loc( $msg, $self->locale || "en" , @args );
}

sub i18n_dir {
    my ($self, $dir) = @_;

    my $i18n_dir = sub {
        my @i18n_dir = (File::Spec->splitdir(__FILE__), "i18n");
        $i18n_dir[-2] =~ s/\.pm//;
        return File::Spec->catdir(@i18n_dir);
    };

    if (ref($self)) {
        if (defined($dir)) {
            $self->{i18n_dir} = $dir;
        }

        if (defined($self->{i18n_dir})) {
            return $self->{i18n_dir}
        }

        return $self->{i18n_dir} = $i18n_dir->();
    }

    return $i18n_dir->();
}

sub wolowitz {
    my ($self) = @_;
    $self->{wolowitz} ||= Locale::Wolowitz->new( $self->i18n_dir);
    return $self->{wolowitz}
}

1;
