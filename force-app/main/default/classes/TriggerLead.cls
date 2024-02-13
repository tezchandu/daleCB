/******************************************************************************
 * Controller class that contains all methods for the Lead triggers. This
 * follows the Super Trigger framework in order to control the order in which
 * trigger actions occur.
 *
 * @author  Magnet 360
 * @date    10/7/2013
 *
 * @Updates 
 * 09.18.2015   Abdul Sattar (Magnet 360)
 *              Updated transferLeadSourcesToContact() to fix 
 *              'Original Source Detail Create Date' bug.
 * 06.05.2017   Sophia Murphy (Magnet 360)
 *              Updated so that CSD Owner matches the LSD Owner, not the Contact Owner
 */
public without sharing class 
TriggerLead
{

/******************************************************************************
 * Constructor
 */
    public
    TriggerLead()
    {
        System.debug( 'START: TriggerLead.constructor()' );
        
        System.debug( 'END: TriggerLead.constructor()' );
    }

/******************************************************************************
 * Method to call the web service to sync the Lead information in salesforce
 * with it's record in Client Builder 
 *
 * @parm List<Lead> a_leads : The list of lead records to sync
 * 
 * @return Void
 */
    public static Boolean RUN_SYNC_LEADS = true;
    public static Boolean RUN_TRANSFER_LEAD_SOURCES = true;
    
    public
    void
    syncLeads( List<Lead> a_leads )
    {
        if(RUN_SYNC_LEADS) {
            System.debug( 'START: TriggerLead.syncLeads()' );
            System.debug( 'Param: a_leads = ' + a_leads );
            
            List<Id> l_lead_ids = new List<Id>();
            
                                                     // Create the list of Ids
                                                     // from the list of Lead records
                                                     // passed in
            for( Lead l_lead : a_leads )
            {
                l_lead_ids.add( l_lead.Id );    
            }
                                                     // Call the web service to 
                                                     // update the lead information
                                                     // in Client Builder  
            
            //Bug Fix 8/24/2021 We only want to call this future method if we are not already in a future
            if(!System.isFuture() && !System.isBatch()) {
                ClientBuilderWSInterface.updateLeadFromLead( l_lead_ids );
            }
          
    
            System.debug( 'END: TriggerLead.syncLeads()' );
            
            RUN_SYNC_LEADS = false;
        }
    }
    
    /**
     * Copies / transfers lead sources from leads to contact sources on contacts
     * @param a_leads    List of source leads
     * @param contactIds Set of target contact Ids
     *
     * @author      Abdul Sattar (Magnet 360)
     *
     * @Updates 
     * 09.18.2015   Abdul Sattar (Magnet 360)
     *              Updated to fix bug which caused incorrect value for 'Original Source Detail Create Date' field.
     * 05.07.2019   Chris Mollet (Demand Chain)
     *              Added 5 Lead Source Detail UTM fields to transfer to the Contact Source Detail object on lead convert.
     * 01.16.2020   Sophia Murphy (Demand Chain)
     *              Added Website Order Number field to transfer to the Contact Source Detail object on lead convert.
     */
    public void transferLeadSourcesToContact(List<Lead> a_leads, Set<Id> contactIds) { 
                        
        if(RUN_TRANSFER_LEAD_SOURCES) {
            Map<Id, List<Lead_Source_Detail__c>> leadToSources = new Map<Id, List<Lead_Source_Detail__c>>(); 
            for(Lead_Source_Detail__c  ls : [SELECT Id, 
                                                   Name,
                                                   Key_Code__c,
                                                   Promo_Code__c,
                                                   Lead__c,
                                                   Special_Instructions__c,
                                                   Is_Mobile_Sale__c,
                                                   Paid_Amount__c,
                                                   Price__c,
                                                   Program_Code__c,
                                                   Program_Name__c,
                                                   Session_1_Date__c,
                                                   Sold_At_Price__c,
                                                   Product_Group__c,
                                                   Interest__c,
                                                   Time_Frame__c,
                                                   What_Else__c,
                                                   CreatedDate,
                                                   OwnerId,
                                                   UTM_Campaign__c,
                                                   UTM_Content__c,
                                                   UTM_Medium__c,
                                                   UTM_Source__c,
                                                   UTM_Term__c,
                                                   Website_Order_Number__c,
                                                   Payment_Source__c,
													Is_Evolve_Order__c,
													eVolve_Sublicense_ID__c,
													Event_Type__c,
													Event_End_Date__c,
													Stripe_Transaction_ID__c,
													Stripe_Transaction_Response__c,
                                                    Responsible_Franchise_ID__c,
                                             		Payment_Date__c
                                            FROM Lead_Source_Detail__c where Lead__c in :a_leads
                                            ORDER BY Lead__c, Id]) {
                    
                List<Lead_Source_Detail__c> sources = leadToSources.get(ls.Lead__c);
                if(sources == null) {
                    sources = new List<Lead_Source_Detail__c>();
                    leadToSources.put(ls.Lead__c, sources);
                }
                
                
                sources.add(ls);                        
            }
            
            Map<Id, Contact> contactsMap = new Map<Id, Contact>([select Id, OwnerId,
                    Client_Builder_ID__c,
                    Client_Builder_Lead_Id__c from Contact where Id in :contactIds]);
                    
            List<Contact_Source_Detail__c> contactSourceDetails = new List<Contact_Source_Detail__c>();
            
            for(Lead l : a_leads) {
                Contact c = contactsMap.get(l.ConvertedContactId);
                
                List<Lead_Source_Detail__c> sources = leadToSources.get(l.Id);
                if(sources != null) {
                    for(Lead_Source_Detail__c ls : sources) {
                        contactSourceDetails.add(new Contact_Source_Detail__c(
                            Name = ls.Name,
                            Contact__c = c.Id,
                            Key_Code__c = ls.Key_Code__c,
                            Promo_Code__c = ls.Promo_Code__c,
                            Special_Instructions__c = ls.Special_Instructions__c,
                            Added_Date__c = Date.today(),
                            Client_Builder_ID__c = c.Client_Builder_ID__c,
                            Client_Builder_Lead_ID__c = c.Client_Builder_Lead_ID__c,
                            //OwnerId = c.OwnerId,
                            OwnerId = ls.OwnerId,
                            Is_Mobile_Sale__c = ls.Is_Mobile_Sale__c,
                            Paid_Amount__c = ls.Paid_Amount__c,
                            Price__c = ls.Price__c,
                            Program_Code__c = ls.Program_Code__c,
                            Program_Name__c = ls.Program_Name__c,
                            Session_1_Date__c = ls.Session_1_Date__c,
                            Sold_At_Price__c = ls.Sold_At_Price__c,
                            Product_Group__c = ls.Product_Group__c,
                            Interest__c = ls.Interest__c,
                            Time_Frame__c = ls.Time_Frame__c,
                            What_Else__c = ls.What_Else__c,
                            Original_Source_Detail_Create_Date__c = Date.newinstance(ls.CreatedDate.year(), ls.CreatedDate.month(), ls.CreatedDate.day()),
                            UTM_Campaign__c = ls.UTM_Campaign__c,
                            UTM_Content__c = ls.UTM_Content__c,
                            UTM_Medium__c = ls.UTM_Medium__c,
                            UTM_Source__c = ls.UTM_Source__c,
                            UTM_Term__c = ls.UTM_Term__c,
                            Website_Order_Number__c = ls.Website_Order_Number__c,
                            Payment_Source__c = ls.Payment_Source__c,
							Is_Evolve_Order__c = ls.Is_Evolve_Order__c,
							eVolve_Sublicense_ID__c = ls.eVolve_Sublicense_ID__c,
							Event_Type__c = ls.Event_Type__c,
							Event_End_Date__c = ls.Event_End_Date__c,
							Stripe_Transaction_ID__c = ls.Stripe_Transaction_ID__c,
							Stripe_Transaction_Response__c = ls.Stripe_Transaction_Response__c,
                            Responsible_Franchise_ID__c = ls.Responsible_Franchise_ID__c,
                             Payment_Date__c = ls.Payment_Date__c
                        ));
                    }
                }
            }
            
            
            // Do not update last contact source information from trigger.
            TriggerContactSource.RUN_CONTACT_SOURCE_UPDATE = false;     

            insert contactSourceDetails;
            RUN_TRANSFER_LEAD_SOURCES = false;
            
            // Enable updation of last contact source information from trigger.
            TriggerContactSource.RUN_CONTACT_SOURCE_UPDATE = true;      

            System.debug('TriggerLead.transferLeadSourcesToContact: Leader souce transfer completed.');
        }
    }

}// /END Class