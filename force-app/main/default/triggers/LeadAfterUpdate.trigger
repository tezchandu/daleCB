/****************************************************************************** 
 * Trigger that fires after Updating a Lead record. This follows the 
 * Super Trigger framework in which all Lead AFTER UPDATE activity is 
 * contained in this single trigger and calls out to a controlling class to 
 * handle the processing. This allows for the order in which events happen
 * to be controlled.
 *
 * @date 10/11/2013
 * @author Magnet 360
 * 
 * 02/01/2021   Sophia Murphy (Demand Chain)
 *              DC Case 9126: Remove DFG restriction
 */

trigger 
LeadAfterUpdate 
    on Lead ( after update ) 
{
    if(system.label.trac_SwitchForLeadTrigger =='true'){
    System.debug( 'START: LeadAfterUpdate' );
    
    Map<Id, Lead> l_new_lead_map = Trigger.newMap;
    Map<Id, Lead> l_old_lead_map = Trigger.oldMap;
    
                                                 // The list of leads that
                                                 // need to be synced with
                                                 // their record in Client
                                                 // Builder
    List<Lead> l_leads_to_update = new List<Lead>();
    List<Lead> l_leads_to_transfer_sources = new List<Lead>();
    List<Id> l_converted_opportunities = new List<Id>();
    
    Set<Id> contactIds = new Set<Id>();
    
    TriggerLead l_lead_trigger_controller = new TriggerLead();
    
    for( Lead l_lead : l_new_lead_map.values() )
    {
        //All leads should have their LSD sources transferred into CSDs
        System.debug('l_lead.IsConverted: ' + l_lead.IsConverted);
        System.debug('l_lead.ConvertedContactId: ' + l_lead.ConvertedContactId);
        
        if(l_lead.IsConverted && l_lead.ConvertedContactId != null) {
            l_leads_to_transfer_sources.add(l_lead);
            contactIds.add(l_lead.ConvertedContactId);
        }                                           // If the lead was updated so
                                                    // that it was converted to an
                                                    // opportunity, add products
                                                    // to the new opportunity from
                                                    // the Lead Source Detail
        if( l_lead.ConvertedOpportunityId != null
        && l_old_lead_map.get( l_lead.Id ).ConvertedOpportunityId == null )
        {
            l_converted_opportunities.add( l_lead.ConvertedOpportunityId );
        }

        //Only build the Client Builder call outs if this isa NOT a DFG lead.
        if(l_lead.recordTypeId != trac_Constants.dfgLeadRT){
                                                      // If the lead record has
                                                      // it's external Client Builder
                                                      // Id field set, add it to the
                                                      // list of records to sync.
                                                      // DO NOT sync the lead if the
                                                      // Client Builder Id was just
                                                      // added, since that should only
                                                      // occur when Client Builder writes
                                                      // back to Salesforce
            if( l_lead.Client_Builder_Lead_ID__c != null
                && l_lead.Client_Builder_Lead_ID__c != '' 
                && l_old_lead_map.get( l_lead.Id ).Client_Builder_Lead_ID__c != null )
            {
                l_leads_to_update.add( l_lead);
            }
        }
        
    }// /END for( New Leads )
    
    if( l_leads_to_update.size() > 0 )
    {
        l_lead_trigger_controller.syncLeads( l_leads_to_update );
    }
    
    if( l_leads_to_transfer_sources.size() > 0 )
    {
        l_lead_trigger_controller.transferLeadSourcesToContact( l_leads_to_transfer_sources, contactIds);  
    }

                                                 // Delete any Account Sharing
                                                 // rules that were created
                                                 // during the ConvertLead process
    if( contactIds.size() > 0 )
    {
        // TriggerAccount.removeAccountShares( contactIds );
    }

                                                 // Call out to the Opportunity
                                                 // Trigger controller to add
                                                 // the products for the new
                                                 // Opportunity
    if( l_converted_opportunities.size() > 0 )
    {
        TriggerOpportunity l_trigger_opportunity = new TriggerOpportunity();
        l_trigger_opportunity.addOpportunityProduct( l_converted_opportunities );   
    }

    if (trigger.isUpdate && trigger.isAfter) {
        LeadAfterTriggerHandler.processConvertedContacts(trigger.new, trigger.oldMap);
    }

    System.debug( 'END: LeadAfterUpdate' );
    }
}// /END Trigger