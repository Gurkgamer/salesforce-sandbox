public with sharing class RecordTypeConstants
{
    private static Map<Schema.SObjectType, Map<String, Schema.RecordTypeInfo>> sObjectRecordTypeNames = new Map<Schema.SObjectType, Map<String,Schema.RecordTypeInfo>>();

    public static AccountTR AccountRecordTypes
    {
        get
        {
            if(AccountRecordTypes == null)
            {
                AccountRecordTypes = new AccountTR();
            }
            return AccountRecordTypes;
        }
        private set;
    }
    public static PersonAccountTR PersonAccountRecordTypes
    {
        get
        {
            if(PersonAccountRecordTypes == null)
            {
                PersonAccountRecordTypes = new PersonAccountTR();
            }
            return PersonAccountRecordTypes;
        }
        private set;
    }
    public static LeadRT LeadRecordTypes
    {
        get
        {
            if(LeadRecordTypes == null)
            {
                LeadRecordTypes = new LeadRT();
            }
            return LeadRecordTypes;
        }
        private set;
    }

    private static Id getRecordTypeID(RecordTypeData recordType)
    {
        Schema.SObjectType entity = recordType.getSObjectType();

        if( ! sObjectRecordTypeNames.containsKey(entity))
        {
            sObjectRecordTypeNames.put(entity, entity.getDescribe().getRecordTypeInfosByDeveloperName());
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
        private final RecordTypeData COMPANY_RTD = new RecordTypeEntry(accountType, 'Company');
        private final RecordTypeData TEST_RTD = new RecordTypeEntry(accountType, 'MadeUpForTestPurpose');

        public Id COMPANY { get { return getRecordTypeID(COMPANY_RTD); } private set; }
        public Id TEST { get { return getRecordTypeID(TEST_RTD); } private set; }
    }

    public class PersonAccountTR
    {
        private Schema.SObjectType accountType = Account.sObjectType;
        private PersonAccountTR(){}
        private final RecordTypeData PERSON_ACCOUNT_RTD = new RecordTypeEntry(accountType, 'PersonAccount');

        public Id PERSON_ACCOUNT { get { return getRecordTypeID(PERSON_ACCOUNT_RTD); } private set;}
    }

    public class LeadRT
    {
        private Schema.SObjectType leadType = Lead.sObjectType;
        private LeadRT(){}
    }

    private interface RecordTypeData
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