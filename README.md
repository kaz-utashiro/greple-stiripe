[![Actions Status](https://github.com/kaz-utashiro/greple-stiripe/actions/workflows/test.yml/badge.svg)](https://github.com/kaz-utashiro/greple-stiripe/actions)
# NAME

App::Greple::stripe - Greple zebra stripe module

# SYNOPSIS

    greple -Mstripe ...

# DESCRIPTION

App::Greple::stripe is a module for **greple** to show matched text
in zebra striping fashion.

The following command matches two consecutive lines.

    greple -E '(.+\n){1,2}' --face +E

<div>
    <p>
    <img width="750" src="https://raw.githubusercontent.com/kaz-utashiro/greple-stiripe/refs/heads/main/images/normal.png">
    </p>
</div>

However, each matched block is colored the same color, so it is not
clear where the block breaks.

One way is to explicitly display the blocks using the `--blockend`
option.

    greple -E '(.+\n){1,2}' --face +E --blockend=--

<div>
    <p>
    <img width="750" src="https://raw.githubusercontent.com/kaz-utashiro/greple-stiripe/refs/heads/main/images/blockend.png">
    </p>
</div>

Using the stripe module, blocks matching the same pattern are colored
with different colors of the similar color series.

<div>
    <p>
    <img width="750" src="https://raw.githubusercontent.com/kaz-utashiro/greple-stiripe/refs/heads/main/images/stripe.png">
    </p>
</div>

# AUTHOR

Kazumasa Utashiro

# LICENSE

Copyright ©︎ 2024 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
