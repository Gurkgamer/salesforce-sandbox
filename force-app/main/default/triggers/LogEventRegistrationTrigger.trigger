/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 06-02-2023
 * @last modified by  : Gurkgamer
**/
trigger LogEventRegistrationTrigger on Log__e (after insert)
{
    LogEventRegistrationHandler.afterinsert(Trigger.new);
    LogEventRegistrationHandler.finalDMLAfter();
}