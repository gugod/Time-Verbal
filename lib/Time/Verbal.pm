use strict;
use warnings;
package Time::Verbal;

sub distance {
    my ($from_time, $to_time) = @_;

    unless(defined($to_time)) {
        $to_time   = $from_time;
        $from_time = time;
    }

    my $delta = $to_time - $from_time;

    die "The argument should be an non-negative number." if $delta < 0;

    if ($delta < 7) {
        return "right now"
    }
    if ($delta < 60) {
        return int($delta) . " seconds ago"
    }
    if ($delta < 120) {
        return "about 1 minute ago"
    }
    if ($delta < 3600) {
        return int($delta / 60) . " minutes ago"
    }
    if ($delta < 7200) {
        return "about 1 hour ago"
    }
    if ($delta < 86400) {
        return int($delta / 3600) . " hours ago"
    }
    if ($delta > 86400 && $delta < 86400 * 2) {
        return "yesterday"
    }
    if ($delta < 86400 * 365) {
        return int($delta / 86400) . " days ago"
    } else {
        return "over a year ago"
    }
}

1;
