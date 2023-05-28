# Trigger Factory

## Description

Factory pattern for managing Salesforce triggers. It allows executing the trigger context in an organized and clear manner, regardless of the originating entity. The trigger should call the public method, passing the instantiation of the Handler class that implements the ITriggerHandler interface, to ensure the execution of the corresponding operation based on the context.

By using metadata, it is possible to configure the avoidance of executing the Handler class. Use this records to control the Trigger execution in a production enviroment where Triggers can't be disabled or if you need to modify, load or delete a number of records without the trigger logic.

## Apex Class: TriggerFactory Methods

- [manageTrigger(handlerInstance)](#section-manageTrigger)

    Executes trigger functionality for a specified handler class implementing the ITriggerHandler interface.

### - **manageTrigger(handlerInstance)** <a name="section-manageTrigger"></a>

Executes trigger functionality for a specified handler class implementing the ITriggerHandler interface.

#### **Signature**

`public static void manageTrigger(ITriggerHandler handlerInstance)`

#### **Parameters**

*handlerInstance*

Type: ITriggerHandler

The class on which the Trigger functionality should be executed.

#### **Return Value**

Type: void

#### **Usage**

Call this method withing a Trigger with a new instance of the class handler you want to execute in the Trigger's context.

    TriggerFactory.manageTrigger(new AccountHandler());


## Custom Metadata: TriggerSetup__mdt

Custom metadata type used to configure the activation status of the Handler class. Use this records to control if you want to execute the code of a particular handler.

Each entry will have to state the name of the Handler Class. The Enabled field will control if the handler class will be executed by the Trigger Factory. **The DeveloperName must be the class name.**

Entry example for an AccountHandler class:

| Label | DeveloperName | Enabled|
|-------|---------------|--------|
| Account Handler | AccountHandler | True |

#

This module is composed of the following files:

**Apex Class**
- TriggerFactory.cls
- TriggerFactory.cls-meta.xml
- ITriggerHandler.cls
- ITriggerHandler.cls-meta.xml
- TriggerFactoryTest.cls
- TriggerFactoryTest.cls-meta.xml

**Custom Object**
- TriggerSetup__mdt
    - TriggerSetup__mdt.object-meta.xml
    - fields
        - Enabled__c.field-meta.xml
    - listViews
        - All_info.listView-meta.xml
