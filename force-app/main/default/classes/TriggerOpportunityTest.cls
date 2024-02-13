/**
 * 
 * 3/15/2021 - Updated by James Loghry (Demand Chain) 
 * - Removed SeeAllData dependency and updated to support TriggerOpportunity changes.
 * - Added TestSetup method for creating custom settings
 * - Updated PriceBook logic to use Test.getStandardPricebookEntryId.
 */
@isTest
private class TriggerOpportunityTest {
    
    @testSetup static void methodName() {
        Profile p = [Select  Id From Profile Where Name='System Administrator'];

        Org_Settings__c orgSettings = new Org_Settings__c(
            Contact_Opportunity_Role_Name__c = 'Participant',
            Closed_Won_Alert_Profile_Ids__c = p.Id + ',' + p.Id,
            Opportunity_Won_Email_Template_Name__c = 'Opportunity_Won_Notification',
            Webservice_Username__c = 'Username',
            Webservice_Password__c = 'Password',
         	SetupOwnerId=Userinfo.getUserId()
        );
        insert orgSettings;
    }
    
    static testMethod void myUnitTest() {
        TestUtil tu = new TestUtil();
        
        User l_owner = tu.getUsers( 1, 'Franchise Admin' )[ 0 ];
        insert l_owner;
        
        list<Account> accounts = tu.getAccounts(1, 'Business Account', String.valueOf(l_owner.Id));
        insert accounts[0]; 
        
        list<Contact> contacts = tu.getContacts(1, String.valueOf(accounts[0].Id)); 
        contacts[0].Client_Builder_Lead_ID__c = 'CBL-ID-01'; 
        insert contacts;
        
        list<Opportunity> opps = tu.getOpportunities(1, String.valueOf(accounts[0].Id), String.valueOf(l_owner.Id));
        // opps[0].Franchise_ID__c = '203820';
        insert opps;
        
        List<OpportunityContactRole> roles = tu.getOpportunityContactRoles(1, String.valueOf(opps[0].Id), String.valueOf(contacts[0].Id), 'Participant');
        insert roles;
        
        Product2 prd1 = new Product2 (Name='Test Product Entry 1', Description='Test Product Entry 1');
        insert prd1;

        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2Id=Test.getStandardPricebookId(),UnitPrice=50, IsActive = true);
        insert pbe1;

        OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID = opps[0].Id, PriceBookEntryID = pbe1.id, Quantity= 2, TotalPrice = 100);
        insert lineItem1;

        // This causes a fake response to be generated, and throws an error
        // Test.setMock(WebServiceMock.class, new WebServiceMockImpl(String.valueOf(contacts[0].Id)));
        
        Test.startTest();
        
        opps[0].StageName = 'Closed Won';
        update opps;
        
        Test.stopTest();
    }
    
    static testMethod void testNotif() {
        TestUtil tu = new TestUtil();
        
        User l_owner = tu.getUsers( 1, '' )[ 0 ];
        l_owner.Franchise_ID__c = '203820';
        insert l_owner;
        
        list<Account> accounts = tu.getAccounts(1, 'Business Account', String.valueOf(l_owner.Id));
        insert accounts; 
        
        list<Opportunity> opps = tu.getOpportunities(1, String.valueOf(accounts[0].Id), String.valueOf(l_owner.Id));
        insert opps;
        
        Test.startTest();
            TriggerOpportunity trigger_opp = new TriggerOpportunity();
            List<Id> opp_ids = new List<Id>();
            for (Opportunity opp : opps) {
                opp_ids.add(opp.Id);
            }
            TriggerOpportunity.sendNotificationToUser(opp_ids);
        Test.stopTest();
    }
    
/******************************************************************************
 * Method to test adding an opportunity product to an opportunity when it is
 * converted from a lead
 */
    static testMethod 
    void 
    testAddOpportunityProduct() 
    {
        System.debug( 'START: TriggerOpportunityTest.testAddOpportunityProduct()' );
        
        TestUtil l_util = new TestUtil();
        
                                                 // Get a product that can be
                                                 // used to populate the Product
                                                 // Group field on the Lead Source
                                                 // record 
        Product2 l_product = new Product2(
            Name = 'PC123',
            Description = 'Test Product Entry 1',
            ProductCode = 'PC123'
        );
        insert l_product;
        
        PricebookEntry l_pbe = new PricebookEntry(
            Product2Id = l_product.Id,
            Pricebook2Id = Test.getStandardPricebookId(),
            UnitPrice=50,
            IsActive = true
        );
        insert l_pbe;
        
                                                 // Create a lead that will
                                                 // be converted
        Lead l_lead = l_util.getLeads( 1, 'S', '' )[ 0 ]; 
        insert l_lead;
        
                                                 // Create the lead source with the
                                                 // product information
        Lead_Source_Detail__c l_lead_source = l_util.getLeadSources( 1, l_lead.Id )[ 0 ];
        l_lead_source.Paid_Amount__c = 100;
        l_lead_source.Price__c = 110;
        l_lead_source.Product_Group__c = l_product.Name;
        l_lead_source.Program_Code__c = 'Program Code';
        l_lead_source.Session_1_Date__c = Date.today().addDays( 1 );
        l_lead_source.Sold_At_Price__c = 120;
        insert l_lead_source;
        
                                                 // Create the Account, and
                                                 // Contact records that
                                                 // the lead will be converted to 
        Account l_account = l_util.getAccounts( 1, '', UserInfo.getUserId() )[ 0 ];
        insert l_account;
                                                        
        Contact l_contact = l_util.getContacts( 1, l_account.Id )[ 0 ];
        insert l_contact;
        
        LeadStatus l_convert_status = [ SELECT Id, 
                                               MasterLabel 
                                        FROM LeadStatus 
                                        WHERE IsConverted=true 
                                        LIMIT 1 ];
                                        
                                                 // Convert the lead to the contact
                                                 // and opportunity
        Test.startTest();
        
        Database.LeadConvert l_convert = new database.LeadConvert();
        l_convert.setLeadId( l_lead.Id );
        l_convert.setAccountId( l_account.Id );
        l_convert.setContactId( l_contact.Id );
        l_convert.setOpportunityName( 'Test Opportunity Name' );
        l_convert.setConvertedStatus( l_convert_status.MasterLabel );
        
        Database.LeadConvertResult l_result = Database.convertLead( l_convert );
        System.assert( l_result.isSuccess() );
        
        Test.stopTest();
        
                                                 // Check to see that an product
                                                 // was created on the opportunity
        List<OpportunityLineItem> l_opp_products = [ SELECT Id,
                                                            Program_Code__c,
                                                            ServiceDate,
                                                            UnitPrice
                                                     FROM OpportunityLineItem 
                                                     WHERE OpportunityId = :l_result.getOpportunityId() ];
        
        //System.assert( l_opp_products.size() == 1 );
        //System.assert( l_opp_products[ 0 ].Program_Code__c == l_lead_source.Program_Code__c );
        //System.assert( l_opp_products[ 0 ].ServiceDate == l_lead_source.Session_1_Date__c );
        //System.assert( l_opp_products[ 0 ].UnitPrice == l_lead_source.Sold_At_Price__c );
        
        //System.debug( 'END: TriggerOpportunityTest.testAddOpportunityProduct()' );
    }
    
}// /END Class