/******************************************************************************
 * Controller class that contains all methods for the Opportunity triggers. This
 * follows the Super Trigger framework in order to control the order in which
 * trigger actions occur.
 *
 * @date 10/7/2013
 * @author Magnet 360
 * Updated on 3/15/2021 by James Loghry (Demand Chain) (Moved notification profiles to Org Settings)
 */
public without sharing class 
TriggerOpportunity 
{

/******************************************************************************
 * Constructor
 */
    public
    TriggerOpportunity()
    {
        System.debug( 'START: TriggerOpportunity.constructor()' );
        
        System.debug( 'END: TriggerOpportunity.constructor()' );
    }

/******************************************************************************
 * Method to call the web service to Create/Update a Lead in client builder 
 *
 * @param List<Opportunity> a_opportunities : The list of opportunities to create
 *                                            Leads for in the DCT system 
 * @return Void
 */
    public static Boolean RUN_CREATE_DCT_LEAD = true;
    public
    void
    createDCTLead( List<Opportunity> a_opportunities )
    {
        if(RUN_CREATE_DCT_LEAD) {
            System.debug( 'START: TriggerOpportunity.createDCTLead()' );
            System.debug( 'Param: a_opportunities = ' + a_opportunities );
            
                                                     // The web service does not
                                                     // support bulk calls, so
                                                     // only make the callout if
                                                     // the Opportunity list size
                                                     // equals 1
            if( a_opportunities.size() == 1 )
            {
                Opportunity l_opportunity = a_opportunities[ 0 ];
                
                String l_role_name = Org_Settings__c.getOrgDefaults().Contact_Opportunity_Role_Name__c;
                if( l_role_name == null || l_role_name == '' )
                {
                    l_role_name = 'Participant';
                }
                
                                                     // Get the list of contact records
                                                     // products that need to have leads
                                                     // created in client for them
                Opportunity l_lead_info = [ SELECT Id, 
                                                   Name, 
                                                   ( SELECT Id 
                                                     FROM OpportunityLineItems ), 
                                                   ( SELECT ContactId 
                                                     FROM OpportunityContactRoles
                                                     WHERE Role = :l_role_name
                                                      OR Role = null
                                                      OR Role = '' )
                                            FROM Opportunity
                                            WHERE Id = :l_opportunity.Id
                                            LIMIT 1 ];   
    
                                                     // If the lead exists, call the
                                                     // web service to create the 
                                                     // lead in Client Builder.
                                                     // A lead can be sent through even
                                                     // if no products are associated
                if( l_lead_info.OpportunityContactRoles.size() > 0 )
                {
                                                     // Create the Line Item Id and
                                                     // Contact Id lists that will 
                                                     // be passed into the web 
                                                     // service interface
                    List<Id> l_opportunity_line_item_ids = new List<Id>();
                    List<Id> l_contact_ids = new List<Id>();
                    
                    for( OpportunityLineItem l_line_item : l_lead_info.OpportunityLineItems )
                    {
                        l_opportunity_line_item_ids.add( l_line_item.Id );
                    }
                    
                    for( OpportunityContactRole l_contact : l_lead_info.OpportunityContactRoles )
                    {
                        l_contact_ids.add( l_contact.ContactId );
                    }
    
                                                     // Make web service call to create
                                                     // the lead in Client Builder 
                    if(!Test.isRunningTest()) {
                    	ClientBuilderWSInterface.createLeadFromContact( l_contact_ids, 
                                                                    l_opportunity_line_item_ids );
                    }
    
                }// /END if( Lead )
                
            }// /END if( Opportunities.size() == 1 )
            
            System.debug( 'END: TriggerOpportunity.createDCTLead()' );
            
            RUN_CREATE_DCT_LEAD = false;
        } 
    }

/******************************************************************************
 * Asyncronous method to send an email notification to the Franchise Admin when
 * an opportunity is marked as closed won 
 *
 * @param List<Id> a_opportunities : A List of the salesforce ids of the closed
 *                                   won opportunities
 * @return Void
 */
    public static Boolean RUN_SEND_NOTIFICATION = true;
    @future
    public static
    void
    sendNotificationToUser( List<Id> a_opportunities ) 
    {
        System.debug('SCS: START TriggerOpportunity.sendNotificationToUser()');

        if(RUN_SEND_NOTIFICATION) {
            Org_Settings__c orgSettings = Org_Settings__c.getInstance();
            
            
            String l_email_template_name = orgSettings.Opportunity_Won_Email_Template_Name__c; 
            if( l_email_template_name == null || l_email_template_name == '' )
            {
                l_email_template_name = 'Opportunity_Won_Notification';
            }
            
            Id emailTemplateId = [Select Id From EmailTemplate where DeveloperName = :l_email_template_name ].Id;
            
            List<Opportunity> l_opps = [ SELECT Id,
                                                Franchise_ID__c
                                         FROM Opportunity
                                         WHERE Id IN :a_opportunities ];
            
            List<String> l_franchise_ids = new List<String>();
            for( Opportunity l_opp : l_opps )
            {
                l_franchise_ids.add( l_opp.Franchise_ID__c );
            }
            
            String profileIdString = orgSettings.Closed_Won_Alert_Profile_Ids__c;
            if(!String.isEmpty(profileIdString)){
                List<String> profileIds = profileIdString.split(',');
            
                List<User> users = [ SELECT Id 
                                     FROM User
                                     WHERE ProfileId in :profileIds
                                       AND IsActive = true
                                       AND Franchise_ID__c IN :l_franchise_ids ];
                
                List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
                for (User u : users) {
                    for(Id oId : a_opportunities) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateId(emailTemplateId);
                        mail.setTargetObjectId(u.Id);
                        mail.setWhatId(oId);
                        mail.setSaveAsActivity(false); 
                        mailsToSend.add(mail);
                    }
                }
                
                 
                Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(mailsToSend);
                RUN_SEND_NOTIFICATION = false;
            }
        }

        System.debug('SCS: END TriggerOpportunity.sendNotificationToUser()');
    }
    
    
