import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled,} from 'lightning/empApi';

export default class EventViewer extends LightningElement 
{
    channelName = '/event/Log__e';
    isSubscribeDisabled = false;
    isUnsubscribeDisabled = !this.isSubscribeDisabled;

    currentMessage = 'texto';

    get lastMessage()
    {
        return this.currentMessage;
    }

    subscription = {};

    // Tracks changes to channelName text field
    handleChannelName(event) {
        this.channelName = event.target.value;
    }

    // Initializes the component
    connectedCallback() {
        // Register error listener
        this.registerErrorListener();
    }

    setValue(value)
    {
        this.currentMessage = value;
    }

    // Handles subscribe button click
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        var b = '';
        const messageCallback = function (response) {
            console.log('New message received: ', JSON.stringify(response));
            console.log('a');
            try
            {
                const a = JSON.stringify(response);
                b = JSON.parse(a);
                //this.currentMessage = b.data.payload.Message__c;
                console.log(b);
                console.log(this.currentMessage);
                this.currentMessage = b.data.payload.Message__c;
                
                //this.setValue = this.currentMessage;
            }
            catch(error)
            {
                console.log(error);
                //console.log(JSON.stringify(error));
            }
            // Response contains the payload of the new message received
        };

        console.log('asdasd');
        try
        {
            if(b)
            {
                console.log('no es este');
                console.log(b);
                this.currentMessage = b.data.payload.Message__c;
                console.log('v');
                console.log(this.currentMessage);
            }
        }
        catch(error)
        {
            console.log(error);
        }

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then((response) => {
            // Response contains the subscription information on subscribe call
            console.log(
                'Subscription request sent to: ',
                JSON.stringify(response.channel)
            );
            this.subscription = response;
            this.toggleSubscribeButton(true);
            this.currentMessage = 'conectado';
        });
    }

    // Handles unsubscribe button click
    handleUnsubscribe() {
        this.toggleSubscribeButton(false);

        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, (response) => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
            // Response is true for successful unsubscribe
        });
    }

    toggleSubscribeButton(enableSubscribe) {
        this.isSubscribeDisabled = enableSubscribe;
        this.isUnsubscribeDisabled = !enableSubscribe;
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }
}