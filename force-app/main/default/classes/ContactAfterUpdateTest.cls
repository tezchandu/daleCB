@isTest
private class ContactAfterUpdateTest {

    static testMethod void testTrigger() {
        TestUtil tu = new TestUtil();
    	
    	User l_owner = tu.getUsers( 1, '' )[ 0 ];
        insert l_owner;
    	
    	list<Account> accounts = tu.getAccounts(1, 'New York Franchise', String.valueOf(l_owner.Id));
    	insert accounts[0]; 
    	
    	list<Contact> contacts = tu.getContacts(1, String.valueOf(accounts[0].Id)); 
    	contacts[0].Client_Builder_ID__c = '56123'; 
    	insert contacts;
    	
    	// This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ParticipantWebServiceMockImpl(String.valueOf(contacts[0].Id)));
        Test.startTest();
			contacts[0].LastName = 'New Last Name';
			update contacts[0];
		Test.stopTest();
    }

    //Tests the syncSupervisorFields method in TriggerContact
//    static testMethod void testTrigger2() {
//        TestUtil tu = new TestUtil();
//
//        User l_owner = tu.getUsers( 1, '' )[ 0 ];
//        insert l_owner;
//
//        list<Account> accounts = tu.getAccounts(1, 'New York Franchise', String.valueOf(l_owner.Id));
//        insert accounts[0];
//
//        list<Contact> contacts = tu.getContacts(2, String.valueOf(accounts[0].Id));
//        Contact supervisor = contacts[0];
//        insert supervisor;
//
//        Contact employee = contacts[1];
//        employee.ReportsToId = supervisor.Id;
//        insert employee;
//
//        Test.startTest();
//            supervisor.Title = 'New Title';
//            supervisor.FirstName = 'NewFirstName';
//            supervisor.LastName = 'NewLastName';
//            update supervisor;
//        Test.stopTest();
//
//        employee = [SELECT Id, Supervisor_Title__c, Supervisor_Name__c FROM Contact WHERE Id = :employee.Id];
//        System.assertEquals(supervisor.Title, employee.Supervisor_Title__c);
//        System.assertEquals(supervisor.FirstName + ' ' + supervisor.LastName, employee.Supervisor_Name__c);
//    }
}