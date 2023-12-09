import { LightningElement,wire, track } from 'lwc';
import { subscribe, unsubscribe} from 'lightning/empApi';
import getPlatformEventList from "@salesforce/apex/EventViewerController.getAvailablePlatformEvents";

export default class EventViewer extends LightningElement
{
    sfLogEvent = '/event/Log__e';
    sfLogEventSubscription = {};
    lastMessage = 'nada por ahora';
    platformEventList = [];
    dropboxValues = [];
    currentSelectedPE;

    connectedCallback()
    {
        //this.subscribeToLogEvent();
    }

    handleSubscribe()
    {
        this.subscribeToLogEvent(this.currentSelectedPE);
    }

    disconnectedCallback() {
        this.unsuscribeToLogEvent();
    }

    @wire(getPlatformEventList)
    _platformEventList({ error, data })
    {
        if(data)
        {
            this.platformEventList = data;
            this.dropboxValues = [];
            for (const label of data) {
                const option = {
                    value: label,
                    label: label
                };

                this.dropboxValues.push(option);
            }
            console.log(data);
        }
    }


    subscribeToLogEvent(eventName)
    {
        const eventDescribe = '/event/'+eventName;
        //this.sfLogEventSubscription = subscribe(this.sfLogEvent,-1,this.handleEvent.bind(this))
        this.sfLogEventSubscription = subscribe(eventDescribe,-1,this.handleEvent.bind(this))

        .then(response =>
            {
                console.log('Successfully subscribed to : ', JSON.stringify(response.channel));
            });
    }

    unsubscribeToLogEvent()
    {
        unsubscribe(this.sfLogEventSubscription, response => {
            console.log('Successfully unsubscribed from : ', JSON.stringify(response.channel));
            // Handle successful unsubscription
        }, onError);
    }

    data = [];
    columns = [];
    tempColumns = [];
    selected = [];
    columnOptions = [];

    handleEvent(message)
    {
        try
        {
            this.lastMessage = message.data.payload.Message__c;

            if(this.columns.length == 0)
            {
                const jsonData = JSON.parse(JSON.stringify(message));

                const payloadKeys = Object.keys(jsonData.data.payload);

                this.columns = payloadKeys.map((key) => ({
                    label: key,
                    fieldName: key,
                    type: 'text',
                }));

                this.tempColumns = this.columns;


                this.columnOptions = payloadKeys.map((columnName) => ({
                    label: columnName,
                    value: columnName
                }));

            }

            this.data = [...this.data, JSON.parse(JSON.stringify(message)).data.payload];

        }
        catch(error)
        {
            console.log('ERROR: '+ error.message);
            console.log('LINE: '+ error.lineNumber);
        }
    }

    handlePEChosseingChange(event)
    {
        this.currentSelectedPE = event.detail.value;
        //currentSelectedPE = message.value;
    }

    refreshComponent()
    {
        this.dispatchEvent(new RefreshEvent());
    }

    get selected() {
        return this.selected.length ? this.selected : 'none';
    }

    handleChange(e)
    {
        this.selected = e.detail.value;
        const selectedColumns = this.selected.map(selected => this.tempColumns.find(column => column.fieldName === selected));
        this.columns = selectedColumns;
    }
}