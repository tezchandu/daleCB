/*******************************************************************************
 * Test class for the TriggerLeadSource class and the triggers that
 * operate on it
 *
 * @Author: Magnet 360
 * @Date: 11/21/2013
 */

@isTest( SeeAllData=false )
private class 
TriggerLeadSourceTest 
{

/*******************************************************************************
 * Test inserting a Lead Source record and sending out the notification email 
 */
    static testMethod 
    void 
    leadSourceNotificationTest() 
    {
        System.debug( 'START: TriggerLeadSourceTest.leadSourceNotificationTest()' );
        
        TestUtil l_tu = new TestUtil();
        
                                                 // Create a Lead Record
        Lead l_lead = l_tu.getLeads( 1, 'S', UserInfo.getUserId() )[ 0 ];
        insert l_lead;
        
                                                 // Get 2 lead sources. One to be
                                                 // insert by the default user,
                                                 // the second by another user
                                                 // When the second lead is inserted
                                                 // it should trigger the email
                                                 // notification to be sent to
                                                 // the lead owner.
        List<Lead_Source_Detail__c> l_lead_sources = l_tu.getLeadSources( 2, l_lead.Id );
        insert l_lead_sources[ 0 ];
        
        User l_alternate_user = l_tu.getUsers( 1, 'System Administrator' )[ 0 ];
        insert l_alternate_user;
        
        TriggerLeadSource TLS = new TriggerLeadSource(); // Default constructor
        
        Test.startTest();
        
        System.runAs( l_alternate_user )
        {
        	insert l_lead_sources[ 1 ];
        }
        
        Test.stopTest();
        
        System.assert( [ SELECT Id 
                         FROM Lead_Source_Detail__c 
                         WHERE Lead__c = :l_lead.Id ].size() >= 1 );  
        
        System.debug( 'END: TriggerLeadSourceTest.leadSourceNotificationTest()' );
    }
    
    /*******************************************************************************
     * Test inserting a Lead Source record and updating the lead source fields on 
     * associated lead.  
     */
    static testMethod void updateLastLeadSourceInfoTest() 
    {
        System.debug( 'START: TriggerLeadSourceTest.updateLastLeadSourceInfoTest()' );
        
        TestUtil l_tu = new TestUtil();
        
        // Create a Lead Record
        Lead l_lead = l_tu.getLeads( 1, 'S', UserInfo.getUserId() )[ 0 ];
        insert l_lead;
        
        // Get a lead source inserted for the default user, it should trigger 
        // logic to update lead source information fields on associated lead.
        List<Lead_Source_Detail__c> l_lead_sources = l_tu.getLeadSources( 1, l_lead.Id );

        // Add lead source information.
        l_lead_sources[0].Name = 'ABC';              // Lead source name.
        l_lead_sources[0].Program_Code__c = 'XYZ';   // Lead source programe name.
        l_lead_sources[0].Key_Code__c = '123';       // Lead source key code.
        
        TriggerLeadSource TLS = new TriggerLeadSource(); // Default constructor
        
        Test.startTest();
        
        insert l_lead_sources[ 0 ];                 // Trigger updateLastLeadSourceInfo()
        
        Test.stopTest();

        List<Lead> l_leads =    [SELECT Id, 
                                        Last_Lead_Source_Name__c, Last_Lead_Source_Program_Code__c, Last_Lead_Source_Key_Code__c 
                                FROM    Lead
                                WHERE   Id = :l_lead.Id LIMIT 1 ];

        System.assertEquals('ABC', l_leads[0].Last_Lead_Source_Name__c);
        System.assertEquals('XYZ', l_leads[0].Last_Lead_Source_Program_Code__c);
        System.assertEquals('123', l_leads[0].Last_Lead_Source_Key_Code__c);
        
        System.debug( 'END: TriggerLeadSourceTest.updateLastLeadSourceInfoTest()' );
    }

    static testmethod void updateFirstLeadSourceInfoTest() {

        TestUtil tu = new TestUtil();
        // Create a Lead 
        Lead testLead = tu.getLeads( 1, 'S', UserInfo.getUserId() )[ 0 ];
        insert testLead;
        
        // Get a lead source inserted for the default user, it should trigger 
        // logic to update lead source information fields on associated lead.
        List<Lead_Source_Detail__c> sources = tu.getLeadSources(1, testLead.Id);

        // Add Contact source information.
        sources[0].UTM_Campaign__c = 'TEST CAMPAIGN';
        sources[0].UTM_Content__c = 'TEST CONTENT';
        sources[0].UTM_Medium__c = 'TEST MEDIUM';
        sources[0].UTM_Source__c = 'TEST SOURCE';
        sources[0].UTM_Term__c = 'TEST TERM';

        Test.startTest();
        insert sources;
        Test.stopTest();

        Lead afterTestLead = [
            SELECT
                Name,
                UTM_Campaign__c,
                UTM_Content__c,
                UTM_Medium__c,
                UTM_Source__c,
                UTM_Term__c
            FROM Lead
            WHERE Id = :testLead.Id
            LIMIT 1];

        System.assertEquals('TEST CAMPAIGN', afterTestLead.UTM_Campaign__c);
        System.assertEquals('TEST CONTENT', afterTestLead.UTM_Content__c);
        System.assertEquals('TEST MEDIUM', afterTestLead.UTM_Medium__c);
        System.assertEquals('TEST SOURCE', afterTestLead.UTM_Source__c);
        System.assertEquals('TEST TERM', afterTestLead.UTM_Term__c);
    }

}// /END Class