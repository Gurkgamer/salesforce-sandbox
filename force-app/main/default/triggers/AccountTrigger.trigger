/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 07-03-2022
 * @last modified by  : jgallaga
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   05/04/2022   jgallaga   Initial Version
**/
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    TriggerFactory.manageTrigger(new AccountHandler());
}