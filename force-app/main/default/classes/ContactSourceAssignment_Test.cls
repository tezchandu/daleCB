/******************************************************************************
 * Tests against the ContactSourceAssignment & ContactSourceAssignment_Batch
 *
 * @Author:			Abdul Sattar (Magnet360)
 * @Date: 			2015-04-28
 */
@isTest(seeAllData=TRUE)
private class ContactSourceAssignment_Test {
	private static Integer NUM_OF_RECORDS = 5;			// Number of records to test

	// List of test OCRS
	private static List<Opportunity> opps = new List<Opportunity>();
	
	private static Contact PRIMARY_CONTACT;																// Test primary contact
	private static String LAST_CSK_CODE = 'LCSK-ID-01';		// Test contact source key code

	private static testMethod void testContactSourceAssignments_Batch() {
		// Create test data
		setupData();

		Test.startTest();
			ContactSourceAssignment_Batch batchClass = new ContactSourceAssignment_Batch(); 
			Database.ExecuteBatch(batchClass, 200);
		Test.stopTest();

		// Re-select data and perform assertions
		List<Opportunity> updatedOpps = [SELECT Id, Primary_Contact__c, Primary_Contact_Last_Source_Key_Code__c 
																			FROM 	Opportunity 
																			WHERE Id IN :opps];
		for (Opportunity o: updatedOpps) {
			System.assertEquals(PRIMARY_CONTACT.Id, o.Primary_Contact__c, 'Incorrect value for Primary Contact.');
			System.assertEquals(LAST_CSK_CODE, o.Primary_Contact_Last_Source_Key_Code__c, 'Incorrect value for Last Contact Source Key Code.');
		}
	}	// END: testContactSourceAssignments_Batch
	
	private static void setupData() {
		// Create test custom settings
		ContactSourceAssignmentBatch__c cs = ContactSourceAssignmentBatch__c.getOrgDefaults();
		System.assert(cs != NULL, 'Unable to get custom settings.');
		
		// Create test opportunities
		TestUtil tu = new TestUtil();
		User u = tu.getUsers(1, null)[0];
			// u.DefaultCurrencyIsoCode = 'GBP';
		INSERT u;
		System.assert(u.Id != NULL, 'Unable to create test user');
		
		Account account = tu.getAccounts(2, null, u.Id)[0];
		INSERT account;
		System.assert(account.Id != NULL, 'Unable to create test account');
		
		List<Contact> contacts = tu.getContacts(1, String.valueOf(account.Id)); 
				contacts[0].Client_Builder_Lead_ID__c = 'CBL-ID-01';
				contacts[0].Last_Contact_Source_Key_Code__c = LAST_CSK_CODE;
		INSERT contacts;
		System.assert(contacts[0].Id != NULL, 'Unable to create test contact.');
		PRIMARY_CONTACT = contacts[0];

		Pricebook2 pbk1 = [select Id, IsActive from Pricebook2 where IsStandard = true];
				
		if(!pbk1.IsActive) {
				pbk1.IsActive = true;
				UPDATE pbk1;
		}

		Product2 prd1 = new Product2 (Name='Test Product Entry 1', Description='Test Product Entry 1');
		INSERT prd1;
		System.assert(prd1.Id != NULL, 'Uable to create test Product.');

		PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=pbk1.id,UnitPrice=50, IsActive = true);
		INSERT pbe1;
		System.assert(pbe1.Id != NULL, 'Uable to create test Price Book.');
		
		opps = tu.getOpportunities(NUM_OF_RECORDS, String.valueOf(account.Id), String.valueOf(u.Id));
		INSERT opps;
		System.assert(opps[0].Id != NULL, 'Uable to create test opportunities.');
		
		// Create contact roles & line items for each opportunity
		List<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
		List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
		for (Opportunity o : opps) {
			OpportunityContactRole ocr = new OpportunityContactRole( IsPrimary = TRUE
																															,Role = 'Participant'
																															,ContactId = PRIMARY_CONTACT.Id
																															,OpportunityId = o.Id );
			ocrs.add(ocr);

			OpportunityLineItem oli = new OpportunityLineItem( 
																								 OpportunityID = o.Id
																								,PriceBookEntryID = pbe1.Id
																								,Quantity= 2
																								,TotalPrice = 100);
			olis.add(oli);
		}
		INSERT ocrs;
		System.assert(ocrs[0].Id != NULL, 'Uable to create test opportunity contact roles.');

		INSERT olis;
		System.assert(olis[0].Id != NULL, 'Uable to create test opportunity line items.');

	}	// END: setupData
} // END: ContactSourceAssignment_Test