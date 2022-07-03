/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 07-03-2022
 * @last modified by  : jgallaga
**/
public interface ITriggerHandler 
{
    void bulkInsert();
    void bulkUpdate();
    void bulkDelete();
    void beforeInsert();
    void beforeUpdate();
    void beforeDelete();
    void afterInsert();
    void afterUpdate();
    void afterDelete();
    void doDML();
}
