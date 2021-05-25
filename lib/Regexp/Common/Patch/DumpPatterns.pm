package Regexp::Common::Patch::DumpPatterns;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
no warnings;

use Data::Dmp;
use parent qw(Module::Patch);

our %config;

sub _wrap_pattern {
    my $ctx = shift;
    push @main::_patterns, [@_];
    &{$ctx->{orig}}(@_);
}

END {
    print "# BEGIN DUMP $config{-tag}\n";
    local $Data::Dmp::OPT_DEPARSE = 0;
    say dmp(\@main::_patterns);
    print "# END DUMP $config{-tag}\n";
}

sub patch_data {
    return {
        v => 3,
        patches => [
            {
                action      => 'wrap',
                sub_name    => 'pattern',
                code        => \&_wrap_pattern,
            },
        ],
        config => {
            -tag => {
                schema  => 'str*',
                default => 'TAG',
            },
        },
   };
}

1;
# ABSTRACT: Patch Regexp::Common's pattern() to collect the arguments it receives and dump them all at the end
