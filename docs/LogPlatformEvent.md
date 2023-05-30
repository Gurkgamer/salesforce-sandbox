# Log Platform Event

## Description

Framework for publishing platform events to log information into the Salesforce Event Bus. The Log Event Builder class implements the Builder pattern, allowing easy creation of log records with customizable field values. Developers can selectively fill the fields that are relevant to their needs. The LogEventBuilderHelper class provides a convenient way to manage and publish batches of log events. Log records are stored until they are ready to be published collectively.

## Apex Class: Log Event Builder Helper

This class will manage the creation and publication of the log events. Every time a new  log record is needed, a builder instance will be created to be able to populate the needed fields by using a Builber pattern. Check the Log Event Builder class section to learn how to use this pattern.

The helper class will keep each record created until they are published. Each time is published, the helper will be cleared to publish the new record created after.

### Methods

- [createLogEventBuilder(message)](#createLogEventBuilder(message))

    Creates a new LogEventBuilder instance with the provided message and adds it to the list of events.

- [appendLogEventBuilder(logEventBuilderInstance)](#appendLogEventBuilder(logEventBuilderInstance))

    This method adds the received LogEventBUilder instance to the list of built intances.

- [publish()](#publish())

    Prepares the accumulated log events for publishing and publishes them.

- [resetLogEvents()](#resetLogEvents())

    Allows to remove the LogEventBuilder instances that are present in the helper.


#### **createLogEventBuilder(message)**
---

Creates a new LogEventBuilder instance with the provided message and adds it to the list of events.

**Signature**

`public static LogEventBuilder createLogEventBuilder(String message)`

**Parameters**

*message*

Type: String

**Return value**

Type: LogEventBuilder

**Usage**

Call this method to receive a new instance of LogEventBuilder.

    LogEventBuilderHelper.createLogEventBuilder('Log event message');

#### **addLogEventBuilder(logEventBuilderInstance)**
---

This method adds the received LogEventBUilder instance to the list of built intances.

**Signature**

`public static void addLogEventBuilder(LogEventBuilder logEventBuilderInstance)`

**Parameters**

logEventBuilderInstance

Type: LogEventBuilder

**Return value**

Type: void

#### **publish()**
---

Prepares the accumulated log events for publishing and publishes them to the Event bus.

**Signature**

`public static List<Database.SaveResult> publish()`

**Return value**

Type: List<Database.SaveResult>

A list with the publishing results of the log events records to the Event bus.

#### **resetLogEvents()**
---

Allows to remove the LogEventBuilder instances that are present in the helper without publishing.

**Signature**

`public static void resetLogEvents()`

**Return value**

Type: void

## Apex Class : Log Event Builder

### Methods

#### **temp**
---

**Signature**

**Parameter**

**Return value**

**Usage**

# Usage

# Files

This module is composed of the following files:

**Apex Class**
- LogEventBuilderHelper.cls
- LogEventBuilderHelper.cls-meta.xml
- LogEventBuilderHelperTest.cls
- LogEventBuilderHelperTest.cls-meta.xml
- LogEventBuilder.cls
- LogEventBuilder.cls-meta.xml
- LogEventBuilderTest.cls
- LogEventBuilderTest.cls-meta.xml

**Custom Object**
- Log__e
    - Log__e.object-meta.xml
    - fields
        - DMLExceptionFields__c.field-meta.xml
        - EventTime__c.field-meta.xml
        - ExceptionCause__c.field-meta.xml
        - ExceptionMessage__c.field-meta.xml
        - ExceptionStackTrace__c.field-meta.xml
        - ExceptionType__c.field-meta.xml
        - ExternalId__c.field-meta.xml
        - Message__c.field-meta.xml
        - RecordId__c.field-meta.xml
        - SourceClass__c.field-meta.xml
        - TransactionId__c.field-meta.xml
        - Type__c.field-meta.xml
        - UserId__c.field-meta.xml