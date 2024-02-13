/**
 * trac_SFMCSyncServiceTest
 * @description Tests trac_SFMCSyncQueueable, trac_SFMCSyncService
 *
 * @author Zi Zhang, Traction on Demand
 * @date 6/28/2019
 */
@isTest
public with sharing class trac_SFMCSyncServiceTest {
    public static Contact testContact1, testContact2;

    static {
        List<Contact> testContacts = new List<Contact>();
        testContact1 = new Contact(FirstName='Traction', LastName='Test', Email='test@tractionondemand.com');
        testContact2 = new Contact(FirstName='Traction', LastName='Test', Email='test@tractionondemand.com');
        testContacts.add(testContact1);
        testContacts.add(testContact2);

        insert testContacts;

    }

    @isTest
    public static void testDeleteContactSync() {
        Test.setMock(HttpCalloutMock.class, new trac_SFMCSyncMockResponse(false, false, false));

        Test.startTest();
        delete testContact1;
        Test.stopTest();

        List<Contact> results = [SELECT Id FROM Contact WHERE Id = :testContact1.Id];

        System.assertEquals(0, results.size(), 'Test Contact still exists.');
    }

    @isTest
    public static void testDeleteContactSync_AuthError() {
        Test.setMock(HttpCalloutMock.class, new trac_SFMCSyncMockResponse(true, true, false));

        Test.startTest();
        delete testContact1;
        Test.stopTest();

        List<Contact> results = [SELECT Id FROM Contact WHERE Id = :testContact1.Id];

        System.assertEquals(0, results.size(), 'Test Contact still exists.');
    }

    @isTest
    public static void testDeleteContactSync_AuthException() {
        Test.setMock(HttpCalloutMock.class, new trac_SFMCSyncMockResponse(true, false, true));

        Test.startTest();
        delete testContact1;
        Test.stopTest();

        List<Contact> results = [SELECT Id FROM Contact WHERE Id = :testContact1.Id];

        System.assertEquals(0, results.size(), 'Test Contact still exists.');
    }

    @isTest
    public static void testDeleteContactSync_SyncException() {
        Test.setMock(HttpCalloutMock.class, new trac_SFMCSyncMockResponse(false, false, true));

        Test.startTest();
        delete testContact1;
        Test.stopTest();

        List<Contact> results = [SELECT Id FROM Contact WHERE Id = :testContact1.Id];

        System.assertEquals(0, results.size(), 'Test Contact still exists.');
    }

    @isTest
    public static void testMergeContactSync() {
        Test.setMock(HttpCalloutMock.class, new trac_SFMCSyncMockResponse(false, false, false));

        Test.startTest();

        merge testContact1 testContact2;

        Test.stopTest();

        List<Contact> results = [SELECT Id FROM Contact WHERE Id = :testContact2.Id];

        System.assertEquals(0, results.size(), 'Test Contact still exists.');
    }
}