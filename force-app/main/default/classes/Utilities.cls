/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 12-10-2022
 * @last modified by  : Gurkgamer
**/
public with sharing class Utilities
{

    public static Boolean isFieldFromSobject(Schema.SObjectType sfObject, Schema.SObjectField sfField)
    {
        if(sfObject == null || sfField == null)
        {
            return false;
        }

        Map<String, Schema.SObjectField> objFieldMap = sfObject.getDescribe().fields.getMap();

        return objFieldMap.containsKey(sfField.getDescribe().getName());
    }
}