<?php
function plugin_version_crontabTasks()
{
return array('name' => 'crontabTasks',
'version' => '1.1',
'author'=> 'Guillaume PROTET, Valentin DEVILLE',
'license' => 'GPLv2',
'verMinOcs' => '2.2');
}

function plugin_init_crontabTasks()
{
$object = new plugins;
$object -> add_cd_entry("crontabtasks","config");

$object -> sql_query("CREATE TABLE IF NOT EXISTS `crontabtasks` (
                      `ID` INT(11) NOT NULL AUTO_INCREMENT,
                      `HARDWARE_ID` INT(11) NOT NULL,
                      `USER` varchar(255) DEFAULT NULL,
                      `CRON` varchar(255) DEFAULT NULL,
                      `MINUTE` varchar(3) DEFAULT NULL,
                      `HOUR` varchar(2) DEFAULT NULL,
                      `DOM` varchar(1) DEFAULT NULL,
                      `MONTH` varchar(1) DEFAULT NULL,
                      `DOW` varchar(1) DEFAULT NULL,
                      PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                      ) ENGINE=INNODB;"
);

}

function plugin_delete_crontabTasks()
{
$object = new plugins;
$object -> del_cd_entry("crontabtasks");
$object -> sql_query("DROP TABLE `crontabtasks`");

}
