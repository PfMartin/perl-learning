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

    my $query = $CGI->param("query");

    my @query = $CGI->param();
    @query = map( sprintf( "$_: %s", $CGI->param($_) ), @query );

    my $params = join( ', ', @query );

    print( $CGI->header() );
    print <<HTML;
<html>
    <b>Hello World!</b>
    <h2>URL parameters</h2>
    <ul>
        <li>User: $user</li>
        <li>Password: $password</li>
    </ul>
    
    <h2>Basic form</h2>
    <form action="index.pl" method="post">
        <input type="text" name="query"/>
        <input type="hidden" name="go" value="true" />
        <input type="submit" name="submit" value="Go" />
    </form>

    <p>Last submitted: $params</p>
</html>
HTML
}

main();
