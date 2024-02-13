/******************************************************************************
 * Trigger that fires after inserting an Opportunity record. This follows the 
 * Super Trigger framework in which all Opportunity AFTER INSERT activity is 
 * contained in this single trigger and calls out to a controlling class to 
 * handle the processing. This allows for the order in which events happen
 * to be controlled.
 *
 * @date 10/8/2013
 * @author Magnet 360
 */

trigger 
OpportunityAfterUpdate 
    on Opportunity ( after update ) 
{
    if(system.label.trac_SwitchForOppTrigger =='true'){
    System.debug( 'START: OpportunityAfterUpdate' );
    
    Map<Id, Opportunity> l_new_opp_map = Trigger.newMap;
    Map<Id, Opportunity> l_old_opp_map = Trigger.oldMap;
    
                                                 // The list of all Opportunities
                                                 // that have been marked as
                                                 // Closed Won and need to be
                                                 // sent to Client Builder
    List<Opportunity> l_closed_won_opps = new List<Opportunity>();
    
    TriggerOpportunity l_opp_trigger_controller = new TriggerOpportunity();

     List<Id> oppIds = new List<Id>();
                                                 // Loop over the new opportunities
    for( Opportunity l_new_opp : l_new_opp_map.values() )
    {
                                                 // If the opportunity was changed
                                                 // to Closed Won (Probability = 100 ),
                                                 // add it to the list of opportunties
                                                 // that need to have lead in Client 
                                                 // Builder created from them
        if( l_new_opp.Probability == 100 
            && l_old_opp_map.get( l_new_opp.Id ).Probability != 100 && l_new_opp.RecordTypeId != trac_Constants.dfgOppRT)
        {
            l_closed_won_opps.add( l_new_opp );
            if (l_new_opp.Do_Not_Send_Email_Notification__c == false) {
                oppIds.add(l_new_opp.Id);
            }
            // oppIds.add(l_new_opp.Id);
        }// /END if( Probability changed to 100 )  
        
    }// /END for( new Opps )
    
    if( l_closed_won_opps.size() > 0 )
    {
        l_opp_trigger_controller.createDCTLead( l_closed_won_opps );
        
        if (TriggerOpportunity.RUN_SEND_NOTIFICATION) {
            //Send notification to the Users
            System.debug('SCS: Notify users.');
            TriggerOpportunity.sendNotificationToUser( oppIds ); 

            // Stop sending duplicate notification.
            TriggerOpportunity.RUN_SEND_NOTIFICATION = false;
        } 
    }
    
    System.debug( 'END: OpportunityAfterUpdate' );
    }
}// /END Trigger