/******************************************************************************
 * Method to add the Opportunity Product to the opportunity from the converted
 * leads Lead Source Detail record
 *
 * @param List<Id> a_opp_ids : The list of ids for the opportunities that need
 *                             to have the opportunity products to added
 * @return Void
 */
    public static Boolean RUN_ADD_OPP_PROD = true;
    public
    void
    addOpportunityProduct( List<Id> a_opp_ids )
    {
        if(RUN_ADD_OPP_PROD) {
            System.debug( 'START: TriggerOpportunity.addOpportunityProduct()' );
            System.debug( 'Param: a_opp_ids = ' + a_opp_ids );
            
                                                     // A list to hold the product
                                                     // group names from the 
                                                     // lead sources
            Set<String> l_product_groups = new Set<String>();
            
                                                     // Get the ID of the Standard
                                                     // Price Book since that will
                                                     // be the one the PriceBookEntry
                                                     // Records will be pulled from
            Id l_pricebook_id = null;
            if(Test.isRunningTest()){
                l_pricebook_id = Test.getStandardPricebookId();
            }else{
                l_pricebook_id = [ SELECT Id 
                                  FROM PriceBook2
                                  WHERE IsStandard = true 
                                  LIMIT 1 ].Id;
            }
    
                                                     // Get the Opportunity records
                                                     // from the Id list
            Map<Id, Opportunity> l_opportunity_map 
                = new Map<Id, Opportunity>( [ SELECT Id,
                                                     CurrencyIsoCode
                                              FROM Opportunity
                                              WHERE Id IN :a_opp_ids ] );
            
            Set<String> l_currency_codes = new Set<String>();
            for( Opportunity l_opp : l_opportunity_map.values() )
            {
                l_currency_codes.add( l_opp.CurrencyIsoCode );
            }
    
                                                     // Get a list of all the leads
                                                     // and their most recent lead
                                                     // source record that have 
                                                     // the ConvertedOpportunityId
                                                     // in the list of opportunities
                                                     // passed in
            List<Lead> l_leads = [ SELECT Id,
                                          ConvertedContactId,
                                          ConvertedOpportunityId,
                                          ( SELECT Id,
                                                   Paid_Amount__c,
                                                   Price__c,
                                                   Product_Group__c,
                                                   Sold_At_Price__c,
                                                   Session_1_Date__c,
                                                   Program_Code__c
                                            FROM Lead_Sources__r
                                            ORDER BY LastModifiedDate DESC
                                            LIMIT 1 )
                                   FROM Lead
                                   WHERE ConvertedOpportunityId IN :a_opp_ids ];
            
                                                     // Create a map of the opportunityId
                                                     // to its list of lead sourc records
            Map<Id, List<Lead_Source_Detail__c>> l_opp_lead_source_map 
                = new Map<Id, List<Lead_Source_Detail__c>>();
                
            for( Lead l_converted_lead : l_leads )
            {
                                                     // Only add records to the map
                                                     // that have a Product_Group__c
                                                     // value, since that is the one
                                                     // that will be added
                if( l_converted_lead.Lead_Sources__r != null 
                    && l_converted_lead.Lead_Sources__r.size() > 0 
                    && l_converted_lead.Lead_Sources__r[ 0 ].Product_Group__c != null )
                {
                   l_opp_lead_source_map.put( l_converted_lead.ConvertedOpportunityId, l_converted_lead.Lead_Sources__r );
                   
                                                     // Add the Product Group names to
                                                     // Set that will be used to query
                                                     // the Products
                    l_product_groups.add( l_converted_lead.Lead_Sources__r[ 0 ].Product_Group__c );
                }
                   
            }// /END for( Converted Leads )
            
            System.debug( 'Opp Lead Source Map = ' + l_opp_lead_source_map );
            
            System.debug( 'Pricebook ID = ' + l_pricebook_id );
            System.debug( 'Product Groups = ' + l_product_groups );
            System.debug( 'Currency Codes = ' + l_currency_codes );
            
                                                     // Get the list of Products that
                                                     // can be added to the Opportunities
            List<PricebookEntry> l_pricebook_entries = [ SELECT Id,
                                                                UnitPrice,
                                                                ProductCode,
                                                                Name,
                                                                Product2Id,
                                                                CurrencyIsoCode,
                                                                Product2.Name,
                                                                Product2.Family,
                                                                Product2.Description
                                                         FROM PricebookEntry
                                                         WHERE IsActive = true
                                                            AND Pricebook2Id = :l_pricebook_id
                                                            AND Name IN :l_product_groups 
                                                            AND CurrencyIsoCode IN :l_currency_codes ];
            
                                                     // Create a map of product code to
                                                     // a map of all pricebook entries by
                                                     // currency ISO code
                                                     // Map<Product Name, Map<CurrencyIsoCode, Pricebookentry>>
            Map<String, Map<String, PricebookEntry>> l_pricebook_map = new Map<String, Map<String, PricebookEntry>>();
            for( PricebookEntry l_prod : l_pricebook_entries )
            {
                if( l_pricebook_map.get( l_prod.Name ) == null )
                {
                    l_pricebook_map.put( l_prod.Name, new Map<String, PricebookEntry>() );
                }
                
                l_pricebook_map.get( l_prod.Name ).put( l_prod.CurrencyIsoCode, l_prod );
            }
            
            System.debug( 'Pricebook Map = ' + l_pricebook_map );
            
            
                                                     // Loop over the converted opportunities
                                                     // that have a product and create
                                                     // new Opportunity Product records
                                                     // for them
            List<OpportunityLineItem> l_new_opp_products = new List<OpportunityLineItem>();
            
            if( l_pricebook_map.size() > 0 )
            {
                for( Id l_opportunity_id : l_opp_lead_source_map.keySet() )
                {
                    System.debug( 'Source Opportunity Id: ' + l_opportunity_id );
                    String l_opp_iso_code = l_opportunity_map.get( l_opportunity_id ).CurrencyIsoCode;
                    Lead_Source_Detail__c l_source_lead_source = l_opp_lead_source_map.get( l_opportunity_id )[ 0 ];
                    System.debug( 'Source Lead Source: ' + l_source_lead_source );
                    PricebookEntry l_source_product 
                        = l_pricebook_map.get( l_source_lead_source.Product_Group__c ).get( l_opp_iso_code );
                    
                    
                    System.debug( 'Source Opportunity Currency: ' + l_opp_iso_code );
                    
                    System.debug( 'Source Product: ' + l_source_product );
                    
                    if( l_source_product != null )
                    {
                        OpportunityLineItem l_opp_product = new OpportunityLineItem();
                        l_opp_product.OpportunityId = l_opportunity_id;
                        l_opp_product.PricebookEntryId = l_source_product.Id;
                        l_opp_product.Description = l_source_product.Product2.Description;
                        l_opp_product.ServiceDate = l_source_lead_source.Session_1_Date__c;
                        l_opp_product.Quantity = 1;
                        if( l_source_lead_source.Sold_At_Price__c == null )
                        {
                            l_opp_product.UnitPrice = 0;    
                        }
                        else
                        {
                            l_opp_product.UnitPrice = l_source_lead_source.Sold_At_Price__c;
                        }
                        l_opp_product.Program_Code__c = l_source_lead_source.Program_Code__c;
                        
                        l_new_opp_products.add( l_opp_product );
                    }// /END if( Source Product != null )
                }// /END for( ConvertedOpportunties )
                
                insert l_new_opp_products;
            }// /END if( Pricebook Size > 0 )
                
            System.debug( 'START: TriggerOpportunity.addOpportunityProduct()' );
            
            RUN_ADD_OPP_PROD = false;
        }
    }
        
}// /END Class