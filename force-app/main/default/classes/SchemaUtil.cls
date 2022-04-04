/**
**/
public without sharing class SchemaUtil {


    public static String getSOjbectIcon(Schema.SObjectType SObjectValue)
    {
        if(SObjectValue == null)
        {
            return null;
        }

        List<Schema.DescribeTabSetResult> tabSetDesc    = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc          = new List<Schema.DescribeTabResult>();

        for(Schema.DescribeTabSetResult nextTSR : tabSetDesc)
		{
            tabDesc.addAll(nextTSR.getTabs());
		}

        String sObjectName = SObjectValue.getDescribe().getName();

        for(Schema.DescribeTabResult nextTR : tabDesc)
        {
            if(nextTR.getSobjectName() == sObjectName)
            {
                for (Schema.DescribeIconResult nextIR : nextTR.getIcons())
                {
                    if (nextIR.getContentType() == 'image/svg+xml')
                    {
                        if(nextTR.isCustom())
                        {
                            return 'custom:' + nextIR.getUrl().substringAfterLast('/').substringBeforeLast('.');
                        }
                        else
                        {
                            return 'standard:' + nextIR.getUrl().substringAfterLast('/').substringBeforeLast('.');
                        }
                    }
                }
            }
        }

        return null;
    }
}
