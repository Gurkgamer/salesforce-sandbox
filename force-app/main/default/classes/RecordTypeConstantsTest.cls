@isTest
private class RecordTypeConstantsTest {

    @isTest
    private static void testGetRecordTypeID_RecordTypeNotFound()
    {
        Test.startTest();
        Boolean exceptionThrown = false;

        try
        {
            Id recTypeId = RecordTypeConstants.getRecordTypeID(RecordTypeConstants.AccountRecordTypes.BUSINES_SACCOUNT);
        }
        catch (RecordTypeConstants.RecordTypeConstantsException ex)
        {
            exceptionThrown = true;
            System.assert(
                ex.getMessage().contains('No existe el nombre de tipo de registro'),
                'El mensaje de error debería indicar que no existe el record type.'
            );
        }

        Test.stopTest();
        System.assert(exceptionThrown, 'Debería lanzarse una excepción si el record type no existe.');
    }
}
