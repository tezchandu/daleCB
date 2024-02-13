@isTest
private class OpportunityBeforeTriggerHandlerTest {
    
    static testMethod void testOpportunityCurrencyIsoCode() {
        TestUtil testUtil = new TestUtil();
        User u = testUtil.getUsers(1, null)[0];
        u.DefaultCurrencyIsoCode = 'USD';
        Insert u;
        
        Account account = testUtil.getAccounts(2, null, u.Id)[0];
        insert account;
        
        List<Opportunity> opps = testUtil.getOpportunities(2, account.Id, u.Id);
        insert opps;
        List<Opportunity> insertedOpps = [Select o.CurrencyIsoCode From Opportunity o Where o.Id IN :opps];
        for (Opportunity opp : insertedOpps) {
            System.assertEquals(u.DefaultCurrencyIsoCode , opp.CurrencyIsoCode);
        }

        // Create Product2 record
        Product2 newProd = testUtil.getProducts(1)[0];
        insert newProd;
        
        // Create Price Book entry
        PriceBookEntry pbEntry = testUtil.getPriceBookEntries(1, newProd.Id )[0];
        insert pbEntry ;

        // Create Opportunity 
        Opportunity opp = testUtil.getOpportunities(1, account.Id, u.Id )[0];
        opp.Pricebook2Id = Test.getStandardPricebookId(); 
        insert opp ;

        // Create a contact 
        Contact con = testUtil.getContacts(1, account.Id )[0];
        insert con;

        // Create Contact source detail record
        Contact_Source_Detail__c csd = testUtil.getContactSources(1, con.Id)[0];
        insert csd;

        // Create OpportunityContactRole record
        OpportunityContactRole ocr = testUtil.getOpportunityContactRoles(1, opp.Id, con.Id, 'Evaluator')[0];
        insert ocr ;

        // Create OpportunityLineItem record
        OpportunityLineItem oppLine = testUtil.getOpportunityLineItems(1, opp.Id, pbEntry.Id )[0];
        insert oppLine;
        System.debug('UAC: oppLine ' + oppLine );

        // Update to fire method populateContactSourceDetail()
        update opp ;

        
    }
}