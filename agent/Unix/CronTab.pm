###############################################################################
## OCSINVENTORY-NG
## Copyleft Guillaume PROTET 2010
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################

package Ocsinventory::Agent::Modules::CronTab;

use File::Find;

sub new {

   my $name="crontab";   # Name of the module

   my (undef,$context) = @_;
   my $self = {};

   #Create a special logger for the module
   $self->{logger} = new Ocsinventory::Logger ({
            config => $context->{config}
   });

   $self->{logger}->{header}="[$name]";

   $self->{context}=$context;

   $self->{structure}= {
                        name => $name,
                        start_handler => $name."_start_handler",    #or undef if don't use this hook
                        prolog_writer => undef,    #or undef if don't use this hook
                        prolog_reader => undef,    #or undef if don't use this hook
                        inventory_handler => $name."_inventory_handler",    #or undef if don't use this hook
                        end_handler => undef    #or undef if don't use this hook
   };

   bless $self;
}

######### Hook methods ############
sub crontab_start_handler {
   my $self = shift;
   my $logger = $self->{logger};
   my $common = $self->{context}->{common};

   $logger->debug("Calling crontab_start_handler");

   #If we cannot load prerequisite, we disable the module
   unless ($common->can_load('Config::Crontab')){
        $self->{disabled} = 1; # Module is disabled
        $logger->error("Config::Crontab perl module is missing !!");
        $logger->error("Humm my prerequisites are not OK... Disabling module :( :(");
   }
}

sub crontab_inventory_handler {         #Use this hook to add or modify entries in the inventory XML
   my $self = shift;
   my $logger = $self->{logger};

   my $common = $self->{context}->{common};

   #I add the treatments for my new killer feature
   $logger->debug("Yeah you are in crontab_inventory_handler :)");

   #I am a killer, I get the crontabs....
   $self->{ct} = Config::Crontab->new;
   find({wanted => sub { wanted($self); } }, '/etc/','/var/spool/');

}

sub wanted {
    my $self = shift;
    my $common = $self->{context}->{common};
    my $ct = $self->{ct};

    my @events;
    my $read;
    my $user;
    my $command;
    my $hour;
    my $minute;
    my $dayofmonth;
    my $month;
    my $dayofweek;

    return unless -f;
    if ($File::Find::name =~ /cron/ && !($File::Find::name =~ m/init\.d/) && !($File::Find::name =~ m/systemd/) && !($File::Find::name =~ m/sysconfig/) && !($File::Find::name =~ m/omc/) && !($File::Find::name =~ m/pam\.d/)) {
        my $fic = $File::Find::name;

        if ($fic =~ /\/var\/spool\/cron\/(.*)/) {
            # Crontab file user type
            $user = $1;
            $user = $1 if ($user =~ /^crontabs\/(.*)/);
            $ct->system(0);
        } else { 
            $ct->system(1); 
        }

        # read the crontab file
        $ct->read(-file => $fic);

        # Select event from crontab
        @events=$ct->select( -type => 'event');

        # Each event is read and analyzed
        for (@events) {
            $user = $_->{_user} unless defined($user);
            $command = $_->{_command};
            $hour = $_->{_hour};
            $minute = $_->{_minute};
            $dayofmonth = $_->{_dom};
            $dayofweek = $_->{_dow};
            $month = $_->{_month};
            push @{$common->{xmltags}->{CRONTAB}},
            {
               MINUTE => [$minute],
               HOUR => [$hour],
               DOM => [$dayofmonth],
               MONTH => [$month],
               DOW => [$dayofweek],
               USER => [$user],
               CRON => [$command],
            };
        }
    }
}

1;
