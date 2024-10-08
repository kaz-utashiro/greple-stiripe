requires 'perl', '5.024';

requires 'List::Util', '1.56';
requires 'Hash::Util';
requires 'Scalar::Util';
requires 'App::Greple', '9.16';
requires 'Getopt::EX', '2.2.1';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

