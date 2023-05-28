# Trigger Factory

## Description

Factory pattern for managing Salesforce triggers. It allows executing the trigger context in an organized and clear manner, regardless of the originating entity. By using metadata, it is possible to configure the avoidance of executing the Handler class. The trigger should call the public method, passing the instantiation of the Handler class that implements the ITriggerHandler interface, to ensure the execution of the corresponding operation based on the context.

## Apex Class: TriggerFactory Methods

- manageTrigger(handlerInstance)

    Executes trigger functionality for a specified handler class implementing the ITriggerHandler interface.

### manageTrigger(handlerInstance)

    Executes trigger functionality for a specified handler class implementing the ITriggerHandler interface.

#### Signature

    public static void manageTrigger(ITriggerHandler handlerInstance)`

#### Parameters

    *handlerInstance*

    Type: ITriggerHandler

    The class on which the Trigger functionality should be executed.

#### Return Value

    Type: void

Usage

    Call this method with a new instance of the class handler you want to execute in the Trigger's context.

## Custom Metadata: TriggerSetup__mdt

Custom metadata type used to configure the activation status of the Handler class.

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
