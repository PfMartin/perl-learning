#!/usr/bin/perl
use strict;
use warnings;

use CGI;

my $CGI = new CGI();

sub main {
    print_index_page();
}

sub print_index_page {
    my $user     = $CGI->param("user");
    my $password = $CGI->param("pwd");

    print( $CGI->header() );
    print <<HTML;
<html>
    <b>Hello World!</b>
    <ul>
        <li>User: $user</li>
        <li>Password: $password</li>
    </ul>
</html>
HTML
}

main();
