@isTest(seeAlldata=false)
private class LeadAfterTriggerHandlerTest {

    static testMethod void myUnitTest() {
        final Integer SIZE = 1;
        
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 0 ; i < SIZE; ++i) {
            accounts.add(new Account(Name='test account ' + i) );   
        }
        insert accounts;
        
        for (Integer i = 0 ; i < SIZE; ++i) {
            Contact c = new Contact(AccountId = accounts.get(i).Id,
                                    LastName = 'test last name ' + i,
                                    CurrencyIsoCode = 'USD',
                                    Email = 'testme' + i + '@emailtest.com'
                                    );
            contacts.add(c);
        }
        
        insert contacts;
        
        TestUtil tu = new TestUtil();
        List<Lead> leads = tu.getLeads(SIZE, 'Test', String.valueOf(UserInfo.getUserId()) );
        
        for (Lead l : leads) {
            l.Supervisor_Email__c = 'testme0@emailtest.com';
            l.Supervisor_Name__c = 'test sup name';
            l.Supervisor_Phone__c = '1234567';
            l.Supervisor_Title__c = 'test title';
        }
        
        insert leads;
        
        Test.startTest();
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leads[0].Id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(true);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        Lead l = [Select ConvertedContactId, ConvertedContact.ReportsToId From Lead Where Id in :leads and IsConverted = true limit 1];
        System.debug('ConvertedContactId: ' + l.ConvertedContactId);
        //System.assertEquals(contacts.get(0).Id, l.ConvertedContact.ReportsToId); 
        
        
        List<Lead> leads2 = tu.getLeads(SIZE, 'TEST', String.valueOf(UserInfo.getUserId()));
        for (Lead l2 : leads2) {
            l2.Supervisor_Email__c = 'testme@emailtest.com';
            l2.Supervisor_Name__c = 'test sup name';
            l2.Supervisor_Phone__c = '1234567';
            l2.Supervisor_Title__c = 'test title';
        }
        insert leads2;
        
        Database.LeadConvert lc2 = new Database.LeadConvert();
        lc2.setLeadId(leads2[0].Id);
        
        LeadStatus convertStatus2 = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc2.setConvertedStatus(convertStatus2.MasterLabel);
        lc2.setDoNotCreateOpportunity(true);
        
        Database.LeadConvertResult lcr2 = Database.convertLead(lc2);
        System.assert(lcr2.isSuccess());
        
        Lead l2 = [Select ConvertedContactId, ConvertedContact.ReportsToId From Lead Where Id in :leads and IsConverted = true limit 1];
        System.debug('ConvertedContactId: ' + l.ConvertedContactId);
        //System.assert(l2.ConvertedContact.ReportsToId != null);
        
        Test.stopTest();
    }
}