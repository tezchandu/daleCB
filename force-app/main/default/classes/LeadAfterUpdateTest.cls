@isTest(seeAllData=false)
private class LeadAfterUpdateTest {

    static testMethod void testSyncLeads() {
        
        TestUtil tu = new TestUtil();
        
        User l_owner = tu.getUsers( 1, '' )[ 0 ];
        insert l_owner;
        system.debug('l_owner  '+l_owner);
        
        
        list<Lead> leads = tu.getLeads( 1 , 'Test' , String.valueOf(l_owner.Id));
        Lead l = leads[0];
        
        list<Account> accounts = tu.getAccounts(1, '', String.valueOf(l_owner.Id));
        insert accounts[0]; 
        
        list<Contact> contacts = tu.getContacts(1, String.valueOf(accounts[0].Id));
        contacts[0].Client_Builder_Lead_ID__c = '56123'; 
        
        insert contacts;
        
        list<Opportunity> opps = tu.getOpportunities(1, String.valueOf(accounts[0].Id), String.valueOf(l_owner.Id));
        insert opps;
        
        List<OpportunityContactRole> roles = tu.getOpportunityContactRoles(1, String.valueOf(opps[0].Id), String.valueOf(contacts[0].Id), 'Participant');
        insert roles;
        
        l.Client_Builder_Lead_ID__c = '56123';
        insert l;
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl(String.valueOf(contacts[0].Id)));

        Test.startTest();
            l.Company = 'new name';
            update l;
        Test.stopTest();
        
    }
   
    static testMethod void testTransferLeadSources() {
        TestUtil l_tu = new TestUtil();
        
                                                 // Create a Lead Record
        Lead l_lead = l_tu.getLeads( 1, 'S', UserInfo.getUserId() )[ 0 ];
        insert l_lead;
        
        List<Lead_Source_Detail__c> l_lead_sources = l_tu.getLeadSources( 2, l_lead.Id );
        insert l_lead_sources[ 0 ];
        system.debug(l_lead);
        Test.startTest();
            insert l_lead_sources[ 1 ];
        
        System.assert( [ SELECT Id 
                         FROM Lead_Source_Detail__c 
                         WHERE Lead__c = :l_lead.Id ].size() == 2 );  
                         
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l_lead.id);
        lc.setOwnerId(l_lead.ownerId);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        Test.stopTest();
        
        //System.assertEquals([ SELECT Id FROM Contact_Source_Detail__c WHERE Contact__r.Id = :lcr.getContactId() ].size(), 2 );  
    }
}