/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 07-03-2022
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
                handler.bulkBeforeInsert(Trigger.new);
                handler.beforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE
            {
                handler.bulkBeforeUpdate(Trigger.new, Trigger.oldMap);
                handler.beforeUpdate(Trigger.new, Trigger.oldMap);
            }
            when BEFORE_DELETE
            {
                handler.bulkBeforeDelete(Trigger.old);
                handler.beforeDelete(Trigger.old);
            }
            when AFTER_INSERT
            {
                handler.bulkAfterInsert(Trigger.new);
                handler.afterInsert(Trigger.new);
            }
            when AFTER_UPDATE
            {
                handler.bulkAfterUpdate(Trigger.new, Trigger.oldMap);
                handler.afterUpdate(Trigger.new,Trigger.oldMap);
            }
            when AFTER_DELETE
            {
                handler.bulkAfterDelete(Trigger.old);
                handler.afterDelete(Trigger.old);
            }
        }
        
        handler.doDML();
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
