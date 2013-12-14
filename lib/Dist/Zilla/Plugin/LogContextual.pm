use strict;
use warnings;

package Dist::Zilla::Plugin::LogContextual;
BEGIN {
  $Dist::Zilla::Plugin::LogContextual::AUTHORITY = 'cpan:KENTNL';
}
{
  $Dist::Zilla::Plugin::LogContextual::VERSION = '0.001000';
}

# ABSTRACT: Set up Log::Contextual for use with Dist::Zilla


use Moose;

BEGIN {
    with 'Dist::Zilla::Role::Plugin' => {
        -excludes => [ 'log_debug', 'log_fatal', 'log' , 'logger'],
    };
}
{
    # Because the above excludes don't even work.
    no warnings 'define';
    use Log::Contextual qw( set_logger log_debug );
}

sub bootstrap {
    my ( $self ) = @_;
    my $zilla = $self->zilla;
    my $chrome = $zilla->chrome;
    if ( not $chrome ) { 
        die "WHAT CHROME IS THIS";
    }
    set_logger $chrome->logger;
    log_debug { ["If you are reading this message, %s! -- %s", "Log::Contextual", $self ] };
}

around plugin_from_config => sub {
  my ( $orig, $plugin_class, $name, $payload, $section ) = @_;
 
  my $instance = $plugin_class->$orig( $name, $payload, $section );
 
  $instance->bootstrap;
 
  return $instance;
};



__PACKAGE__->meta->make_immutable;
no Moose;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::LogContextual - Set up Log::Contextual for use with Dist::Zilla

=head1 VERSION

version 0.001000

=head1 DESCRIPTION

Log::Contextual is a context driven Logging facility that aims to provide
cross-cutting log mechanisms.

However, the way it works means that if nobody starts an initial 'set_logger' call,
the logs may go nowhere. Or something.

I don't really understand it all fully, so I'm implementing what I know to learn it better.

=head1 TL;DR

    [LogContextual] 
    ; plugins with Log::Contextual in them should work nao

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
