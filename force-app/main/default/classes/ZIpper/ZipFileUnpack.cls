/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 10-11-2022
 * @last modified by  : Gurkgamer
**/
public with sharing class ZipFileUnpack
{
    //zipFileData es el base64 del archivo zip
    @AuraEnabled
    public static String unpackZipAndUpload(String zipFileData)
    {
        //Usamos el zippex para cargar el ZIP
        Blob contenido = EncodingUtil.base64Decode(zipFileData);

        Zippex unzipper = new Zippex(contenido);
        Map<String,Blob> fileData = new Map<String,Blob>();

        for(String nextFileName : unzipper.getFileNames())
        {
            Blob fileContent = unzipper.getFile(nextFileName);
            fileData.put(nextFileName,fileContent);
        }

        insertFilesToSalesforce(fileData);

        return 'Al menos no he explotado';
    }

    private static void insertFilesToSalesforce(Map<String,Blob> fileData)
    {
        //0º Buscar las cuentas
        Set<String> accountNames = new Set<String>();
        for(String nextFileName : fileData.keySet())
        {
            System.debug(nextFileName);
            accountNames.add(nextFileName.split('\\.').get(0));
        }
        Map<String,Id> accounts = getRecordsForFiles(accountNames);

        List<ContentVersion> archivosAInsertar = new List<ContentVersion>();
        //1º ContentVersion

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
            WHERE   id IN: archivosAInsertar
        ];

        Map<String,Id> contentDocumentIdByFileName = new Map<String,Id>();

        for(ContentVersion nextAI : archivosInsertados)
        {
            contentDocumentIdByFileName.put(nextAI.Title + '.' + nextAI.FileExtension, nextAI.ContentDocumentId);
        }

        //2º ContentDocumentLink
        List<ContentDocumentLink> enlaceArchivos = new List<ContentDocumentLink>();

        for(String nextFile : contentDocumentIdByFileName.keySet())
        {
            enlaceArchivos.add(new ContentDocumentLink(
                ContentDocumentId = contentDocumentIdByFileName.get(nextFile),
                LinkedEntityId = accounts.get(nextFile.split('\\.').get(0)),
                ShareType = 'I',
                Visibility = 'AllUsers'
            ));
        }

        insert enlaceArchivos;
    }

    private static Map<String,Id> getRecordsForFiles(Set<String> accountNames)
    {
        Map<String,Id> accountNameMap = new Map<String,Id>();

        for(Account nextA :[SELECT Name FROM Account WHERE name IN :accountNames])
        {
            accountNameMap.put(nextA.Name, nextA.Id);
        }

        return accountNameMap;
    }
}
