#!/usr/bin/perl

use strict;
use warnings;
use Net::Server::HTTP;
use DBD::Pg qw(:pg_types);

use base qw(Net::Server::HTTP);
__PACKAGE__->run(port => 9001);

sub process_http_request {
    my $self = shift;

    my $dbh = DBI->connect("dbi:Pg:dbname=$ARGV[0]", $ARGV[1], $ARGV[2], {AutoCommit => 1});
    my $sth = $dbh->prepare('SELECT request($1) AS response');

    $sth->bind_param(1, $ENV{'REQUEST_URI'}, {pg_type => PG_VARCHAR});
    $sth->execute();

    my $row = $sth->fetchrow_hashref();

    print $row->{'response'};

    #if (require Data::Dumper) {
    #    local $Data::Dumper::Sortkeys = 1;
    #    print "<pre>".Data::Dumper->Dump([\%ENV], ['*ENV', 'form'])."</pre>";
    #    print "<pre>".Data::Dumper->Dump([$self], ['self'])."</pre>";
    #}
}

