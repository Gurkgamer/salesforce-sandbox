/**
 * @description       : Class that manages the insertion of log events as Log entities.
 *                      For each record received, all fields are transferred to a new record that will be inserted into the system.
 *                      Platform events only have the "After Insert" context, so the class simulates a Handler class of a Trigger Factory
 *                      but with only the two methods it can use.
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 06-03-2023
 * @last modified by  : Gurkgamer
**/
public without sharing class LogEventRegistrationHandler
{

    public static void afterinsert(List<Log__e> newList)
    {
        if(newList == null)
        {
            return;
        }

        List<LogRecord__c> logsToInsert = LogEventRegistrationUtil.createLoggingRecords(newList);

        if(! logsToInsert.isEmpty())
        {
            insert logsToInsert;
        }
    }
}