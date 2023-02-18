/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 07-05-2022
 * @last modified by  : jgallaga
**/
public with sharing class TriggerFactory
{
    public static void manageTrigger(ITriggerHandler handlerClass)
    {
        if(handlerClass == null)
        {
            throw new TriggerFactoryException('Can not manage a null class handler');
        }

        String className = String.valueOf(handlerClass).split(':').get(0);

        if(isHandlerEnabled(className))
        {
            execute(handlerClass);
        }
    }

    private static void execute(ITriggerHandler handler)
    {
        switch on Trigger.operationType
        {
            when BEFORE_INSERT
            {
                handler.beforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE
            {
                handler.beforeUpdate(Trigger.new, Trigger.oldMap);
            }
            when BEFORE_DELETE
            {
                handler.beforeDelete(Trigger.old);
            }
            when AFTER_INSERT
            {
                handler.afterInsert(Trigger.new);
            }
            when AFTER_UPDATE
            {
                handler.afterUpdate(Trigger.new,Trigger.oldMap);
            }
            when AFTER_DELETE
            {
                handler.afterDelete(Trigger.old);
            }
        }

        if(Trigger.isBefore)
        {
            handler.finalDMLBefore();
        }
        else
        {
            handler.finalDMLAfter();
        }
    }

    private static boolean isHandlerEnabled(String className)
    {
        TriggerSetup__mdt handlerConfig = TriggerSetup__mdt.getInstance(className);

        if(handlerConfig == null)
        {
            throw new TriggerFactoryException('There is no configuration for this handler ' + className);
        }

        return handlerConfig.Enabled__c;

    }

    public class TriggerFactoryException extends Exception{}
}
