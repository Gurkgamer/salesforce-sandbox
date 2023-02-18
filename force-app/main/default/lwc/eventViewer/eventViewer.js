import { LightningElement,track } from 'lwc';
import { subscribe, unsubscribe} from 'lightning/empApi';

export default class EventViewer extends LightningElement
{
    sfLogEvent = '/event/Log__e';
    sfLogEventSubscription = {};
    lastMessage = 'nada por ahora';

    connectedCallback()
    {
        this.subscribeToLogEvent();
    }

    subscribeToLogEvent()
    {
        this.sfLogEventSubscription = subscribe(this.sfLogEvent,-1,this.handleEvent.bind(this))
        .then(response =>
            {
                console.log('Successfully subscribed to : ', JSON.stringify(response.channel));
            });
    }

    unsuscribeToLogEvent()
    {
        unsubscribe(this.sfLogEventSubscription, response => {
            console.log('Successfully unsubscribed from : ', JSON.stringify(response.channel));
            // Handle successful unsubscription
        }, onError);
    }

    handleEvent(message)
    {
        try
        {
            console.log('Received message: ', JSON.stringify(message));
            // Handle the received event message
            this.lastMessage = message.data.payload.Message__c;
        }
        catch(error)
        {
            console.log('ERROR: '+ error.message);
        }
    }

    refreshComponent()
    {
        this.dispatchEvent(new RefreshEvent());
    }

}