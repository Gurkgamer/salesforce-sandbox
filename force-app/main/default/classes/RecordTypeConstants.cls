public with sharing class RecordTypeConstants
{
    private static Map<Schema.SObjectType, Map<String, Schema.RecordTypeInfo>> sObjectRecordTypeNames = new Map<Schema.SObjectType, Map<String,Schema.RecordTypeInfo>>();

    public static AccountTR AccountRecordTypes = new AccountTR();
    public static PersonAccountTR PersonAccountRecordTypes = new PersonAccountTR();
    public static LeadRT LeadRecordTypes = new LeadRT();

    public static Id getRecordTypeID(RecordTypeData recordType)
    {
        Schema.SObjectType entity = recordType.getSObjectType();

        if( ! sObjectRecordTypeNames.containsKey(entity))
        {
            sObjectRecordTypeNames.put(entity, entity.getDescribe().getRecordTypeInfosByName());
        }

        String recordTypeName = recordType.getName();
        Boolean recordTypeExists = sObjectRecordTypeNames.get(entity).containsKey(recordTypeName);

        if( ! recordTypeExists)
        {
            String sobjectName = entity.getDescribe().getName();
            throw new RecordTypeConstantsException('No existe el nombre de tipo de registro ' + recordTypeName + ' en la entidad ' + sobjectName);
        }

        return sObjectRecordTypeNames.get(entity).get(recordTypeName).getRecordTypeId();
    }

    public class AccountTR
    {
        private Schema.SObjectType accountType = Account.sObjectType;
        private AccountTR(){}
        public final RecordTypeData BUSINES_SACCOUNT = new RecordTypeEntry(accountType, 'Business_Account');
    }

    public class PersonAccountTR
    {
        private Schema.SObjectType accountType = Account.sObjectType;
        private PersonAccountTR(){}
        // public final RecordTypeData PERSON_ACCOUNT = new RecordTypeEntry(accountType, 'PersonAccount');
    }

    public class LeadRT
    {
        private Schema.SObjectType leadType = Lead.sObjectType;
        private LeadRT(){}
    }

    public interface RecordTypeData
    {
        String getName();
        Schema.SObjectType getSObjectType();
    }

    private class RecordTypeEntry implements RecordTypeData
    {
        private Schema.SObjectType entityType;
        private String name;

        public RecordTypeEntry(Schema.SObjectType rtEntityType, String rtName)
        {
            entityType = rtEntityType;
            name = rtName;
        }

        public Schema.SObjectType getSObjectType() { return entityType;}
        public String getName() { return name;}
    }

    public class RecordTypeConstantsException extends Exception{}
}