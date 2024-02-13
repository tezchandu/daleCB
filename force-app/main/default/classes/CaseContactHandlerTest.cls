@isTest
public with sharing class CaseContactHandlerTest {
    @isTest(SeeAllData=true)
    private static void fetchContactTest() {
        TestUtil newTestUtil = new TestUtil();
        User u = [SELECT ID FROM User where isActive = true AND Franchise_Id__c = 'Franchising' LIMIT 1];
		System.debug(u.Id);
        
        Account a = newTestUtil.getAccounts(1,null,u.Id)[0];
        insert a;
        System.debug('account123 ' + a.Id);

        Contact c = [SELECT Id, Name, Email, FirstName, LastName, Franchise_Id__c From Contact WHERE Franchise_Id__c = 'Franchising' LIMIT 1];        
        System.debug('contact123 ' + c.Id);

        Case newCase = newTestUtil.getCases(1, a.Id, null)[0];
        newCase.SuppliedEmail = c.Email;
        newCase.SuppliedName = c.FirstName + ' ' + c.LastName;
        insert newCase;

        System.debug('newCase123 ' + newCase.Id);

        Map<Id,Id> resultMap = CaseContactHandler.fetchExistingCaseContacts(new Map<String, Id> {c.Email => newCase.Id});

        System.assert(resultMap.get(newCase.Id) == c.Id, 'Unexpected resuldContactId. ' + resultMap + ' ' + c.Id);
    }

    @isTest
    private static void testCreateNewContact() {
        /* TestUtil newTestUtil = new TestUtil(); */

        /* User u = newTestUtil.getUsers(1, 'Standard User')[0]; */
        /* u.Franchise_Id__c = 'Franchising'; */
        /* insert u; */

        /* Account a = newTestUtil.getAccounts(1,null,u.Id)[0]; */
        /* insert a; */
        
        Contact resultContact = CaseContactHandler.createNewContact(new List<CaseContactInfo> { new CaseContactInfo('Testy McTesterson', 'testy@test.com') })[0];
        System.assertEquals('Testy', resultContact.FirstName, 'Unexpected Contact FirstName');
        System.assertEquals('McTesterson', resultContact.LastName, 'Unexpected Contact LastName');
        System.assertEquals('testy@test.com', resultContact.Email, 'Unexpected Contact Email');
    }

    @isTest
    private static void testEmailTriggerHandler() {
        TestUtil newTestUtil = new TestUtil();
        User u = newTestUtil.getUsers(1, 'Standard User')[0];
        u.Franchise_Id__c = 'Franchising';
        insert u;

        Account a = newTestUtil.getAccounts(1,null,u.Id)[0];
        insert a;

        Case newCase = newTestUtil.getCases(1, a.Id, null)[0];
        insert newCase;

        EmailMessage em = new EmailMessage();
        em.FromAddress = 'test@gmail.com';
        em.Subject = 'Test Subject';
        em.FromName = 'Tester Testy';
        em.TextBody = '42';
        em.ParentId = newCase.Id;

        insert em;

        List<Contact> resultContact = [SELECT Id, Name FROM Contact];
        System.debug('resultContact123: ' + resultContact);
        System.assertEquals(1, resultContact.size(), 'Unexpected number of contacts created');
    }

    @isTest
    private static void testMultipleContacts() {
        TestUtil newTestUtil = new TestUtil();

        User u = [SELECT ID FROM User where isActive = true AND Franchise_Id__c = 'Franchising' LIMIT 1];

        List<Account> a = newTestUtil.getAccounts(2,null,u.Id);
        a[0].Status__c = 'Active';
        /* a[1].Status__c = 'Inactive'; */

        insert a;
        
        a[1].Status__c = 'Inactive';
        update a[1];


        Account resultAccount0 = [SELECT ID, Franchise_Id__c, Status__c FROM Account WHERE Id = :a[0].Id];
        Account resultAccount1 = [SELECT ID, Franchise_Id__c, Status__c FROM Account WHERE Id = :a[1].Id];
        System.assert(resultAccount0.Status__c == 'Active');
        System.assert(resultAccount1.Status__c == 'Inactive');

        List<Contact> testContacts = new List<Contact> { new Contact(), new Contact() };
        testContacts[0].Email = 'test@gmail.com';
        testContacts[0].LastName = 'Last';
        testContacts[0].Contact_Status__c = 'Active';
        testContacts[0].AccountId = a[0].Id;
        testContacts[0].OwnerId = u.Id;
        testContacts[1].Email = 'test@gmail.com';
        testContacts[1].LastName = 'Last';
        testContacts[1].Contact_Status__c = 'Inactive';
        testContacts[1].AccountId = a[1].Id;
        testContacts[1].OwnerId = u.Id;

        insert testContacts;
        Contact resultContact0 = [SELECT id, Franchise_Id__c, Contact_Status__c, Account.Status__c FROM Contact WHERE Id = :testContacts[0].Id];
        Contact resultContact1 = [SELECT id, Franchise_Id__c, Contact_Status__c, Account.Status__c FROM Contact WHERE Id = :testContacts[1].Id];
        System.assert(resultContact0.Contact_Status__c == 'Active');
        System.assert(resultContact1.Contact_Status__c == 'Inactive');
        System.assert(resultContact0.Account.Status__c == 'Active');
        System.assert(resultContact1.Account.Status__c == 'Inactive');
        
        Case c = newTestUtil.getCases(1,a[0].Id,u.Id)[0];
        c.SuppliedEmail = 'test@gmail.com';
        c.SuppliedName = 'Last';
        insert c;

        Case resultCase = [SELECT Id, ContactId FROM Case WHERE Id = :c.Id];

        System.assertEquals(testContacts[0].Id, resultCase.ContactId, 'Unexpected Contact attached to case.' );
    }
}