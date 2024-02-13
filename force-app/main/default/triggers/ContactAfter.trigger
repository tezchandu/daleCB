/****************************************************************************** 
 * Trigger that fires after Updating a Contact record. This follows the 
 * Super Trigger framework in which all Contact AFTER UPDATE activity is 
 * contained in this single trigger and calls out to a controlling class to 
 * handle the processing. This allows for the order in which events happen
 * to be controlled.
 *
 * @date 10/29/2013
 * @author Magnet 360
 *
 * 04/23/2019   Sophia Murphy (Demand Chain)
 *              Sync email/phone/title to Supervisor fields.
 * 05/08/2019   Sophia Murphy (Demand Chain)
 *              Additional supervisor updates
 * 06/25/2019   Sophia Murphy (Demand Chain)
 *              Moved "ContactAfterUpdate" trigger items into here,
 *              So we have one AFTER trigger on the contact.
 * 10/01/2020   Sophia Murphy (Demand Chain)
 *              Uncommented call to TriggerContact.syncContacts
 * 				So updates will go to ClientBuilder
 */
trigger 
ContactAfter 
    on Contact ( after update, after insert, after delete )
{
    System.debug( 'START: ContactAfterUpdate' );

    // Traction on Demand trigger handler
    if(Trigger.isAfter && Trigger.isDelete) {
        SObjectDomain.triggerHandler(new Contacts());
    }
    
    Map<Id, Contact> l_new_contact_map = Trigger.newMap;
    Map<Id, Contact> l_old_contact_map = Trigger.oldMap;
    TriggerContact l_contact_trigger_controller = new TriggerContact();

   if(Trigger.isAfter && Trigger.isUpdate)
   {

                                                     // The list of contacts
                                                     // that will be synced with
                                                     // client builder
        List<Contact> l_contacts_to_update = new List<Contact>();

        for( Contact l_contact : l_new_contact_map.values() )
        {

                                                     // If the contact was updated
                                                     // and has the Client Builder Id
                                                     // field set, add it to the list
                                                     // of contacts to sync with
                                                     // Client Builder
                                                     // DO NOT sync if the Client Builder
                                                     // ID was just written
            if( l_contact.Client_Builder_ID__c != null
                && l_contact.Client_Builder_ID__c != ''
                && l_old_contact_map.get( l_contact.Id ).Client_Builder_ID__c != null
                && l_contact.recordTypeId != trac_Constants.dfgConRT )
            {
                l_contacts_to_update.add( l_contact );
            }

        }// /END for( New Contacts )

                                                     // Send the list of the contacts
                                                     // to sync with client builder to
                                                     // the Trigger Controller
                                                     // If this trigger is running via
                                                     // an asyncronous method, do not
                                                     // call another aysncronous method
                                                     // to sync the contacts.
        if( l_contacts_to_update.size() > 0
            && ! System.isFuture() )
        {
               l_contact_trigger_controller.syncContacts( l_contacts_to_update );
        }
    }

//    if(Trigger.isAfter && Trigger.isUpdate)
//    {
//        l_contact_trigger_controller.syncSupervisorFields(l_new_contact_map, l_old_contact_map);
//    }
//
//    if(Trigger.isAfter) {
//        //06.25.2019 - When a Lead is converted, we turn the supervisor fields into a new contact
//        // and set that contact as the ReportsTo contact.
//        //07.03.2019 - commented out.  Still issues when the Supervisor Email and the Contact's email are the same.
//        //TriggerContact.setSupervisorReportsTo(Trigger.oldMap, Trigger.newMap);
//    }

    System.debug( 'END: ContactAfter' );
}// /END Trigger