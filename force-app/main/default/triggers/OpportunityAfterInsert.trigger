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
OpportunityAfterInsert 
    on Opportunity ( after insert ) 
{
if(system.label.trac_SwitchForOppTrigger =='true'){
    List<Opportunity> l_new_opps = Trigger.new;
    
                                                 // The list of all Opportunities
                                                 // that have been marked as
                                                 // Closed Won and need to be
                                                 // sent to Client Builder
    List<Opportunity> l_closed_won_opps = new List<Opportunity>();
    
    TriggerOpportunity l_opp_trigger_controller = new TriggerOpportunity();
    
    for( Opportunity l_opp : l_new_opps )
    {
        if( l_opp.Probability == 100 && l_opp.RecordTypeId != trac_Constants.dfgOppRT)
        {
            l_closed_won_opps.add( l_opp );
        }// /END if( Opportunity Probability == 100% )
        
    }// /END for( New Opportunities )
    
    if( l_closed_won_opps.size() > 0 )
    {
        l_opp_trigger_controller.createDCTLead( l_closed_won_opps );
    }
    }

}// /END Trigger