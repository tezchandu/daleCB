/*******************************************************************************
 * Test class for the TriggerContactSource class and the triggers that
 * operate on it
 *
 * @Author: Magnet 360
 * @Date: 11/21/2013
 */

@isTest( SeeAllData=false )
private class 
TriggerContactSourceTest 
{

/*******************************************************************************
 * Test inserting a Contact Source record and sending out the notification email 
 */
    static testMethod 
    void 
    contactSourceNotificationTest() 
    {
        System.debug( 'START: TriggerContactSourceTest.contactSourceNotificationTest()' );
        
        TestUtil l_tu = new TestUtil();
        
                                                 // Create an Account for the
                                                 // Contact
        Account l_account = l_tu.getAccounts( 1, '', UserInfo.getUserId() )[ 0 ];
        insert l_account;
        
                                                 // Create a Contact Record
        Contact l_contact = l_tu.getContacts( 1, l_account.Id )[ 0 ];
        insert l_contact;
        
                                                 // Get 2 Contact sources. One to be
                                                 // insert by the default user,
                                                 // the second by another user
                                                 // When the second Contact Source 
                                                 // is inserted
                                                 // it should trigger the email
                                                 // notification to be sent to
                                                 // the Contact owner.
        List<Contact_Source_Detail__c> l_contact_sources = l_tu.getContactSources( 2, l_contact.Id );
        insert l_contact_sources[ 0 ];
        
        User l_alternate_user = l_tu.getUsers( 1, 'System Administrator' )[ 0 ];
        insert l_alternate_user;
        
        TriggerContactSource TCS = new TriggerContactSource(); // Default constructor
        
        Test.startTest();
        
        System.runAs( l_alternate_user )
        {
            l_contact_sources[ 1 ].OwnerId = l_alternate_user.Id;
            insert l_contact_sources[ 1 ];
        }
        
        Test.stopTest();
        
        System.assert( [ SELECT Id 
                         FROM Contact_Source_Detail__c 
                         WHERE Contact__c = :l_contact.Id ].size() >= 1 );  
        
        System.debug( 'END: TriggerContactSourceTest.contactSourceNotificationTest()' );
    }

    /*******************************************************************************
     * Test inserting a Contact Source record and updating the Contact source fields on 
     * associated Contact.  
     */

    static testmethod void updateFirstContactSourceInfoTest() {

        TestUtil tu = new TestUtil();
        
        // Create an Account for the Contact
        Account testAccount = tu.getAccounts( 1, '', UserInfo.getUserId() )[ 0 ];
        insert testAccount;
        
        // Create a Contact Record
        Contact testContact = tu.getContacts( 1, testAccount.Id )[ 0 ];
        insert testContact;
        
        // Get two contact sources inserted for the default user, it should trigger 
        // logic to update contact source information fields on associated contacts.
        List<Contact_Source_Detail__c> sources = tu.getContactSources( 2, testContact.Id );

        // Add Contact source information.
        sources[0].UTM_Campaign__c = 'TEST CAMPAIGN';
        sources[0].UTM_Content__c = 'TEST CONTENT';
        sources[0].UTM_Medium__c = 'TEST MEDIUM';
        sources[0].UTM_Source__c = 'TEST SOURCE';
        sources[0].UTM_Term__c = 'TEST TERM';

        sources[1].UTM_Campaign__c = 'XXX';
        sources[1].UTM_Content__c = 'XXX';
        sources[1].UTM_Medium__c = 'XXX';
        sources[1].UTM_Source__c = 'XXX';
        sources[1].UTM_Term__c = 'XXX';

        Test.startTest();
        insert sources;
        Test.stopTest();

        Contact afterTestContact = [
            SELECT
                Name,
                UTM_Campaign__c,
                UTM_Content__c,
                UTM_Medium__c,
                UTM_Source__c,
                UTM_Term__c
            FROM Contact
            WHERE Id = :testContact.Id
            LIMIT 1];

        System.assertEquals('TEST CAMPAIGN', afterTestContact.UTM_Campaign__c);
        System.assertEquals('TEST CONTENT', afterTestContact.UTM_Content__c);
        System.assertEquals('TEST MEDIUM', afterTestContact.UTM_Medium__c);
        System.assertEquals('TEST SOURCE', afterTestContact.UTM_Source__c);
        System.assertEquals('TEST TERM', afterTestContact.UTM_Term__c);
    }

    static testMethod void updateLastContactSourceInfoTest() 
    {
        System.debug( 'START: TriggerContactSourceTest.updateLastContactSourceInfoTest()' );
        
        TestUtil l_tu = new TestUtil();
        
        // Create an Account for the Contact
        Account l_account = l_tu.getAccounts( 1, '', UserInfo.getUserId() )[ 0 ];
        insert l_account;
        
        // Create a Contact Record
        Contact l_contact = l_tu.getContacts( 1, l_account.Id )[ 0 ];
        insert l_contact;
        
        // Get a contact source inserted for the default user, it should trigger 
        // logic to update contact source information fields on associated contact.
        List<Contact_Source_Detail__c> l_contact_sources = l_tu.getContactSources( 1, l_contact.Id );

        // Add Contact source information.
        l_contact_sources[0].Name = 'ABC';              // Contact source name.
        l_contact_sources[0].Program_Code__c = 'XYZ';   // Contact source programe name.
        l_contact_sources[0].Key_Code__c = '123';       // Contact source key code.
        
        TriggerContactSource TCS = new TriggerContactSource(); // Default constructor
        
        Test.startTest();
        
        insert l_contact_sources[ 0 ];                 // Trigger updateLastContactSourceInfo()
        
        Test.stopTest();

        List<Contact> l_contacts = [SELECT  Id, 
                                            Last_Contact_Source_Name__c, Last_Contact_Source_Program_Code__c, Last_Contact_Source_Key_Code__c
                                    FROM    Contact
                                    WHERE   Id = :l_contact.Id LIMIT 1];

        System.assertEquals('ABC', l_contacts[0].Last_Contact_Source_Name__c);
        System.assertEquals('XYZ', l_contacts[0].Last_Contact_Source_Program_Code__c);
        System.assertEquals('123', l_contacts[0].Last_Contact_Source_Key_Code__c);
        
        System.debug( 'END: TriggerContactSourceTest.updateLastContactSourceInfoTest()' );
    }
}// /END Class