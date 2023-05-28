/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 02-18-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class IntegrationCheck implements Schedulable
{

    private String queueName;
    private String batchName;
    private Integer currentRetryIndex = 0;
    private Map<Integer,Integer> frequencyMinutesEachRetry
    {
        get
        {
            if(frequencyMinutesEachRetry != null)
            {
                return frequencyMinutesEachRetry;
            }

            frequencyMinutesEachRetry = new Map<Integer,Integer>
            {
                0=>60,
                1=>30,
                2=>15,
                3=>5
            };
        }
        set;
    }

    public IntegrationCheck(String queueToCheck, String batchToLaunch)
    {

    }

    public Id enqueueIntegrationCheck()
    {
        Id enqueueId = System.enqueueJob(this);
    }

    public void execute(SchedulableContext sc)
    {
        List<ExternalRecord__c> lastEntryInIntegration = [SELECT CreatedDate FROM ExternalRecord__c WHERE processed__c = false ORDER BY createddate DESC LIMIT 1];

        if(lastEntryInIntegration.isEmpty())
        {

        }
        else
        {

        }
    }


}