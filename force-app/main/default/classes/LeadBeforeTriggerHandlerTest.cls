@isTest
private class LeadBeforeTriggerHandlerTest {

    static testMethod void testLeadCurrencyIsoCode() {
        TestUtil testUtil = new TestUtil();
        User u = testUtil.getUsers(1, null)[0];
        u.DefaultCurrencyIsoCode = 'GBP';
        Insert u;
        
        List<Lead> leads = testUtil.getLeads(2, 'S', u.Id);
        
        Test.startTest();
            insert leads;
        Test.stopTest();

        List<Lead> insertedLeads = [Select l.CurrencyIsoCode From Lead l Where l.Id IN :leads];
        for (Lead l : insertedLeads) {
            //System.assertEquals(u.DefaultCurrencyIsoCode , l.CurrencyIsoCode);
        }
    }

    static testMethod void testSetSupervisorName() {
        TestUtil testUtil = new TestUtil();
        User u = testUtil.getUsers(1, null)[0];
        u.DefaultCurrencyIsoCode = 'GBP';
        Insert u;
        
        List<Lead> leads = testUtil.getLeads(2, 'S', u.Id);     // Create a test lead.
        System.assertEquals(2, leads.size(), 'Failed to initialize test leads for testSetSupervisorName');

        // Set supervisor first & last name in first lead.
        leads[0].Supervisor_FirstName__c = 'ABC';
        leads[0].Supervisor_LastName__c = 'XYZ';
        leads[0].Supervisor_Name__c = '';

        // Set supervisor name in second lead.
        leads[1].Supervisor_FirstName__c = '';
        leads[1].Supervisor_LastName__c = '';
        leads[1].Supervisor_Name__c = 'ABC2 XYZ2';    

        Test.startTest();
            insert leads;
        Test.stopTest();

        // Reselect from database and perform asserts.
        List<Lead> insertedLeads = [Select Supervisor_Name__c, Supervisor_FirstName__c,  Supervisor_LastName__c From Lead Where Id IN :leads];
        //System.assertEquals('ABC XYZ' , insertedLeads[0].Supervisor_Name__c, 'Lead #1: Unable to set corrrect value for Supervisor Name.');
        //System.assertEquals('ABC2' , insertedLeads[1].Supervisor_FirstName__c, 'Lead #2: Unable to set corrrect value for Supervisor First Name.');
        //System.assertEquals('XYZ2' , insertedLeads[1].Supervisor_LastName__c, 'Lead #2: Unable to set corrrect value for Supervisor Last Name.');
    }
}