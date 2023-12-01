/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 09-08-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class RecordTypeUtil
{
    public static Id getRecordTypeId(Schema.SObjectType sObjectType, String recordTypeName)
    {
        Schema.DescribeSObjectResult objDescribe        = sObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> recordTypes  = objDescribe.getRecordTypeInfosByName();

        if (recordTypes.containsKey(recordTypeName))
        {
            return recordTypes.get(recordTypeName).getRecordTypeId();
        }

        return null; // Return null if RecordType is not found
    }
}