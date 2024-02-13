/**
* Trigger on all after events for the ContactSourceDetail
* 
* @Date:    06.15.2019
* @Author:  Sophia Murphy (Demand Chain)
* 
* @Updates: 
* 06.15.2019    Sophia Murphy (Demand Chain)
*               If the UTM fields go from blank to filled in, we need to find the related Opps
*               based on the Contact Role and update the UTM fields on the opps
*               Calling the Opportunity handler, since that is the core object.
* 01.03.2020    Peter Moore (Demand Chain)
*               Added updateFirstContactSourceInfo to copy UTM values from first csd
* 
*/

trigger ContactSourceDetailAfter on Contact_Source_Detail__c(after insert, after update ) 
{
    OpportunityBeforeTriggerHandler.populateContactSourceDetailOnOpp_FromCSD(Trigger.new);

    if(Trigger.isAfter && Trigger.isInsert) {
                                                  // Call @Future method to
                                                 // send out the email notification
                                                 // to the Contact Owner when a
                                                 // NEW Second or more Contact Source
                                                 // is added to a Contact
        TriggerContactSource.notifyContactOwner( Trigger.newMap.keySet() );

        // Copy the UTM values if this is the FIRST contact source detail record
        TriggerContactSource.updateFirstContactSourceInfo(Trigger.newMap);

        // Update last contact source information on contacts
        TriggerContactSource.updateLastContactSourceInfo(Trigger.newMap);
    }

}