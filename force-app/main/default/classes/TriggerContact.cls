/******************************************************************************
 * Controller class that contains all methods for the Contact triggers. This
 * follows the Super Trigger framework in order to control the order in which
 * trigger actions occur.
 *
 * @date 10/29/2013
 * @author Magnet 360
 * 
 * 05/08/2019   Sophia Murphy (Demand Chain)
 *              Additional supervisor updates
 * 06/25/2019   Sophia Murphy (Demand Chain)
 *              setSupervisorReportsTo method
 */
public without sharing class 
TriggerContact 
{

/******************************************************************************
 * Constructor
 */
    public
    TriggerContact()
    {
        System.debug( 'START: TriggerContact.constructor()' );
        
        System.debug( 'END: TriggerContact.constructor()' );
    }

/******************************************************************************
 * Method to call the web service to sync the Contact information in salesforce
 * with it's record in Client Builder 
 *
 * @parm List<Contact> a_contact : The list of Contact records to sync. The 
 *                                 web service only accepts a single Contact
 *                                 in the list at this time (10/29/2013)
 * 
 * @return Void
 */
    public
    void
    syncContacts( List<Contact> a_contacts )
    {
        System.debug( 'START: TriggerContact.syncContacts()' );
        System.debug( 'Param: a_contacts = ' + a_contacts );
        
                                                 // The web service does not
                                                 // support bulk calls, so
                                                 // only make the callout if
                                                 // the Contact list size equals 1
        if( a_contacts.size() == 1 )
        {           
                                                 // Call the web service to 
                                                 // update the lead information
                                                 // in Client Builder  
            ClientBuilderWSInterface.updateParticipantFromContact( a_contacts[ 0 ].Id );
            
        }// /END if( Contact List Size == 1 )
        
        System.debug( 'END: TriggerContact.syncContacts()' );
    }

    public void syncSupervisorFields(Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {

        //If the name, email, phone or title have changed - 
        //  look to see if this contact is in anyone's "Reports To" field
        //  if so, those "reporting to" contacts need their supervisor fields updated
        Map<Id, Contact> changedContacts = new Map<Id, Contact>();
        Map<Id, Contact> changedReportsTo = new Map<Id, Contact>();
        for(Id contactId : newMap.keySet()) {
            Contact newContact = newMap.get(contactId);
            Contact oldContact = oldMap.get(contactId);

            if(newContact.FirstName != oldContact.FirstName
                || newContact.LastName != oldContact.LastName
                || newContact.Email != oldContact.Email
                || newContact.Phone != oldContact.Phone
                || newContact.Title != oldContact.Title) {

                    changedContacts.put(contactId, newContact);
                } //END: if(newContact.FirstNa....

            //if the supervisor fields have changed (ie: via a dataload)
            //then we need to update the contact that is referenced in the Reports To.
            if(newContact.Supervisor_Name__c != oldContact.Supervisor_Name__c
              || newContact.Supervisor_FirstName__c != oldContact.Supervisor_FirstName__c
              || newContact.Supervisor_LastName__c != oldContact.Supervisor_LastName__c
              || newContact.Supervisor_Phone__c != oldContact.Supervisor_Phone__c
              || newContact.Supervisor_Email__c != oldContact.Supervisor_Email__c
              || newContact.Supervisor_Title__c != oldContact.Supervisor_Title__c) {
                   
                  if(newContact.ReportsToId != null) {
                      //In the event that there are 2 contacts (joe and jane) with a
                      // reports to contact of suzie... if both joe and jane have
                      // their supervisor fields updated with different values...
                      // this map will only log one of them.
                   	changedReportsTo.put(newContact.ReportsToId, newContact);
                  }
               }
            
        } //END: for(Id contactId : newMap.values())

        //Now query... for contacts that have this person as their reports to...
        List<Contact> updContacts = new List<Contact>();
        for(Contact c : [SELECT Id, Supervisor_Name__c, Supervisor_FirstName__c, Supervisor_LastName__c,
            Supervisor_Phone__c, Supervisor_Email__c, Supervisor_Title__c, ReportsToId
            FROM Contact
            WHERE ReportsToId IN :changedContacts.keySet()]) {
                Contact supervisor = changedContacts.get(c.ReportsToId);
                
                //we don't want the word "null" put in for the first name
                String fName = supervisor.FirstName;
                if(fName == null || fName == 'null' || fName == 'Null') {
                    fName = ' ';
                }
                
                system.debug('DC: supervisor.FirstName: ' + supervisor.FirstName);
                system.debug('DC: fName: ' + fName);
                c.Supervisor_Name__c = fName + ' ' + supervisor.LastName;
                c.Supervisor_FirstName__c = fName;
                c.Supervisor_LastName__c = supervisor.LastName;
                c.Supervisor_Phone__c = supervisor.Phone;
                c.Supervisor_Email__c = supervisor.Email;
                c.Supervisor_Title__c = supervisor.Title;
                updContacts.add(c);
            } //END: for(Contact c

         //Now update the "reports to contacts..."
        for(Id contactId : changedReportsTo.keySet()) {
            Contact tempContact = changedReportsTo.get(contactId);
            Contact reportsToContact = new Contact(Id = contactId);
            
            List<String> firstLastName = parseFirstLastName(tempContact.Supervisor_Name__c);
            system.debug('DC: firstLastName[0]: ' + firstLastName[0]);
            if(firstLastName[1] != null) {
                reportsToContact.FirstName = firstLastName[0];
                reportsToContact.LastName = firstLastName[1];
            }
            reportsToContact.Phone = tempContact.Supervisor_Phone__c;
            reportsToContact.Email = tempContact.Supervisor_Email__c;
            reportsToContact.Title = tempContact.Supervisor_Title__c;
            updContacts.add(reportsToContact);
        }
        
         if(updContacts.size() > 0) {
            update updContacts;
         }

    } //END: syncSupervisorFields

    //Given the full supervisor name - split into first and last.
    //returns the first name in first element[0] of the list, last name in the second element[1].
    public static List<String> parseFirstLastName(String fullName) {
        String firstName = ' ';
        String lastName = fullName;
        try {
            Integer indexOf = fullName.indexOf(' ');
            firstName = fullName.substring(0,indexOf);
            lastName = fullName.substring(indexOf+1);
        } catch (Exception e) {}
        return new List<String>{firstName, lastName};
    }

    public static void setSupervisorReportsTo(Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {
        //If this is a NEW contact or a contact that previously did NOT have supervisor details...
        // we need to CREATE a new contact for their supervisor data and
        // tie that new Contact to their ReportsTo field


        // 1. Is this a new contact that has a supervisor email and name?  
        //          Or an existing contact that went from a blank supervisor email/name to a filled in one.
        List<Contact> cntList = new List<Contact>();
        List<String> emailList = new List<String>();
        Map<String, Contact> emailToContactMap = new Map<String, Contact>();

        for(Contact c : newMap.values()) {

            Boolean addContact = false;
            if(oldMap == null && c.Supervisor_Email__c != null && c.Supervisor_Name__c != null) {
                addContact = true;
            }
            if(oldMap != null) {
                Contact oldContact = oldMap.get(c.Id);
                if(oldContact.Supervisor_Email__c == '' 
                    && c.Supervisor_Email__c != null 
                    && oldContact.Supervisor_Name__c == '' 
                    && c.Supervisor_Name__c != null
                    && oldContact.ReportsToId == null) {

                        addContact = true;

                    }
            }

            if(addContact) {
                cntList.add(c);
            }
            emailList.add(c.Supervisor_Email__c);
        }
        system.debug('DC: cntList: ' + cntList);
        system.debug('DC: emailList: ' + emailList);

        // 2. Get all the supervisor email addresses
        //          and lookup existing contacts.
        if(emailList.size() > 0) {
            for(Contact c : [SELECT Id, Email FROM Contact 
                                WHERE Email IN :emailList
                                    AND Id NOT IN :cntList
                                    AND Email != null]) {
                emailToContactMap.put(c.Email, c);
            }
        }
        system.debug('DC: emailToContactMap: ' + emailToContactMap);

        // 3. If no existing contacts, create them!.  Email address is the key - contact ID is the value
        List<Contact> newContacts = new List<Contact>();
        for(Contact c : cntList) {
            //does this supervisor contact already exist?
            Contact tmpContact = emailToContactMap.get(c.Supervisor_Email__c);
            if(tmpContact == null) {
                Contact c2 = new Contact();

                List<String> firstLastName = parseFirstLastName(c.Supervisor_Name__c);
                system.debug('DC: firstLastName[0]: ' + firstLastName[0]);
                if(firstLastName[1] != null) {
                    c2.FirstName = firstLastName[0];
                    c2.LastName = firstLastName[1];
                }
                c2.Email = c.Supervisor_Email__c;
                c2.Phone = c.Supervisor_Phone__c;
                c2.Title = c.Supervisor_Title__c;
                c2.AccountId = c.AccountId;
                System.debug('DC: c2: ' + c2);

                newContacts.add(c2);
            } 
        }

        if(newContacts.size() > 0) {
            try {
                insert newContacts;
            } catch (Exception e) {}
        }

        for(Contact c : newContacts) {
            emailToContactMap.put(c.Email, c);
        }

        // 4. Update the ReportsTo field on these contacts.
        List<Contact> updContacts = new List<Contact>();
        for(Contact c : newMap.values()) {
            Contact reportsTo = emailToContactMap.get(c.Supervisor_Email__c);
            if(reportsTo != null) {
                //c.ReportsToId = reportsTo.Id;
                //updContacts.add(c);
                if(!system.isFuture()) {
                    setReportsToFuture(c.Id, reportsTo.Id);
                }
            }
        }

        if(updContacts.size() > 0) {
            update updContacts;
        }
    }

    @future
    private static void setReportsToFuture(Id contactId, Id reportsToId) {
        Contact c = new Contact(Id = contactId);
        c.ReportsToId = reportsToId;
        update c;
    }


}// /END Class