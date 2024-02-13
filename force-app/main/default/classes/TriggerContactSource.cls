/******************************************************************************
 * Controller class that contains all methods for the Contact Source Detail triggers. 
 * This follows the Super Trigger framework in order to control the order in which
 * trigger actions occur.
 *
 * @date 11/21/2013
 * @author Magnet 360
 */
public without sharing class 
TriggerContactSource 
{
 
  public static Boolean RUN_CONTACT_SOURCE_UPDATE = true;

/******************************************************************************
 * Empty Constructor
 */ 
    public
    TriggerContactSource()
    {}




/******************************************************************************
 * Method to update first source UTM fields on contacts.
 *
 * @param Map<Id, Contact_Source_Detail__c> mContactSources : A map of the Contact Source Detail records
 *                                  to process
 *
 * 1/3/2020   Peter Moore (Demand Chain)
 */   
public static void updateFirstContactSourceInfo(Map<Id, Contact_Source_Detail__c> mContactSources) {
    Map<Id, Contact> mContactToUpdate = new Map<Id, Contact>();   // List of contacts to be updated
    Map<Id, Contact_Source_Detail__c> contactIdToFirstSourceDetail = new Map<Id, Contact_Source_Detail__c>();
    Set<Id> relatedContactIds = new Set<Id>();

    System.debug( 'START: TriggerContactSource.updateFirstContactSourceInfo()' );

    // Extract the related contact Ids
    for (Contact_Source_Detail__c csd : mContactSources.values()) {
        if (csd.Contact__c != null) {
            relatedContactIds.add(csd.Contact__c);
        }
    }

    // Populate the map of related contact Ids to their first source detail record
    for (Contact_Source_Detail__c csd : [
                SELECT Contact__c 
                FROM Contact_Source_Detail__c 
                WHERE Contact__c IN :relatedContactIds
                ORDER BY CreatedDate ASC ]) {

        // Only the first (chronological) csd will get added to the map
        if (csd.Contact__c != null && !contactIdToFirstSourceDetail.containsKey(csd.Contact__c)) {
            contactIdToFirstSourceDetail.put(csd.Contact__c, csd);
        }
    }

    // Loop back over the records and compare each to the first CSD for the related Contact
    for (Contact_Source_Detail__c csd : mContactSources.values()) {
        Contact_Source_Detail__c firstSourceDetail = contactIdToFirstSourceDetail.get(csd.Contact__c);

        if (firstSourceDetail != null && firstSourceDetail.Id == csd.Id) {
            Contact c = new Contact(Id = csd.Contact__c);
            c.UTM_Campaign__c = csd.UTM_Campaign__c;
            c.UTM_Content__c = csd.UTM_Content__c;
            c.UTM_Medium__c = csd.UTM_Medium__c;
            c.UTM_Source__c = csd.UTM_Source__c;
            c.UTM_Term__c = csd.UTM_Term__c;

            mContactToUpdate.put(c.Id, c);     // Add contact to map of updatable.

        }
    }

    try {
        update mContactToUpdate.values();
    }
    catch (DmlException e) {
        System.debug('Update Faild: Un-able to update UTM values on contacts.' + e.getMessage());
    }

    System.debug( 'END: TriggerContactSource.updateFirstContactSourceInfo()' );

}

/******************************************************************************
 * Method to update last lead source fields on contacts.
 *
 * @param Map<Id> mContactSources : A map of the Contact Source Detail records
 *                                  to process
 */   
public static void  updateLastContactSourceInfo( Map<Id, Contact_Source_Detail__c> mContactSources )
{
  System.debug( 'START: TriggerContactSource.updateLastContactSourceInfo()' );

  if (!RUN_CONTACT_SOURCE_UPDATE)
      return;     // Do not proced with last contact information update.

  Map<Id, Contact> mContactToUpdate = new Map<Id, Contact>();   // List of contacts to be updated.

  for (Contact_Source_Detail__c cd : mContactSources.values()) {
    if ( cd.Contact__c != null) {
      Contact c = new Contact(Id = cd.Contact__c);
        
      // Update fields.
      c.Last_Contact_Source_Name__c = cd.Name;                      // Last contact source name.
      c.Last_Contact_Source_Program_Code__c = cd.Program_Code__c;   // Last contact source programe name.
      c.Last_Contact_Source_Key_Code__c = cd.Key_Code__c;
      c.Last_Contact_Source_Program_Name__c = cd.Program_Name__c;

      mContactToUpdate.put(c.Id, c);     // Add contact to map of updatable.
    }
  }

  try {
      update mContactToUpdate.values();
  }
  catch (DmlException e) {
      System.debug('Update Faild: Un-able to update last contact source information on contacts.' + e.getMessage());

      for (Integer i=0; i < e.getNumDml(); i++) {
         for (Contact_Source_Detail__c cd : mContactSources.values()) {
            cd.addError(e.getDmlMessage(i));
         }   
      }
  }
    
  System.debug( 'END: TriggerContactSource.updateLastContactSourceInfo()' );
}


/******************************************************************************
 * Asysncronous method to send out a notification email to the Contact Owner when
 * a new Contact Source is created. Does not send out the email if this is the first
 * contact source record created, or if the contact source record was created by the 
 * the contact owner.
 *
 * @param Set<Id> a_contact_source_ids : A set of the Contact Source Detail record
 *                                       Ids to process
 */     
    @future
    public static
    void
    notifyContactOwner( Set<Id> a_contact_source_ids )
    {
        System.debug( 'START: TriggerContactSource.notifyContactOwner()' );
        System.debug( 'Param: a_contact_source_ids = ' + a_contact_source_ids );
        
                                                 // Get a list of all the
                                                 // the Contacts and their
                                                 // Contact Sources using the
                                                 // the Contact Source Ids.
                                                 // Order the Contact Sources by
                                                 // created date descending to
                                                 // make it easy to get the
                                                 // latest record
        List<Contact> l_contacts = [ SELECT Id,
                                      Name,
                                      OwnerId,
                                      Owner.Email,
                                      Owner.Name,
                                      recordTypeId,
                                      ( SELECT Id,
                                               Name,
                                               OwnerId,
                                               Form_Name__c,
                                               Key_Code__c,
                                               CreatedDate,
                                               CreatedById,
                                               Contact__r.Name
                                        FROM Contact_Source_Details__r
                                        ORDER BY CreatedDate DESC )
                               FROM Contact
                               WHERE Id IN ( SELECT Contact__c
                                             FROM Contact_Source_Detail__c
                                             WHERE Id IN :a_contact_source_ids ) AND recordTypeId !=: trac_Constants.dfgConRT];
        
                                                 // Get the email template to use
        String l_email_template_name = Org_Settings__c.getInstance().New_Contact_Source_Email_Name__c; 
        if( l_email_template_name == null || l_email_template_name == '' )
        {
            l_email_template_name = 'New_Contact_Source_Notification';
        }
        
        Id l_email_template_id = [ SELECT Id
                                   FROM EmailTemplate 
                                   WHERE DeveloperName = :l_email_template_name 
                                   LIMIT 1 ].Id;
        
        List<Messaging.SingleEmailMessage> l_emails_to_send = new List<Messaging.SingleEmailMessage>();
        
                                                 // Loop over the Contact records
                                                 // in order to determine if their
                                                 // owners should receive an email
        for ( Contact l_contact : l_contacts ) 
        {
            system.debug('===== > ' + l_contact.OwnerId + ' == '  + l_contact.Contact_Source_Details__r[ 0 ].OwnerId );
            
            System.debug('==> Owner Id 1 ' + l_contact.Contact_Source_Details__r[ 0 ].OwnerId);
            if( l_contact.Contact_Source_Details__r.size() >= 1
                && l_contact.OwnerId != l_contact.Contact_Source_Details__r[ 0 ].OwnerId )
            {
                                                 // If their is more than one Contact
                                                 // source for the Contact, and the new
                                                 // Contact source was not created by the
                                                 // the contact owner, add the contact owner
                                                 // to the list of email recipients
                Messaging.SingleEmailMessage l_email = new Messaging.SingleEmailMessage();
                
                l_email.setTemplateId( l_email_template_id );
                l_email.setTargetObjectId( l_contact.OwnerId );
                l_email.setWhatId( l_contact.Contact_Source_Details__r[ 0 ].Id );
                //l_email.toAddresses = new List<String>{'fahad.munawar@magnet360.com'};
                l_email.setSaveAsActivity( false ); 
                l_emails_to_send.add( l_email );
                System.debug('FM: targetobjId: '+l_contact.OwnerId);                
            }// /END if( Contact Source > 1 && Contact Owner != Contact Source Creator )
        }// /END for( Contacts )
        
        if( l_emails_to_send.size() > 0 )
        {
            Messaging.SendEmailResult[] l_email_results = Messaging.sendEmail( l_emails_to_send );
            System.debug( 'Email Results: ' + l_email_results );
        }

        System.debug( 'END: TriggerContactSource.notifyContactOwner()' );
    }

}// /END Class