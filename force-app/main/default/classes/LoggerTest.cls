/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 29/03/2022
 * @last modified by  : jgallaga
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   08/03/2022   jgallaga   Initial Version
**/
@isTest
public class LoggerTest
{

    /**
     *  These tests check every method available to send a Platform event an write to the System logs.
     *  As the funcionality is enabled or disabled by metadata entries, a combination of these values is also tested.
     *  The only way to test an Event has been published wihtout a Listener is by checking the success property.
     */

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              Checks if the class does not create an Exception if the metadata is missing its entries.
     */
    @isTest
    static void testLog_OnlyMessage_NoMetadataEntries_OK()
    {
        Logger.logSetup = new Map<String, LogSetup__mdt>();

        Test.startTest();
        Database.SaveResult sr = Logger.log('Test Message');
        Test.stopTest();

        System.assertEquals(null,sr);
    }

    @isTest
    static void testLog_OnlyMessage_AllON()
    {
        LogSetup__mdt enableLogger = new LogSetup__mdt(developerName = 'EnableLogger', Value__c = '1');
        Logger.logSetup.put('EnableLogger', enableLogger);
        LogSetup__mdt enableSFLog = new LogSetup__mdt(developerName = 'EnableSFLog', Value__c = '1');
        Logger.logSetup.put('EnableSFLog', enableSFLog);

        Test.startTest();
        Database.SaveResult sr = Logger.log('Test Message');
        Test.stopTest();

        System.assert(sr.isSuccess());
    }

    @isTest
    static void testLog_OnlyMessage_OnlyDebug()
    {
        LogSetup__mdt enableLogger = new LogSetup__mdt(developerName = 'EnableLogger', Value__c = '0');
        Logger.logSetup.put('EnableLogger', enableLogger);
        LogSetup__mdt enableSFLog = new LogSetup__mdt(developerName = 'EnableSFLog', Value__c = '1');
        Logger.logSetup.put('EnableSFLog', enableSFLog);

        Test.startTest();
        Database.SaveResult sr = Logger.log('Test Message');
        Test.stopTest();

        System.assertEquals(null, sr);
    }

    @isTest
    static void testLog_OnlyMessage_OnlyLogger()
    {
        LogSetup__mdt enableLogger = new LogSetup__mdt(developerName = 'EnableLogger', Value__c = '1');
        Logger.logSetup.put('EnableLogger', enableLogger);
        LogSetup__mdt enableSFLog = new LogSetup__mdt(developerName = 'EnableSFLog', Value__c = '0');
        Logger.logSetup.put('EnableSFLog', enableSFLog);

        Test.startTest();
        Database.SaveResult sr = Logger.log('Test Message');
        Test.stopTest();

        System.assert(sr.isSuccess());
    }

    @isTest
    static void testLog_OnlyMessage_AllOFF()
    {
        LogSetup__mdt enableLogger = new LogSetup__mdt(developerName = 'EnableLogger', Value__c = '0');
        Logger.logSetup.put('EnableLogger', enableLogger);
        LogSetup__mdt enableSFLog = new LogSetup__mdt(developerName = 'EnableSFLog', Value__c = '0');
        Logger.logSetup.put('EnableSFLog', enableSFLog);

        Test.startTest();
        Database.SaveResult sr = Logger.log('Test Message');
        Test.stopTest();

        System.assertEquals(null, sr);
    }

    @isTest
    static void testLog_OnlyMessageNull_AllON()
    {
        LogSetup__mdt enableLogger = new LogSetup__mdt(developerName = 'EnableLogger', Value__c = '1');
        Logger.logSetup.put('EnableLogger', enableLogger);
        LogSetup__mdt enableSFLog = new LogSetup__mdt(developerName = 'EnableSFLog', Value__c = '1');
        Logger.logSetup.put('EnableSFLog', enableSFLog);

        String emptyText;

        Test.startTest();

        Database.SaveResult sr = Logger.log(emptyText);
        Test.stopTest();

        System.assert(sr.isSuccess());
    }

    @isTest
    static void testLog_MessageAndLevel_AllON()
    {
        LogSetup__mdt enableLogger = new LogSetup__mdt(developerName = 'EnableLogger', Value__c = '1');
        Logger.logSetup.put('EnableLogger', enableLogger);
        LogSetup__mdt enableSFLog = new LogSetup__mdt(developerName = 'EnableSFLog', Value__c = '1');
        Logger.logSetup.put('EnableSFLog', enableSFLog);

        Test.startTest();
        Database.SaveResult sr = Logger.log('Test Message', System.LoggingLevel.DEBUG);
        Test.stopTest();

        System.assert(sr.isSuccess());
    }

