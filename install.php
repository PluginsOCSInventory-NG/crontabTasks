<?php

/**
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_crontabtasks()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `crontabtasks` (
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
                              ) ENGINE=INNODB;");
}

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_crontabtasks()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE `crontabtasks`");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_crontabtasks()
{

}
