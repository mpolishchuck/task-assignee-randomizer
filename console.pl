#!/usr/bin/perl -CS

use utf8;
use strict;

use FindBin;
use lib "${FindBin::Bin}/local/lib/perl5";
use Array::Shuffle qw(shuffle_array);

# Hardcoded for now
my @group_sizes = (10, 9);
my $max_int = $ARGV[0];

my @groups = map { [] } @group_sizes;

# Initial sequence
{
    my @sequence = (1 .. $max_int);
    shuffle_array(@sequence);

    TOP: for (my $i = 0; $i < scalar @group_sizes; $i++) {
        for (my $j = 0; $j < $group_sizes[$i]; $j++) {
            last TOP unless (scalar @sequence);

            push @{$groups[$i]}, shift @sequence;
        }
    }
}

# Fill missings
{
    for (my $i = 0; $i < scalar @group_sizes; $i++) {
        my $current_size = scalar @{$groups[$i]};
        if ($current_size < $group_sizes[$i]) {
            my @sequence = ( map { @{$groups[$_]} } (0 .. ($i - 1)));
            shuffle_array(@sequence);

            for (my $j = $current_size; $j < $group_sizes[$i]; $j++) {
                push @{$groups[$i]}, shift @sequence;
            }
        }
    }
}

# Print result
for (my $i = 0; $i < scalar @group_sizes; $i++) {
    printf "Group %d\n", $i;
    print_group($i);
    printf "\n";
}

sub print_group {
    my $i = shift;

    print join('', map { $_ . "\n" } @{$groups[$i]});
}
