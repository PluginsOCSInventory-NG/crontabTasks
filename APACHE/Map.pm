
 
package Apache::Ocsinventory::Plugins::CrontabTasks::Map;
 
use strict;
 
use Apache::Ocsinventory::Map;

$DATA_MAP{crontabtasks} = {
         mask => 0,
         multi => 1,
         auto => 1,
         delOnReplace => 1,
         sortBy => 'MINUTE',
         writeDiff => 0,
         cache => 0,
         fields => {
               MINUTE => {},
               HOUR => {},
               DOM => {},
               MONTH => {},
               DOW => {},
               USER => {},
               CRON => {},
         }
};
1;

