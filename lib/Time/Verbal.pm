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
use Object::Tiny;

sub loc {
    my ($self, $id, @args) = @_;
    my $ret = $id;
    if (scalar @args) {
        for (my $i = 1; $i <= scalar @args; $i++) {
            $ret =~ s/%$i/$args[$i-1]/g;
        }
    }
    return $ret;
}

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

=cut

sub distance {
    my $self = shift;
    unshift(@_, $self) unless ref $self;
    $self = __PACKAGE__->new;

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
        return $self->loc("yesterday");
    }
    if ($delta < 86400 * 365) {
        return $self->loc('%1 days', int($delta / 86400));
    }

    return $self->loc("over a year");
}

1;
