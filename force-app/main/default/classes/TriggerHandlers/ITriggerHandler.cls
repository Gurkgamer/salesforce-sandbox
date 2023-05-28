/**
 * @description       : Every Handler class to be managed by the trigger factory need to implement this interface
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 05-28-2023
 * @last modified by  : Gurkgamer
**/
public interface ITriggerHandler
{
    void beforeInsert(List<SObject> newList);

    void beforeUpdate(List<SObject> newList, Map<Id,SObject> oldMap);

    void beforeDelete(List<SObject> oldList);

    void afterInsert(List<SObject> newList);

    void afterUpdate(List<SObject> newList, Map<Id,SObject> oldMap);

    void afterDelete(List<SObject> oldList);
}
