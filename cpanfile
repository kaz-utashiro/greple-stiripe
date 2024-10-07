requires 'perl', '5.024';

requires 'List::Util', '1.56';
requires 'Hash::Util';
requires 'App::Greple', '9.15';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

