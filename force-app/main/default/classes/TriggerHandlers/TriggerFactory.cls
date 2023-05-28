/**
 * @description       : Class that implements the Factory pattern for managing Salesforce triggers.
 *                      It allows executing the trigger context in an organized and clear manner, regardless of the originating entity.
 *                      By using metadata, it is possible to configure the avoidance of executing the Handler class.
 *                      The trigger should call the public method, passing the instantiation of the Handler class that implements the ITriggerHandler interface,
 *                      to ensure the execution of the corresponding operation based on the context.
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 05-28-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class TriggerFactory
{
    /**
     * @description Executes trigger functionality for a specified handler class implementing the ITriggerHandler interface.
     *
     * @param       handlerInstance
     *              The class on which the Trigger functionality should be executed. It must implement the ITriggerHandler interface.
     * @throws      TriggerFactoryException
     *              If a null parameter is received.
     */
    public static void manageTrigger(ITriggerHandler handlerInstance)
    {
        validateParameterNotNull(handlerInstance, 'handlerInstance');

        if(isHandlerEnabledInMetadata(handlerInstance))
        {
            execute(handlerInstance, Trigger.operationType);
        }
    }

    /**
     * @description Method that executes the context of a trigger based on its operation enumerator.
     *              It only accepts classes that implement the ITriggerHandler interface as parameters.
     *              The TriggerOperation parameter indicates in which context the Trigger Factory will execute.
     *
     * @param       handlerInstance
     *              The class from which the Trigger methods should be executed.
     * @param       triggerOperation
     *              Parameter that indicates the execution context of the Trigger Factory.
     * @throws      IllegalArgumentException
     *              An exception will be thrown if any of the input parameters is null.
     */
    @TestVisible
    private static void execute(ITriggerHandler handlerInstance, System.TriggerOperation triggerOperation)
    {
        validateParameterNotNull(handlerInstance, 'handlerInstance');
        validateParameterNotNull(triggerOperation, 'triggerOperation');

        switch on triggerOperation
        {
            when BEFORE_INSERT
            {
                handlerInstance.beforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE
            {
                handlerInstance.beforeUpdate(Trigger.new, Trigger.oldMap);
            }
            when BEFORE_DELETE
            {
                handlerInstance.beforeDelete(Trigger.old);
            }
            when AFTER_INSERT
            {
                handlerInstance.afterInsert(Trigger.new);
            }
            when AFTER_UPDATE
            {
                handlerInstance.afterUpdate(Trigger.new,Trigger.oldMap);
            }
            when AFTER_DELETE
            {
                handlerInstance.afterDelete(Trigger.old);
            }
        }
    }


    /**
     * @description Validates that the specified parameter is not null.
     *              If the parameter is null, an IllegalArgumentException is thrown
     *              with the corresponding parameter name and an error message.
     *
     * @param       parameter
     *              The parameter to validate.
     * @param       parameterName
     *              The name of the parameter.
     * @throws      IllegalArgumentException
     *              If the parameter is null.
     */
    @TestVisible
    private static void validateParameterNotNull(Object parameter, String parameterName)
    {
        if(parameter == null)
        {
            throw new IllegalArgumentException('Parameter ' + parameterName + ' can not be null');
        }
    }

    // METADATA

    /**
     * Property representing a lazy-loaded map of TriggerSetup__mdt metadata records.
     */
    private static Map<String,TriggerSetup__mdt> triggerSetupMetadataRecords
    {
        get
        {
            if(triggerSetupMetadataRecords == null)
            {
                triggerSetupMetadataRecords = new Map<String,TriggerSetup__mdt>();
                triggerSetupMetadataRecords.putAll(TriggerSetup__mdt.getAll());
            }

            return triggerSetupMetadataRecords;
        }
        set;
    }

    /**
     * @description This method checks if a class is configured in metadata to be active or not.
     *              If it is active, the entire trigger process will be executed. Otherwise, it will do nothing.
     *              It is necessary for the Handler class to be registered in metadata; otherwise, this method
     *              will throw an exception for the missing configuration.
     *
     * @param       handlerInstance
     *              The class to be checked for its activation status in the metadata.
     * @return      boolean
     *              The method responds indicating whether the class is active in the metadata to execute its Trigger methods.
     * @throws      IllegalArgumentException
     *              The method throws an exception if a null parameter is received.
     *              TriggerFactoryException
     *              This exception will be thrown when there is no configuration for the instantiated handler class in the TriggerSetup__mdt metadata.
     */
    @TestVisible
    private static boolean isHandlerEnabledInMetadata(ITriggerHandler handlerInstance)
    {
        validateParameterNotNull(handlerInstance, 'handlerInstance');

        TriggerSetup__mdt handlerConfig = getTriggerSetup(handlerInstance);

        if(handlerConfig == null)
        {
            String className = String.valueOf(handlerInstance).split(':').get(0);
            throw new TriggerFactoryException('There is no configuration for this handler ' + className);
        }

        return handlerConfig.Enabled__c;
    }

    /**
     * @description Method to retrieve the configuration record of a Handler class from the Trigger Setup metadata.
     *              It is searched based on the class name received as a parameter. If the data is not found,
     *              null will be returned.
     *
     * @param       handlerInstance
     *              The class from which the configuration is to be retrieved in metadata.
     * @return      TriggerSetup__mdt
     *              The configuration record of the Handler class in metadata. If it does not exist,
     *               the returned value will be null.
     * @throws      IllegalArgumentException
     *               The method throws an exception when it receives a null parameter.
     */
    @TestVisible
    private static TriggerSetup__mdt getTriggerSetup(ITriggerHandler handlerInstance)
    {
        validateParameterNotNull(handlerInstance, 'handlerInstance');

        String className = String.valueOf(handlerInstance).split(':').get(0);

        return triggerSetupMetadataRecords.get(className);
    }

    /**
     * @description This method exists to create specific metadata records for testing the functionality of Trigger Factory.
     *              It should only be used by the test class to verify that the functionality works according to the expected
     *              configuration based on the values assigned to the metadata using this method.
     *
     * @param       handlerInstance
     *              The class from which the configuration is to be retrieved in metadata.
     * @param       enabled
     *              A boolean indicating whether the handler class is enabled or not.
     * @throws      IllegalArgumentException
     *              This method throws an exception when it receives any null parameter.
     */
    @TestVisible
    private static void setTriggerSetup(ITriggerHandler handlerInstance, Boolean isEnabled)
    {
        validateParameterNotNull(handlerInstance, 'handlerInstance');
        validateParameterNotNull(isEnabled, 'isEnabled');

        String className = String.valueOf(handlerInstance).split(':').get(0);

        TriggerSetup__mdt madeUpTriggerSetupMetadata = new TriggerSetup__mdt(DeveloperName = className, Enabled__c = isEnabled);
        triggerSetupMetadataRecords.put(className,madeUpTriggerSetupMetadata);
    }

    public class TriggerFactoryException extends Exception{}
}