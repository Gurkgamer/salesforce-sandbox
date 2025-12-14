public with sharing class EventViewerController
{

    /*

    SELECT QualifiedApiName, DurableId, KeyPrefix
    FROM EntityDefinition
    WHERE KeyPrefix LIKE 'e%'

    */
    @AuraEnabled(cacheable=false)
    public static String runServerAction(String contextId) {
        // Simple sample logic. Replace with real implementation as needed.
        Log__e newEvent = new Log__e();
        newEvent.Message__c = 'Event from ' + UserInfo.getName();
        EventBus.publish(newEvent);
        return 'Server action completed';
    }
}
