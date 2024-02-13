@isTest(seeAllData=true)
private class OpportunityAfterUpdateTest {

    static testMethod void testTrigger() {
    	
    	TestUtil tu = new TestUtil();
    	
    	User l_owner = tu.getUsers( 1, '' )[ 0 ];
        insert l_owner;
    	
    	list<Account> accounts = tu.getAccounts(1, 'Business Account', String.valueOf(l_owner.Id));
    	insert accounts[0]; 
    	
    	list<Contact> contacts = tu.getContacts(1, String.valueOf(accounts[0].Id)); 
    	contacts[0].Client_Builder_Lead_ID__c = 'CBL-ID-01'; 
    	insert contacts;
    	
    	list<Opportunity> opps = tu.getOpportunities(1, String.valueOf(accounts[0].Id), String.valueOf(l_owner.Id));
    	insert opps;
    	
    	List<OpportunityContactRole> roles = tu.getOpportunityContactRoles(1, String.valueOf(opps[0].Id), String.valueOf(contacts[0].Id), 'Participant');
    	insert roles;
            	
    	Pricebook2 pbk1 = [select Id, IsActive from Pricebook2 where IsStandard = true];
    	
    	if(!pbk1.IsActive) {
    		pbk1.IsActive = true;
    		update pbk1;
    	}

		Product2 prd1 = new Product2 (Name='Test Product Entry 1', Description='Test Product Entry 1');
		insert prd1;

		PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=pbk1.id,UnitPrice=50, IsActive = true);
		insert pbe1;

		OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID = opps[0].Id, PriceBookEntryID = pbe1.id, Quantity= 2, TotalPrice = 100);
		insert lineItem1;
        
        List<Lead> leads = tu.getLeads(1, '', String.valueOf(contacts[0].Id));

        List<Id> lead_ids = new List<Id>();
        for(Lead l : leads) {
            lead_ids.add(l.id);
        }
		
    	// This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl(String.valueOf(contacts[0].Id)));
        
        ClientBuilderWSInterface.updateParticipantFromContact(contacts[0].Id);
        ClientBuilderWSInterface.updateLeadFromLead(lead_ids);
        
        Test.startTest();
			opps[0].StageName = 'Closed Won';
			update opps[0];
		Test.stopTest();
		/*
			opp.Description='123';
			update opp;
		*/
    }
}