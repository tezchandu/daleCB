/**
* Trigger on all before events for the Campaign
* 
* @Date:    xxx
* @Author:  
* 
* @Updates: 01.22.2016 Usman Ali (Magnet30)
*           Added called to FranchiseSharingHandler
* 
*/
trigger LeadBefore on Lead (before insert, before update) 
{
    if(system.label.trac_SwitchForLeadTrigger =='true'){
        // Set default user currency.
        LeadBeforeTriggerHandler.setCurrencyIsoCode(Trigger.new);
    
        // Set supervisor name.
        LeadBeforeTriggerHandler.setSupervisorName(Trigger.new, Trigger.isInsert);
    
        // Process sharing rules 
        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
        {
            FranchiseSharingHandler.handleLeads(Trigger.new);
        }
    }

}