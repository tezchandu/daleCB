@isTest
private class OpportunityContactRoleTrgHandlerTest {
	static testMethod void myUnitTest() {
        
        //can handle 200; set to 10 so tests run faster.
        Integer NUM_CREATE = 10;
        
        TestUtil tu = new TestUtil();
        
        User l_owner = tu.getUsers( 1, 'Franchise Admin' )[ 0 ];
        insert l_owner;
        
        list<Account> accounts = tu.getAccounts(1, 'New York Franchise', String.valueOf(l_owner.Id));
        insert accounts[0]; 
        
        list<Contact> contacts = tu.getContacts(2, String.valueOf(accounts[0].Id)); 
        contacts[0].Client_Builder_Lead_ID__c = 'CBL-ID-01'; 
        insert contacts;
        
        Contact primaryContact = contacts[0];
        Contact otherContact = contacts[1];
        
        list<Opportunity> opps = tu.getOpportunities(NUM_CREATE, String.valueOf(accounts[0].Id), String.valueOf(l_owner.Id));
        insert opps;
        
        //for each opp - create a contact role... one primary, one other
        Test.startTest();
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        List<OpportunityContactRole> ocrList_Primary = new List<OpportunityContactRole>();
        List<OpportunityContactRole> ocrList_Other = new List<OpportunityContactRole>();
        for(Opportunity opp : opps) {
            OpportunityContactRole ocr1 = new OpportunityContactRole();
            ocr1.OpportunityId = opp.Id;
            ocr1.IsPrimary = true;
            ocr1.ContactId = primaryContact.Id;
            ocrList_Primary.add(ocr1);
            
            OpportunityContactRole ocr2 = new OpportunityContactRole();
            ocr2.OpportunityId = opp.Id;
            ocr2.IsPrimary = false;
            ocr2.ContactId = otherContact.Id;
            ocrList_Other.add(ocr2);
        }
        ocrList.addAll(ocrList_Primary);
        ocrList.addAll(ocrList_Other);
        insert ocrList;
        Test.stopTest();
        
        //Now - confirm that each opp has their numbers set correctly
        for(Opportunity opp : [SELECT Id, of_Contact_Roles__c, of_Primary_Contact_Roles__c
                              	FROM Opportunity WHERE Id IN :opps]) {
        	System.assertEquals(1, opp.of_Primary_Contact_Roles__c);
        	System.assertEquals(2, opp.of_Contact_Roles__c);
        }
        
        //now delete the primaries and check again...
        //since there is only ONE other contact - it should default to Primary
        delete ocrList_Primary;
        for(Opportunity opp : [SELECT Id, of_Contact_Roles__c, of_Primary_Contact_Roles__c
                              	FROM Opportunity WHERE Id IN :opps]) {
        	System.assertEquals(1, opp.of_Primary_Contact_Roles__c);
        	System.assertEquals(1, opp.of_Contact_Roles__c);
        }
        
    }
    
}