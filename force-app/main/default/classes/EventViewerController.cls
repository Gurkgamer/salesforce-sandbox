/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 12-09-2023
 * @last modified by  : Gurkgamer
**/
public without sharing class EventViewerController
{

    @AuraEnabled(cacheable=true)
    public static List<String> getAvailablePlatformEvents()
    {
        List<String> availablePlatformEvents = new List<String>();

        for(String nextPESobject : Schema.getGlobalDescribe().keySet())
        {
            if(nextPESobject.contains('__e'))
            {
                availablePlatformEvents.add(nextPESobject);
            }
        }

        return availablePlatformEvents;
    }
}