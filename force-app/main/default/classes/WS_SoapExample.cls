/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 08/04/2022
 * @last modified by  : jgallaga
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   08/04/2022   jgallaga   Initial Version
**/
global with sharing class WS_SoapExample
{
    webservice static calloutResponse createNewAccount(Customer record)
    {

        return new calloutResponse();
    }

    global class Customer
    {

    }

    global class calloutResponse
    {
        String hey = 'Aupa';
    }
}
