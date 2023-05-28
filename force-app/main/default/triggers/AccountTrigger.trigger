/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 05-29-2023
 * @last modified by  : Gurkgamer
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   05/04/2022   Gurkgamer   Initial Version
**/
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete)
{
    TriggerFactory.manageTrigger(new AccountTriggerHandler());
}