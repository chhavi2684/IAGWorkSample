/**
 * @description       : Test class for ClassToyDetailREST - test coverage = 88%
 * @author            : chhavi2684@gmail.com
 * @group             : 
 * @last modified on  : 08-12-2020
 * @last modified by  : chhavi2684@gmail.com
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   08-12-2020   chhavi2684@gmail.com   Initial Version
**/
@isTest
public class ClassToyDetailRESTTest {
    /* Test data setup class*/
    @TestSetup
    static void setupData() {
        Toys__c newToy = new Toys__c(Name = 'Test Toy', Description__c = 'Test Description', Is_Available__c = true, Price__c = 100);
        insert newToy;
    }
    /*Method to test positive scenario where Toys are found*/
    @isTest
	static void  getToyDetailsTest(){
        ClassToyDetailREST.RequestWrapper testToys = new ClassToyDetailREST.RequestWrapper();
        testToys.toyNames = new List<String>{'Test Toy','Not Found'};
        String testRequestString = JSON.serialize(testToys);
        RestRequest testRequest = new RestRequest(); 
        RestResponse testResponse = new RestResponse();
    	testRequest.requestURI = '/services/apexrest/ToyDetail/';  //Request URL
        testRequest.httpMethod = 'POST';//HTTP Request Type
        testRequest.requestBody = Blob.valueof(testRequestString);
        RestContext.request = testRequest;
        ClassToyDetailREST.ResponseWrapper responseObj = new ClassToyDetailREST.ResponseWrapper();
        Test.startTest();
        responseObj = ClassToyDetailREST.getToyDetails();
        Test.stopTest();
        System.assertEquals(responseObj.statusCode, 200);
   }
    /*Method to test negative scenario where Toys are not found*/
    @isTest
	static void  getToyDetailsNegativeTest(){
        ClassToyDetailREST.RequestWrapper testToys = new ClassToyDetailREST.RequestWrapper();
        testToys.toyNames = new List<String>{'Not Found'};
        String testRequestString = JSON.serialize(testToys);
        RestRequest testRequest = new RestRequest(); 
        RestResponse testResponse = new RestResponse();
    	testRequest.requestURI = '/services/apexrest/ToyDetail/';  //Request URL
        testRequest.httpMethod = 'POST';//HTTP Request Type
        testRequest.requestBody = Blob.valueof(testRequestString);
        RestContext.request = testRequest;
        ClassToyDetailREST.ResponseWrapper responseObj = new ClassToyDetailREST.ResponseWrapper();
        Test.startTest();
        responseObj = ClassToyDetailREST.getToyDetails();
        Test.stopTest();
        System.assertEquals(responseObj.statusCode, 400);
   }
}