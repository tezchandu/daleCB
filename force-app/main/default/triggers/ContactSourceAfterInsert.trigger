/****************************************************************************** 
 * Trigger that fires after Inserting a Lead Source Detail record. This follows the 
 * Super Trigger framework in which all Lead Source AFTER UPDATE activity is 
 * contained in this single trigger and calls out to a controlling class to 
 * handle the processing. This allows for the order in which events happen
 * to be controlled.
 *
 * @date 11/21/2013
 * @author Magnet 360
 */
trigger 
ContactSourceAfterInsert 
    on Contact_Source_Detail__c ( after insert ) 
{
    /** Moved this logic into the ContactSourceDetailAfter
        since I needed after update as well.  
    System.debug( 'START: ContactSourceAfterInsert' );
    
                                                 // Call @Future method to
                                                 // send out the email notification
                                                 // to the Contact Owner when a
                                                 // NEW Second or more Contact Source
                                                 // is added to a Contact
    TriggerContactSource.notifyContactOwner( Trigger.newMap.keySet() );

    // Update last contact source information on contacts
    TriggerContactSource.updateLastContactSourceInfo(Trigger.newMap);

    System.debug( 'END: ContactSourceAfterInsert' );   
    */
}// /END Trigger