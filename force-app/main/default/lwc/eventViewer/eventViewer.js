import { LightningElement,track } from 'lwc';
import { subscribe, unsubscribe} from 'lightning/empApi';
import runServerAction from '@salesforce/apex/EventViewerController.runServerAction';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class EventViewer extends LightningElement
{
    sfLogEvent = '/event/Log__e';
    sfLogEventSubscription = {};
    lastMessage = 'nada por ahora';

    connectedCallback()
    {
        console.log('Start');
        this.subscribeToLogEvent();
    }

    subscribeToLogEvent()
    {
        console.log('supSubcribelog');
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

    async handleEventSubscription()
    {
        subscribeToLogEvent();
    }

    async handleRunServerAction() {
        try {
            const contextId = null; // replace with a real value if needed
            const result = await runServerAction({ contextId });
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Apex executed',
                    message: result,
                    variant: 'success'
                })
            );
        } catch (error) {
            // Surface the error
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Apex error',
                    message: error?.body?.message || error.message || 'Unknown error',
                    variant: 'error'
                })
            );
            // And log for debugging
            // eslint-disable-next-line no-console
            console.error('runServerAction error', error);
        }
    }

    refreshComponent()
    {
        this.dispatchEvent(new RefreshEvent());
    }

}
