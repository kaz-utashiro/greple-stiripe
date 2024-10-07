package App::Greple::stripe;

use 5.024;
use warnings;

our $VERSION = "0.01";

=encoding utf-8

=head1 NAME

App::Greple::stripe - Greple zebra stripe module

=head1 SYNOPSIS

    greple -Mstripe ...

=head1 DESCRIPTION

App::Greple::stripe is a module for B<greple> to show matched text
in zebra striping fashion.

The following command matches two consecutive lines.

    greple -E '(.+\n){1,2}' --face +E

=for html <p>
<img width="750" src="https://raw.githubusercontent.com/kaz-utashiro/greple-stiripe/refs/heads/main/images/normal.png">
</p>

However, each matched block is colored by the same color, so it is not
clear where the block breaks.  One way is to explicitly display the
blocks using the C<--blockend> option.

    greple -E '(.+\n){1,2}' --face +E --blockend=--

=for html <p>
<img width="750" src="https://raw.githubusercontent.com/kaz-utashiro/greple-stiripe/refs/heads/main/images/blockend.png">
</p>

Using the stripe module, blocks matching the same pattern are colored
with different colors of the similar color series.

    greple -Mstripe -E '(.+\n){1,2}' --face +E

=for html <p>
<img width="750" src="https://raw.githubusercontent.com/kaz-utashiro/greple-stiripe/refs/heads/main/images/stripe.png">
</p>

By default, two color series are prepared. Thus, when multiple
patterns are searched, an even-numbered pattern and an odd-numbered
pattern are assigned different color series.  When multiple patterns
are specified, only lines matching all patterns will be output, so the
C<--need=1> option is required to relax this condition.

    greple -Mstripe -E '.*[02468]$' -E '.*[13579]$' --need=1

=for html <p>
<img width="750" src="https://raw.githubusercontent.com/kaz-utashiro/greple-stiripe/refs/heads/main/images/random.png">
</p>

If you want to use three series with three patterns, specify C<step>
when calling the module.

    greple -Mstripe::set=step=3 --need=1 -E p1 -E p2 -E p3 ...

=for html <p>
<img width="750" src="https://raw.githubusercontent.com/kaz-utashiro/greple-stiripe/refs/heads/main/images/step-3.png">
</p>

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright ©︎ 2024 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use List::Util qw(max);
use Hash::Util qw(lock_keys);

our %opt = (
    debug => \(our $debug = 0),
    step  => \(our $step = 2),
);
lock_keys %opt;
sub opt :lvalue { ${$opt{+shift}} }

my @series = (
    [ qw(/544 /533) ],
    [ qw(/454 /353) ],
    [ qw(/445 /335) ],
    [ qw(/554 /553) ],
    [ qw(/545 /535) ],
    [ qw(/554 /553) ],
);

sub finalize {
    our($mod, $argv) = @_;
    my @default = qw(--stripe-postgrep);
    for my $i (0, 1) {
	for my $s (0 .. $step - 1) {
	    push @default, "--cm", $series[$s % @series]->[$i];
	}
    }
    $mod->setopt(default => join(' ', @default));
}

#
# Increment each index by $step
#
sub stripe {
    my $grep = shift;
    if ($step == 0) {
	$step = _max_index($grep) + 1;
    }
    my @counter = (-$step .. -1);
    for my $r ($grep->result) {
	my($b, @match) = @$r;
	for my $m (@match) {
	    my $mod = $m->[2] % $step;
	    $m->[2] = ($counter[$mod] += $step);
	}
    }
}

sub _max_index {
    my $grep = shift;
    my $max = 0;
    for my $r ($grep->result) {
	my($b, @match) = @$r;
	$max = max($max, map($_->[2], @match));
    }
}

sub set {
    while (my($key, $val) = splice @_, 0, 2) {
	next if $key eq &::FILELABEL;
	die "$key: Invalid option.\n" if not exists $opt{$key};
	opt($key) = $val;
    }
}

1;

__DATA__

builtin stripe-debug! $debug

option --stripe-postgrep \
	 --postgrep &__PACKAGE__::stripe
