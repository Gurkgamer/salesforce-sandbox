/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 06/04/2022
 * @last modified by  : jgallaga
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   05/04/2022   jgallaga   Initial Version
**/
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    switch on Trigger.operationType
    {
        when BEFORE_INSERT
        {
            AccountHandler.bulkBefore  (trigger.new, trigger.oldMap);
            AccountHandler.beforeInsert(trigger.new);
        }
        when BEFORE_UPDATE
        {
            AccountHandler.bulkBefore  (trigger.new, trigger.oldMap);
            AccountHandler.beforeUpdate(trigger.new, trigger.oldMap);
        }
        when BEFORE_DELETE
        {
            AccountHandler.bulkBefore  (trigger.new, trigger.oldMap);
            AccountHandler.beforeDelete(trigger.oldMap);
        }
        when AFTER_INSERT
        {
            AccountHandler.bulkAfter   (trigger.new, trigger.oldMap);
            AccountHandler.afterInsert (trigger.new);
        }
        when AFTER_UPDATE
        {
            AccountHandler.bulkAfter   (trigger.new, trigger.oldMap);
            AccountHandler.afterUpdate (trigger.new, trigger.oldMap);
        }
        when AFTER_DELETE
        {
            AccountHandler.bulkAfter   (trigger.new, trigger.oldMap);
            AccountHandler.afterDelete (trigger.oldMap);
        }
        when else
        {
            // Should not get here (undelete?)
            System.debug('Tipo de operacion desconocido: ' + Trigger.operationType);
        }
    }
}