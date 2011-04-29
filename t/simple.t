#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Test::More;
use Test::Exception;
use Time::Verbal;

my $now = time;

ok Time::Verbal::distance($now, $now),      "just now";
ok Time::Verbal::distance($now, $now + 1),  "just now";
ok Time::Verbal::distance($now, $now + 63), "about 1 minute ago";

ok Time::Verbal::distance($now),      "just now";
ok Time::Verbal::distance($now + 1),  "just now";
ok Time::Verbal::distance($now + 6),  "just now";
ok Time::Verbal::distance($now + 7),  "7 seconds ago";
ok Time::Verbal::distance($now + 63), "about 1 minute ago";
ok Time::Verbal::distance($now + 3700), "about 1 hour ago";
ok Time::Verbal::distance($now + 10800), "about 3 hours ago";
ok Time::Verbal::distance($now + 86405), "yesterday";
ok Time::Verbal::distance($now + 86400 * 300), "300 days ago";
ok Time::Verbal::distance($now + 86400 * 600), "over a year ago";
ok Time::Verbal::distance($now + 86400 * 1000), "over a year ago";

dies_ok {
    Time::Verbal::distance($now - 63)
} "The argument should be an non-negative number.";

done_testing;
