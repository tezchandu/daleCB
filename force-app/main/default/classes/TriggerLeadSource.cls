/******************************************************************************
 * Controller class that contains all methods for the Lead Source Detail triggers. 
 * This follows the Super Trigger framework in order to control the order in which
 * trigger actions occur.
 *
 * @date 11/21/2013
 * @author Magnet 360
 */
public without sharing class 
TriggerLeadSource 
{
    
/******************************************************************************
 * Empty Constructor
 */ 
    public
    TriggerLeadSource()
    {}


/******************************************************************************
 * Method to update first source UTM fields on leads.
 *
 * @param Map<Id, Lead_Source_Detail__c> mLeadSources : A map of the Lead Source Detail records to process
 *
 * 1/3/2020   Peter Moore (Demand Chain)
 */   
public static void updateFirstLeadSourceInfo(Map<Id, Lead_Source_Detail__c> mLeadSources) {
    Map<Id, Lead> mLeadsToUpdate = new Map<Id, Lead>();   // List of Leads to be updated
    Map<Id, Lead_Source_Detail__c> leadIdToFirstSourceDetail = new Map<Id, Lead_Source_Detail__c>();
    Set<Id> relatedContactIds = new Set<Id>();

    System.debug( 'START: TriggerLeadSource.updateFirstLeadSourceInfo()' );

    // Extract the related lead Ids
    for (Lead_Source_Detail__c lsd : mLeadSources.values()) {
        if (lsd.Lead__c != null) {
            relatedContactIds.add(lsd.Lead__c);
        }
    }

    // Populate the map of related lead Ids to their first source detail record
    for (Lead_Source_Detail__c lsd : [
                SELECT Lead__c 
                FROM Lead_Source_Detail__c 
                WHERE Lead__c IN :relatedContactIds
                ORDER BY CreatedDate ASC ]) {

        // Only the first (chronological) lsd will get added to the map
        if (lsd.Lead__c != null && !leadIdToFirstSourceDetail.containsKey(lsd.Lead__c)) {
            leadIdToFirstSourceDetail.put(lsd.Lead__c, lsd);
        }
    }

    // Loop back over the records and compare each to the first CSD for the related Lead
    for (Lead_Source_Detail__c lsd : mLeadSources.values()) {
        Lead_Source_Detail__c firstSourceDetail = leadIdToFirstSourceDetail.get(lsd.Lead__c);

        if (firstSourceDetail != null && firstSourceDetail.Id == lsd.Id) {
            Lead c = new Lead(Id = lsd.Lead__c);
            c.UTM_Campaign__c = lsd.UTM_Campaign__c;
            c.UTM_Content__c = lsd.UTM_Content__c;
            c.UTM_Medium__c = lsd.UTM_Medium__c;
            c.UTM_Source__c = lsd.UTM_Source__c;
            c.UTM_Term__c = lsd.UTM_Term__c;

            mLeadsToUpdate.put(c.Id, c);     // Add lead to map of updatable.

        }
    }

    try {
        update mLeadsToUpdate.values();
    }
    catch (DmlException e) {
        System.debug('Update Faild: Un-able to update UTM values on leads.' + e.getMessage());
    }

    System.debug( 'END: TriggerLeadSource.updateFirstLeadSourceInfo()' );

}

/******************************************************************************
 * Method to update last lead source fields on leads.
 *
 * @param Map<Id> mLeadSources : A map of the Lead Source Detail records
 *                               to process
 *
 * 12/27/2018   Sophia Murphy (Demand Chain)
 *              Update to look at the custom metadata
 *              If the LeadSourceDetail.Name is in the Custom Metadata; then set the Lead.Source
 * 04/23/2023   Sophia Murphy (Demand Chain)
 *              Updated to do a "begins with" search, not an equals
 */   
public static void  updateLastLeadSourceInfo( Map<Id, Lead_Source_Detail__c> mLeadSources )
{
  System.debug( 'START: TriggerLeadSource.updateLastLeadSourceOnLead()' );

  Map<Id, Lead> mLeadsToUpdate = new Map<Id, Lead>();   // List of leads to be updated.

  //query for all LeadSourceName to Source mappings outside of the loop
  Map<String, String> nameToSourceMap = new Map<String, String>();
  for(Lead_Source_Name_to_Lead_Source__mdt lsn : [SELECT Lead_Source_Detail_Name__c, Lead_Source_Value__c FROM Lead_Source_Name_to_Lead_Source__mdt])
  {
    nameToSourceMap.put(lsn.Lead_Source_Detail_Name__c, lsn.Lead_Source_Value__c);
  }


  for (Lead_Source_Detail__c lsd : mLeadSources.values()) {
    if ( lsd.Lead__c != null ) {
      Lead l = new Lead(Id = lsd.Lead__c);

      // Update fields.
      l.Last_Lead_Source_Name__c = lsd.Name;                      // Last lead source name.
      l.Last_Lead_Source_Program_Code__c = lsd.Program_Code__c;   // Last lead source programe name.
      l.Last_Lead_Source_Key_Code__c = lsd.Key_Code__c;
      l.Last_Lead_Source_Program_Name__c = lsd.Program_Name__c;

      //String tmpSource = nameToSourceMap.get(lsd.Name);
      String tmpSource = findMatchingLSN(lsd.Name, nameToSourceMap);
      if(tmpSource != null)
      {
        l.LeadSource = tmpSource;
      }

      mLeadsToUpdate.put(l.Id, l);     // Add lead to map of updatable 
    }
  }

  try {
      update mLeadsToUpdate.values();
  }
  catch (DmlException e) {
      System.debug('Update Faild: Un-able to update last lead source information on leads.' + e.getMessage());

      for (Integer i=0; i < e.getNumDml(); i++) {
         for (Lead_Source_Detail__c lsd : mLeadSources.values()) {
            lsd.addError(e.getDmlMessage(i));
         }   
      }
  }
  
  System.debug( 'END: TriggerLeadSource.updateLastLeadSourceOnLead()' );
}

public static String findMatchingLSN(String leadSrcFromLead, Map<String, String> nameToSourceMap) {
    //Loop through the nameToSourceMap... if the Lead_Source_Detail_Name__c in the MAP is IN the leadSrcFromLead - then return TRUE
    String returnVal = null;
    for(String n : nameToSourceMap.keySet()) {
        Integer findVal = leadSrcFromLead.indexOf(n);
        if(findVal == 0) {
            returnVal = nameToSourceMap.get(n);
        }
    }
    return returnVal;
}

/******************************************************************************
 * Asysncronous method to send out a notification email to the Lead Owner when
 * a new Lead Source is created. Does not send out the email if this is the first
 * lead source record created, or if the lead source record was created by the 
 * the lead owner.
 *
 * @param Set<Id> a_lead_source_ids : A set of the Lead Source Detail record
 *                                    Ids to process
 */     
    @future
    public static
    void
    notifyLeadOwner( Set<Id> a_lead_source_ids )
    {
        System.debug( 'START: TriggerLeadSource.notifyLeadOwner()' );
        System.debug( 'Param: a_lead_source_ids = ' + a_lead_source_ids );
        
                                                 // Get a list of all the
                                                 // the Leads and their
                                                 // Lead Sources using the
                                                 // the Lead Source Ids.
                                                 // Order the Lead Sources by
                                                 // created date descending to
                                                 // make it easy to get the
                                                 // latest record
        List<Lead> l_leads = [ SELECT Id,
                                      Name,
                                      OwnerId,
                                      Owner.Email,
                                      Owner.Name,
                                      RecordTypeId,
                                      ( SELECT Id,
                                               Name,
                                               OwnerId,
                                               Key_Code__c,
                                               Promo_Code__c,
                                               CreatedDate,
                                               CreatedById,
                                               Lead__r.Name
                                        FROM Lead_Sources__r
                                        ORDER BY CreatedDate DESC LIMIT 1 )
                               FROM Lead
                               WHERE Id IN ( SELECT Lead__c
                                             FROM Lead_Source_Detail__c
                                             WHERE Id IN :a_lead_source_ids ) AND recordTypeId !=: trac_Constants.dfgLeadRT ];
        
                                                 // Get the email template to use
        String l_email_template_name = Org_Settings__c.getInstance().New_Lead_Source_Notification_Email_Name__c; 
        if( l_email_template_name == null || l_email_template_name == '' )
        {
            l_email_template_name = 'New_Lead_Source_Notification';
        }
        
        Id l_email_template_id = [ SELECT Id
                                   FROM EmailTemplate 
                                   WHERE DeveloperName = :l_email_template_name 
                                   LIMIT 1 ].Id;
        
        List<Messaging.SingleEmailMessage> l_emails_to_send = new List<Messaging.SingleEmailMessage>();
        
                                                 // Loop over the Lead records
                                                 // in order to determin if their
                                                 // owners should receive an email
        for ( Lead l_lead : l_leads ) 
        {
            
            if( l_lead.Lead_Sources__r.size() >= 1
                && l_lead.OwnerId != l_lead.Lead_Sources__r[ 0 ].OwnerId )
            {
                String ownerString = l_lead.OwnerId;
                ownerString = ownerString.substring(0, 3);
                if(ownerString == '005')
                {
                                                     // If their is more than one lead
                                                     // source for the lead, and the new
                                                     // lead source was not created by the
                                                     // the lead owner, add the lead owner
                                                     // to the list of email recipients
                    Messaging.SingleEmailMessage l_email = new Messaging.SingleEmailMessage();
                    
                    l_email.setTemplateId( l_email_template_id );
                    l_email.setTargetObjectId( l_lead.OwnerId );
                    l_email.setWhatId( l_lead.Lead_Sources__r[ 0 ].Id );
                    l_email.setSaveAsActivity( false ); 
                    l_emails_to_send.add( l_email );
                }
                
            }// /END if( Lead_Source > 1 && Lead Owner != Lead Source Creator )
        }// /END for( Leads )
        
        if( l_emails_to_send.size() > 0 )
        {
            Messaging.SendEmailResult[] l_email_results = Messaging.sendEmail( l_emails_to_send );
            System.debug( 'Email Results: ' + l_email_results );
        }
        
        System.debug( 'END: TriggerLeadSource.notifyLeadOwner()' );
    }

}// /END Class