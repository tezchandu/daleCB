/****************************************************************************** 
 * Trigger that fires after Inserting a Lead Source Detail record. This follows the 
 * Super Trigger framework in which all Lead Source AFTER UPDATE activity is 
 * contained in this single trigger and calls out to a controlling class to 
 * handle the processing. This allows for the order in which events happen
 * to be controlled.
 *
 * @date 11/21/2013
 * @author Magnet 360
 *
 * 12/27/2018   Sophia Murphy (Demand Chain)
 *              updateLastLeadSourceInfo now sets the Lead Source based on custom metadata
 * 1/3/2020     Peter Moore (Demand Chain)
 *              Added updateFirstLeadSourceInfo to copy UTM values from first lsd
 */
trigger 
LeadSourceAfterInsert 
    on Lead_Source_Detail__c ( after insert ) 
{
    System.debug( 'START: LeadSourceAfterInsert' );
    
                                                 // Call @Future method to
                                                 // send out the email notification
                                                 // to the Lead Owner when a
                                                 // NEW Second or more Lead Source
                                                 // is added to a lead
    TriggerLeadSource.notifyLeadOwner( Trigger.newMap.keySet() );

    // Copy the UTM values if this is the FIRST lead source detail record
    TriggerLeadSource.updateFirstLeadSourceInfo(Trigger.newMap);

    // Update last lead source information on leads
    TriggerLeadSource.updateLastLeadSourceInfo(Trigger.newMap);

    System.debug( 'END: LeadSourceAfterInsert' );	
}// /END Trigger