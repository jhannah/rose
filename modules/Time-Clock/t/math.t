#!/usr/bin/perl -w

use strict;

use Test::More 'no_plan'; #tests => 18;

use Time::Clock;

my $t = Time::Clock->new;

$t->add(seconds => 1);
is($t->as_string, '00:00:01', 'add 1 second');

$t->parse('00:00:00');
$t->add(nanoseconds => 1);
is($t->as_string, '00:00:00.000000001', 'add 1 nanosecond');

$t->parse('00:00:00');
$t->add(minutes => 1);
is($t->as_string, '00:01:00', 'add 1 minute');

$t->parse('00:00:00');
$t->add(hours => 1);
is($t->as_string, '01:00:00', 'add 1 hour');

# Unit wrap

$t->parse('00:00:00.999999999');
$t->add(nanoseconds => 1);
is($t->as_string, '00:00:01.000000000', 'add 1 nanosecond - unit wrap');

$t->parse('00:00:59');
$t->add(seconds => 1);
is($t->as_string, '00:01:00', 'add 1 second - unit wrap');

$t->parse('00:59:00');
$t->add(minutes => 1);
is($t->as_string, '01:00:00', 'add 1 minute - unit wrap');

$t->parse('23:00:00');
$t->add(hours => 1);
is($t->as_string, '00:00:00', 'add 1 hour - unit wrap');

# Bulk units

$t->parse('12:34:56.789');
$t->add(nanoseconds => 2_000_000_123);
is($t->as_string, '12:34:58.789000123', 'add 2,000,000,123 nanoseconds');

$t->parse('01:02:03');
$t->add(seconds => 3800);
is($t->as_string, '02:05:23', 'add 3,800 seconds');

$t->parse('01:02:03');
$t->add(minutes => 62);
is($t->as_string, '02:04:03', 'add 62 minutes');

$t->parse('01:02:03');
$t->add(hours => 24);
is($t->as_string, '01:02:03', 'add 24 hours');

$t->parse('01:02:03');
$t->add(hours => 25);
is($t->as_string, '02:02:03', 'add 25 hours');

# Mixed units

$t->parse('01:02:03');
$t->add(hours => 3, minutes => 2, seconds => 1, nanoseconds => 54321);
is($t->as_string, '04:04:04.000054321', 'add 03:02:01.000054321');

$t->parse('01:02:03');
$t->add(hours => 125, minutes => 161, seconds => 161, nanoseconds => 1_234_567_890);
is($t->as_string, '08:45:45.23456789', 'add 125:161:162.234567890');

# Strings

$t->parse('01:02:03');
$t->add('03:02:01.000054321');
is($t->as_string, '04:04:04.000054321', 'add 03:02:01.000054321 string');

$t->parse('01:02:03');
$t->add('125:161:162.234567890');
is($t->as_string, '08:45:45.23456789', 'add 125:161:162.234567890 string');

$t->parse('01:02:03');
$t->add('1');
is($t->as_string, '02:02:03', 'add 1 string');

$t->parse('01:02:03');
$t->add('1:2');
is($t->as_string, '02:04:03', 'add 1:2 string');

$t->parse('01:02:03');
$t->add('1:2:3');
is($t->as_string, '02:04:06', 'add 1:2:3 string');

$t->parse('01:02:03');
$t->add('1:2:3.456');
is($t->as_string, '02:04:06.456', 'add 1:2:3.456 string');

eval { $t->add('125:161:162.2345678901') };
ok($@, 'bad delta string 125:161:162.2345678901');

eval { $t->add(':161:162.2345678901') };
ok($@, 'bad delta string :161:162.2345678901');