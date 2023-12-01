/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 10-12-2022
 * @last modified by  : Gurkgamer
**/
public without sharing class ZipFileUnpack
{
    //zipRawData es el base64 del archivo zip
    @AuraEnabled
    public static String unpackZipAndUpload(ZipFileWrapper zipfileData)
    {
        String resultString = 'OK';

        try
        {
            // Get data ready for processing

            Blob zipBlobData = EncodingUtil.base64Decode(zipfileData.zipRawData);
            Zippex zipFile = new Zippex(zipBlobData);
            Map<String,Blob> fileData = new Map<String,Blob>();

            for(String nextFileName : zipFile.getFileNames())
            {
                Blob fileContent = zipFile.getFile(nextFileName);
                fileData.put(nextFileName, fileContent);
            }

            String sObjectName  = zipfileData.objectName;
            String sObjectFIeld = zipfileData.fieldName;

            Schema.SObjectType schemaSObjectName    = String.isNotBlank(sObjectName)    ? Schema.getGlobalDescribe().get(sObjectName) : null;
            Schema.SObjectField schemaSObjectField  = String.isNotBlank(sObjectField)   ? Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(sObjectField) : null;

            // Process to insert

            insertFilesToSalesforce(fileData, schemaSObjectName, schemaSObjectField);
        }
        catch(Exception errorUnzip)
        {
            resultString = errorUnzip.getMessage() + ' => ' + errorUnzip.getStackTraceString();
            System.debug(resultString);
            throw errorUnzip;
        }

        return resultString;
    }

    // Each file will be attached to the record where name and filename match
    private static void insertFilesToSalesforce(Map<String,Blob> fileData, Schema.SObjectType sObjectName, Schema.SObjectField sObjectField)
    {
        // The files are inserted as Content Version, it returns map of filename and its ContentDocumentId
        Map<String,Id> contentDocumentIdByFileName = insertFiles(fileData);

        // Obtain the records the files will be added to
        Set<String> accountNames = new Set<String>();

        for(String nextFileName : fileData.keySet())
        {
            accountNames.add(nextFileName.split('\\.').get(0));
        }

        Map<String,Id> accountIdsByName = getRecordsForFiles(sObjectName, sObjectField, accountNames);

        // Add the files to each record as an attachment
        relatefilesToRecord(contentDocumentIdByFileName, accountIdsByName);
    }

    private static Map<String,Id> insertFiles(Map<String,Blob> fileData)
    {
        List<ContentVersion> archivosAInsertar = new List<ContentVersion>();

        for(String file : fileData.keySet())
        {
            ContentVersion nuevoArchivo = new ContentVersion
            (
                VersionData = fileData.get(file),
                Title = file.split('\\.').get(0),
                ContentLocation= 's',
                PathOnClient = file
            );
            archivosAInsertar.add(nuevoArchivo);
        }

        insert archivosAInsertar;

        List<ContentVersion> archivosInsertados =
        [
            SELECT  ContentDocumentId, FileExtension, Title
            FROM    ContentVersion
            WHERE   Id IN: archivosAInsertar
        ];

        Map<String,Id> contentDocumentIdByFileName = new Map<String,Id>();

        for(ContentVersion nextAI : archivosInsertados)
        {
            contentDocumentIdByFileName.put(nextAI.Title + '.' + nextAI.FileExtension, nextAI.ContentDocumentId);
        }

        return contentDocumentIdByFileName;
    }

    private static void relatefilesToRecord(Map<String,Id> contentDocumentIdByFileName, Map<String,Id> accountIdsByName)
    {
        List<ContentDocumentLink> enlaceArchivos = new List<ContentDocumentLink>();

        for(String nextFile : contentDocumentIdByFileName.keySet())
        {
            ContentDocumentLink nextFileLink = new ContentDocumentLink(
                ContentDocumentId = contentDocumentIdByFileName.get(nextFile),
                LinkedEntityId = accountIdsByName.get(nextFile.split('\\.').get(0)),
                ShareType = 'I',
                Visibility = 'AllUsers'
            );

            enlaceArchivos.add(nextFileLink);
        }

        insert enlaceArchivos;
    }

    public static Map<String,Id> getRecordsForFiles(Schema.SObjectType sObjectSchema, Schema.SObjectField searchFieldSchema, Set<String> whereValues)
    {
        Map<String,Id> resultRecords = new Map<String,Id>();

        if(sObjectSchema == null || searchFieldSchema == null || whereValues == null)
        {
            return resultRecords;
        }

        String sObjectName = sObjectSchema.getDescribe().getName();
        String fieldName = searchFieldSchema.getDescribe().getName();

        String queryString = 'SELECT ' + fieldName +' FROM ' + sObjectName + ' WHERE ' + fieldName + ' IN : whereValues';

        for(SObject nextRecord : Database.query(queryString))
        {
            String fieldValue   = String.valueOf(nextRecord.get(fieldName));
            String recordId     = String.valueOf(nextRecord.get('Id'));

            resultRecords.put(fieldValue, recordId);
        }

        return resultRecords;
    }

    public with sharing class ZipFileWrapper
    {
        @AuraEnabled
        public String zipRawData {get;set;}
        @AuraEnabled
        public String objectName {get;set;}
        @AuraEnabled
        public String fieldName {get;set;}
    }
}