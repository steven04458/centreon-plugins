package apps::proxmox::mg::restapi::mode::virus;

use base qw(centreon::plugins::mode);

use List::Util qw(max);

use strict;
use warnings;

sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options);
    bless $self, $class;

    $options{options}->add_options(arguments => {
    });

    return $self;
}

sub check_options {
    my ($self, %options) = @_;
    $self->SUPER::init(%options);
}

sub manage_selection {
  my ($self, %options) = @_;
  $self->{virus} = $options{custom}->api_recent_virus();
}

sub run {
  my ($self, %options) = @_;
  $self->manage_selection(%options);
  foreach my $virus_id (max(keys %{$self->{virus}})) {
      $self->{output}->output_add(
          severity => 'OK',
          short_msg =>
              "[Virus_in = '" . $self->{virus}->{$virus_id}->{Virus_in} . "']" .
              "[Virus_out = '" . $self->{virus}->{$virus_id}->{Virus_out} . "']"
      );
      $self->{output}->perfdata_add(
          label =>'Virus_in',
          value =>$self->{virus}->{$virus_id}->{Virus_in},
          unit  => 'mail',
          min   => 0
      );
      $self->{output}->perfdata_add(
          label =>'Virus_out',
          value =>$self->{virus}->{$virus_id}->{Virus_out},
          unit  => 'mail',
          min   => 0
      );
  }

  $self->{output}->display(force_long_output => 1);
  $self->{output}->exit();
}

1;

__END__

=head1 MODE

=over 8

=back

=cut