    @isTest
    static void testLog_MessageAndLogTypeNull_AllON_KO()
    {
        LogSetup__mdt enableLogger = new LogSetup__mdt(developerName = 'EnableLogger', Value__c = '1');
        Logger.logSetup.put('EnableLogger', enableLogger);
        LogSetup__mdt enableSFLog = new LogSetup__mdt(developerName = 'EnableSFLog', Value__c = '1');
        Logger.logSetup.put('EnableSFLog', enableSFLog);

        String emptyText;

        Test.startTest();
        Database.SaveResult sr = Logger.log(emptyText, emptyText);
        Test.stopTest();

        System.assert(sr.isSuccess());
    }

    @isTest
    static void testLog_MessageAndLevelAndLogType_AllON()
    {
        LogSetup__mdt enableLogger = new LogSetup__mdt(developerName = 'EnableLogger', Value__c = '1');
        Logger.logSetup.put('EnableLogger', enableLogger);
        LogSetup__mdt enableSFLog = new LogSetup__mdt(developerName = 'EnableSFLog', Value__c = '1');
        Logger.logSetup.put('EnableSFLog', enableSFLog);

        Test.startTest();
        Database.SaveResult sr = Logger.log('Test Message', System.LoggingLevel.DEBUG, 'Trigger new');
        Test.stopTest();

        System.assert(sr.isSuccess());
    }

    @isTest
    static void testLog_MessageAndLevelAndLogTypeNull_AllON_KO()
    {
        LogSetup__mdt enableLogger = new LogSetup__mdt(developerName = 'EnableLogger', Value__c = '1');
        Logger.logSetup.put('EnableLogger', enableLogger);
        LogSetup__mdt enableSFLog = new LogSetup__mdt(developerName = 'EnableSFLog', Value__c = '1');
        Logger.logSetup.put('EnableSFLog', enableSFLog);

        String emptyText;
        Boolean catchedException = false;

        Test.startTest();
        Database.SaveResult sr = Logger.log(emptyText, null, emptyText);
        Test.stopTest();

        System.assert(sr.isSuccess());
    }

    @isTest
    static void testLog_Exception_OK()
    {
        Database.SaveResult sr;

        Test.startTest();
        try
        {
            Integer divisionByZero = 1/0;
        }
        catch(Exception error)
        {
            sr = Logger.log(error);
        }
        Test.stopTest();

        System.assert(sr != null);
        System.assert(sr.isSuccess());
    }

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              A DML Exception is triggered by creating Accounts without a Name.
     *              Name is a required field for Accounts.
     */
    @isTest
    static void testLog_DMLException_OK()
    {
        List<Account> newAccounts = new List<Account>();

        for(Integer i = 0; i < 10; i++)
        {
            newAccounts.add(new Account());
        }

        List<Database.SaveResult> sr;

        Test.startTest();
        try
        {
            insert newAccounts;
        }
        catch(DmlException error)
        {
            System.assertEquals(System.StatusCode.REQUIRED_FIELD_MISSING, error.getDmlType(0));
            System.assertEquals('System.DmlException', error.getTypeName());
            sr = Logger.log(error);
        }
        catch(Exception error)
        {
            System.assert(false); // To be sure the exception is the expected one
        }
        Test.stopTest();

        System.assert(sr != null);
        System.assert(!sr.isEmpty());
        for(Database.SaveResult nextDS : sr)
        {
            System.assert(nextDS.isSuccess());
        }
    }


    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              An Email Exception is triggered by creating an Email that is missing its Body.
     *              The Body of an Email is required.
     */
    @isTest
    static void testLog_EmailException_OK()
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'xxx@xxxxxxxx.com'};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('info@xxxxxx.com');
        mail.setSenderDisplayName('My Name');
        mail.setBccSender(false);
        mail.setUseSignature(false);

        List<Database.SaveResult> sr;

        Test.startTest();
        try
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(EmailException error)
        {
            System.assertEquals(System.StatusCode.REQUIRED_FIELD_MISSING, error.getDmlType(0));
            System.assertEquals('System.EmailException', error.getTypeName());
            sr = Logger.log(error);
        }
        catch(DmlException error)
        {
            System.assert(false); // To be sure the exception is the expected one
        }
        catch(Exception error)
        {
            System.assert(false); // To be sure the exception is the expected one
        }
        Test.stopTest();

        System.assert(sr != null);
        System.assert(!sr.isEmpty());
        for(Database.SaveResult nextDS : sr)
        {
            System.assert(nextDS.isSuccess());
        }
    }


}