public without sharing class LeadAfterTriggerHandler {
	
	public static Boolean RUN_ONCE = true;

	public static void processConvertedContacts (List<Lead> nLeads, Map<Id, Lead> oldMap) {
		
		if (!RUN_ONCE) return;		// Only run once.
		
		Set<Id> contactIds = new Set<Id>();
		for (Lead l : nLeads) {
			if ( (l.IsConverted == true) && (l.ConvertedContactId != oldMap.get(l.Id).ConvertedContactId) ) {
				contactIds.add(l.ConvertedContactId);
			}
		}
		System.debug('---> contactIds: ' + contactIds);
		
		List<Contact> nContacts = [Select c.LastName,
										  c.Supervisor_Title__c, 
										  c.Supervisor_Phone__c, 
										  c.Supervisor_Name__c,
										  c.Supervisor_FirstName__c,
										  c.Supervisor_LastName__c,
										  c.Supervisor_Email__c, 
										  c.ReportsToId, 
										  c.CurrencyIsoCode, 
										  c.AccountId,
										  c.OwnerId
								   From Contact c
								   Where c.Id in :contactIds and Supervisor_Email__c != null]; 
		
		if (!nContacts.isEmpty())
		 {
		
			Map<String, Contact> supEmailToContact = new Map<String, Contact>();
			for (Contact c : nContacts) {
				supEmailToContact.put(c.Supervisor_Email__c, c);
			}
			
			List<Contact> existingContacts = [	Select 	Email, 
														Supervisor_Title__c, 
														Supervisor_Phone__c, 
														Supervisor_Name__c,
														Supervisor_FirstName__c,
														Supervisor_LastName__c,
														Supervisor_Email__c, 
														CurrencyIsoCode, 
														AccountId 
											  From Contact
											  Where Email in :supEmailToContact.keySet() and Id not in :nContacts];
			
			System.debug('---> existingContacts: ' + existingContacts);
			
			Map<String, Contact> EmailToContactMap = new Map<String, Contact>();
			
			if (!existingContacts.isEmpty()) {
				for (Contact c : existingContacts) {
					EmailToContactMap.put(c.Email, c);
				}
			}
			
			List<Contact> newContacts = new List<Contact>();
			for (Contact c : nContacts) {
				if (EmailToContactMap.get(c.Supervisor_Email__c) == NULL) {

					String lsSupervisorLastName = getSupervisorLastName(c);	// Get last name of supervisor.
					
					Contact newContact = new Contact(FirstName = (String.isEmpty(c.Supervisor_FirstName__c) ? '' : c.Supervisor_FirstName__c), 
													 LastName = (String.isEmpty(lsSupervisorLastName) ? c.LastName + '\'s Supervisor' : lsSupervisorLastName),
													 AccountId = c.AccountId, OwnerId = c.OwnerId ,
													 CurrencyIsoCode = c.CurrencyIsoCode,
													 Email = c.Supervisor_Email__c,
													 Phone = c.Supervisor_Phone__c,
													 Title = c.Supervisor_Title__c,
												 	 Is_System_Generated__c = true);
					newContacts.add(newContact);
					EmailToContactMap.put(newContact.Email, newContact);
				}
			}
			System.debug('MA: newContacts: ' + newContacts);
			
			// Create supervisor contacats.
			if (!newContacts.isEmpty()) {
				try {
					insert newContacts;				    
				}
				catch (System.DmlException e) {
					System.debug('Database Error: Unable to create supervisor contacts.');
				    for (Integer i = 0; i < e.getNumDml(); i++) {
				        // Process exception here 
				        System.debug(e.getDmlMessage(i)); 
					}
				}
			}
			
			for (Contact c : nContacts) {
				if (EmailToContactMap.get(c.Supervisor_Email__c) != NULL) {
					c.ReportsToId = EmailToContactMap.get(c.Supervisor_Email__c).Id;
				}
			}
			
			// Update supervisor contacts.
			try {
				update nContacts; 
			}
			catch (System.DmlException e) {
				System.debug('Database Error: Unable to update supervisor contacts.');
			    for (Integer i = 0; i < e.getNumDml(); i++) {
			        // Process exception here 
			        System.debug(e.getDmlMessage(i)); 
				}
			}
			
		} // END: if (!nContacts.isEmpty())
		else {

			// CREATE CONTACTS FOR SUPPERVISOR WHICH DO NOT HAVE ANY EMAIL
			// IN SUPERVISOR INFORMATION SECTION.

			List<Contact> originalContacts = [	SELECT Id, LastName,
													Supervisor_Name__c, Supervisor_FirstName__c, Supervisor_LastName__c,
													Supervisor_Phone__c, Supervisor_Title__c,
													AccountId, CurrencyIsoCode
												FROM Contact WHERE Id IN :contactIds];

			Map<String, Contact> NoEmailToManagerContactMap = new Map<String, Contact>();
			
			String lsSupervisorInfo ;		// Variable to to hold data from all fields.

			for (Contact c : originalContacts) {
				
				lsSupervisorInfo = getSupervisorInfo(c);	// Get supervisor info.

				// Only add to map when there is any of the Supervison Information available except email.
				if ( !String.isEmpty(lsSupervisorInfo) ){
					
					String lsSupervisorLastName = getSupervisorLastName(c);	// Get last name of supervisor.
					
					Contact newContact = new Contact(FirstName = (String.isEmpty(c.Supervisor_FirstName__c) ? '' : c.Supervisor_FirstName__c), 
													 LastName = (String.isEmpty(lsSupervisorLastName) ? c.LastName + '\'s Supervisor' : lsSupervisorLastName),
													 AccountId = c.AccountId,
													 CurrencyIsoCode = c.CurrencyIsoCode,
													 Phone = c.Supervisor_Phone__c,
													 Title = c.Supervisor_Title__c,
													 Is_System_Generated__c = true);
					NoEmailToManagerContactMap.put(lsSupervisorInfo, newContact);
				}
			}

			// Insert supervisor contacts without email.
			if (!NoEmailToManagerContactMap.isEmpty()) {
				try {

					insert NoEmailToManagerContactMap.values();		    
				}
				catch (System.DmlException e) {
					System.debug('Database Error: Unable to insert supervisor data without email.');
				    for (Integer i = 0; i < e.getNumDml(); i++) {
				        // Process exception here 
				        System.debug(e.getDmlMessage(i)); 
					}
				}
			}

			Boolean lbDoUpdate = false;

			for (Contact c : originalContacts) {	
				lsSupervisorInfo = getSupervisorInfo(c);	// Get supervisor info.

				// Only try to set Reports To when there is any supervisor information.
				if ( NoEmailToManagerContactMap.get(lsSupervisorInfo) != null ) {
					c.ReportsToId = NoEmailToManagerContactMap.get(lsSupervisorInfo).Id;
					lbDoUpdate = true;
				}
			}

			// Update supervisor contacts without email.
			if (lbDoUpdate) {
				try {
					update originalContacts;		    
				}
				catch (System.DmlException e) {
					System.debug('Database Error: Unable to update supervisor contact without email.');
				    for (Integer i = 0; i < e.getNumDml(); i++) {
				        // Process exception here 
				        System.debug(e.getDmlMessage(i)); 
					}
				}
			}
		}

		RUN_ONCE = Test.isRunningTest();
	}

	private static String getSupervisorInfo (Contact c) {
		String lsSupervisorInfo ;		// Variable to to hold data from all fields.

		lsSupervisorInfo = String.isEmpty(c.Supervisor_Title__c) ? '' : c.Supervisor_Title__c;	
		lsSupervisorInfo += String.isEmpty(c.Supervisor_Name__c) ? '' : c.Supervisor_Name__c;
		lsSupervisorInfo += String.isEmpty(c.Supervisor_Phone__c) ? '' : c.Supervisor_Phone__c;

		return lsSupervisorInfo;
	}

	private static String getSupervisorLastName (Contact c) {
		String lsSupervisorLastName ;		// Variable to to hold data from all fields.

		if (String.isBlank(c.Supervisor_FirstName__c) && String.isBlank(c.Supervisor_LastName__c))
			lsSupervisorLastName = 	String.isEmpty(c.Supervisor_Name__c) ? '' : c.Supervisor_Name__c;
		else 
			lsSupervisorLastName =	String.isEmpty(c.Supervisor_LastName__c) ? '' : c.Supervisor_LastName__c;

		return lsSupervisorLastName;
	}
}