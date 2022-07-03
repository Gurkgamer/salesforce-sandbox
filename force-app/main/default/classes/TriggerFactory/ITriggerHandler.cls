/**
 * @description       : Every Handler class to be managed by the trigger factory need to implement this interface
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 07-04-2022
 * @last modified by  : jgallaga
**/
public interface ITriggerHandler
{
    void bulkBeforeInsert(List<SObject> newList);

    void bulkBeforeUpdate(List<SObject> newList, Map<Id,SObject> oldMap);

    void bulkBeforeDelete(List<SObject> oldList);

    void bulkAfterInsert(List<SObject> newList);

    void bulkAfterUpdate(List<SObject> newList, Map<Id,SObject> oldMap);

    void bulkAfterDelete(List<SObject> oldList);

    void beforeInsert(List<SObject> newList);

    void beforeUpdate(List<SObject> newList, Map<Id,SObject> oldMap);

    void beforeDelete(List<SObject> oldList);

    void afterInsert(List<SObject> newList);

    void afterUpdate(List<SObject> newList, Map<Id,SObject> oldMap);

    void afterDelete(List<SObject> oldList);

    void finalDMLBefore();

    void finalDMLAfter();
}
