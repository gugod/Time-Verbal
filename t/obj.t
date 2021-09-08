#!/usr/bin/env perl
use Test2::V0;
use Time::Verbal;

my $now = time;

my $tv = Time::Verbal->new;

is $tv->distance($now, $now),      "less then a minute";
is $tv->distance($now, $now + 29), "less then a minute";
is $tv->distance($now, $now + 63), "1 minute";
is $tv->distance($now, $now + 89), "1 minute";
is $tv->distance($now, $now + 90), "2 minutes";
is $tv->distance($now, $now + 119), "2 minutes";
is $tv->distance($now, $now + 120), "2 minutes";
is $tv->distance($now, $now + 3700), "about 1 hour";
is $tv->distance($now, $now + 5400), "2 hours";
is $tv->distance($now, $now + 10800), "3 hours";
is $tv->distance($now, $now + 86405), "one day";
is $tv->distance($now, $now + 86400 * 300), "300 days";
is $tv->distance($now, $now + 86400 * 600), "over a year";
is $tv->distance($now, $now + 86400 * 1000), "over a year";
is $tv->distance($now, $now),      "less then a minute";
is $tv->distance($now, $now - 29), "less then a minute";
is $tv->distance($now, $now - 63), "1 minute";
is $tv->distance($now, $now - 3700), "about 1 hour";
is $tv->distance($now, $now - 10800), "3 hours";
is $tv->distance($now, $now - 86405), "one day";
is $tv->distance($now, $now - 86400 * 300), "300 days";
is $tv->distance($now, $now - 86400 * 600), "over a year";
is $tv->distance($now, $now - 86400 * 1000), "over a year";

done_testing;
