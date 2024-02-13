/****************************************************************************** 
 * Wrapper class used to easily interface with the web services provided by 
 * the Client Builder application.
 *
 * @date 10/11/2013
 * @author Magnet 360
 */
public without sharing class 
ClientBuilderWSInterface 
{

    private String ws_username { get; set; }
    private String ws_password { get; set; } 


/******************************************************************************
 * Constructor
 */
    public
    ClientBuilderWSInterface() 
    {
        System.debug( 'START: ClientBuilderWSInterface.constructor()' );
        
        this.ws_username = Org_Settings__c.getOrgDefaults().Webservice_Username__c;
        this.ws_password = Org_Settings__c.getOrgDefaults().Webservice_Password__c;
        
        System.debug( 'END: ClientBuilderWSInterface.constructor()' );
    }

/******************************************************************************
 * Asyncronous method to create a lead in client builder and update the
 * corresponding salesforce contact records with the returned Lead Id from
 * Client Builder
 * 
 * @param List<Id> a_contact_ids : A list of Contact Ids representing the
 *                                 leads that will be created in Client Builder
 *
 * @param List<Id>a_opp_line_item_ids : A list of Opportunity Line Item Ids 
 *                                      representing the products that the lead
 *                                      will be assigned to in Client Builder
 *  
 */
    @future( Callout=true )
    public static
    void
    createLeadFromContact( List<Id> a_contact_ids, List<Id> a_opp_line_item_ids )
    {
        System.debug( 'START: ClientBuilderWSInterface.createLeadFromContact()' );
        System.debug( 'Param: a_contact_ids = ' + a_contact_ids );
        System.debug( 'Param: a_opp_line_item_ids = ' + a_opp_line_item_ids );
        
        ClientBuilderLead l_cb_lead 
            = new ClientBuilderLead( a_contact_ids, a_opp_line_item_ids  );
        
        System.debug( l_cb_lead.toXML() );
        
        DCTLeadService.Service1Soap l_lead_service 
            = new DCTLeadService.Service1Soap();
        
        ClientBuilderLeadServiceResponse l_response
            = new ClientBuilderLeadServiceResponse( 
                    l_lead_service.AddUpdateLead( Org_Settings__c.getOrgDefaults().Webservice_Username__c,
                                                  Org_Settings__c.getOrgDefaults().Webservice_Password__c,
                                                  l_cb_lead.toXML() ) );
        
                                                 // A lead is only created in Client
                                                 // Builder from a Salesforce
                                                 // Contact record. Write the Response
                                                 // ID back to the Contact
        
        if( l_response != null 
            && l_response.response_map != null
            && l_response.response_map.size() > 0 )
        {

                                                 // Loop through the CBLeadResponse
                                                 // records and update their 
                                                 // corresponding Contact's with
                                                 // the Client Builder Lead Id
            List<Contact> l_contacts = [ SELECT Id,
                                                Client_Builder_Lead_ID__c, recordTypeId
                                         FROM Contact
                                         WHERE Id IN :l_response.response_map.keySet() AND RecordTypeId !=: trac_Constants.dfgConRT];

            for( Contact l_contact : l_contacts )
            {
                l_contact.Client_Builder_Lead_Id__c 
                       = l_response.response_map.get( l_contact.Id ).client_builder_lead_id;
            }

            update l_contacts;
                
        }// /END if( l_response != null )
        
        System.debug( 'Create Lead l_response = ' + l_response );
        System.debug( 'END: ClientBuilderWSInterface.createLeadFromContact()' );
    }

/******************************************************************************
 * Asyncronous Method to update a lead in client builder. Uses the Lead
 * information rather than the Contact information
 * 
 * @param List<Id> a_lead_ids : The list of salesforce Ids that need to have
 *                              their information updated in Client Builder
 */
    @future( Callout=true )
    public static
    void
    updateLeadFromLead( List<Id> a_lead_ids )
    {
        System.debug( 'START: ClientBuilderWSInterface.updateLead()' );
        System.debug( 'Param: a_lead_ids = ' + a_lead_ids );
        String requestXML;
        String responseXML;
        
        try {
          ClientBuilderLead l_cb_lead 
            = new ClientBuilderLead( a_lead_ids );
        
            requestXML = l_cb_lead.toXML();
            System.debug('requestXML: ' + requestXML);
            
            DCTLeadService.Service1Soap l_lead_service 
                = new DCTLeadService.Service1Soap();
            
            
            responseXML = l_lead_service.AddUpdateLead( Org_Settings__c.getOrgDefaults().Webservice_Username__c,
                                                      Org_Settings__c.getOrgDefaults().Webservice_Password__c,
                                                      requestXML );
            
            ClientBuilderLeadServiceResponse l_response
                = new ClientBuilderLeadServiceResponse( responseXML);
                
                                                     // Nothing needs to be written
                                                     // back to salesforce from
                                                     // the response
            
            System.debug( 'Create Lead l_response = ' + l_response );
            
        } catch (Exception ex) {
            /** 10.25.2021 - Sophia Murphy (Demand Chain)
             *  Commented out - magnet address no longer available
             * List<Messaging.SingleEmailMessage> mails = 
                    new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage mail = 
                    new Messaging.SingleEmailMessage();
    
              
            List<String> sendTo = new List<String>();
            sendTo.add('managedservices@magnet360.com');
            mail.setToAddresses(sendTo);
            
              
            mail.setReplyTo('managedservices@magnet360.com'); 
            mail.setSenderDisplayName('MSP');
            
            mail.setSubject('DCT Error');
              String body = 'Exception: ' + ex.getMessage() + '<br/>';
              body += 'requestXML: ' + requestXML + '<br/>';
              body += 'responseXML: ' + responseXML + '<br/>';
              body += 'a_lead_ids: ' + a_lead_ids + '<br/>';
            
            mail.setHtmlBody(body);
            
            
            mails.add(mail);
            
            Messaging.sendEmail(mails);
            */
        }
        
        System.debug( 'END: ClientBuilderWSInterface.updateLead()' );  
    }

/******************************************************************************
 * Asyncronous Method to update a Participant in client builder
 * 
 * @param Contact a_contact_id : A single Contact record Id whose information is used
 *                            to update it's corresponding record in client builder 
 *                            based on the external id value
 * 
 * @return String : The Client Builder Contact Id used as the external ID value
 *                  on the Contact record 
 */
    @future( Callout=true )
    public static
    void
    updateParticipantFromContact( Id a_contact_id )
    {
        System.debug( 'END: ClientBuilderWSInterface.updateParticipant()' );
        System.debug( 'Param: a_contact_id = ' + a_contact_id );
        
        ClientBuilderParticipant l_cb_participant 
            = new ClientBuilderParticipant( a_contact_id );
        
        System.debug( l_cb_participant.toXML() );
        
        DCTParticipantService.Service1Soap l_participant_service 
            = new DCTParticipantService.Service1Soap();
        
        String l_update_participant_response
            = l_participant_service.UpdateParticipant( Org_Settings__c.getOrgDefaults().Webservice_Username__c,
                                                       Org_Settings__c.getOrgDefaults().Webservice_Password__c,
                                                       l_cb_participant.toXML() );
        
                
        System.debug( 'Return: l_update_participant_response = ' + l_update_participant_response );
        System.debug( 'END: ClientBuilderWSInterface.updateParticipant()' );

    }
    
}// /END Class