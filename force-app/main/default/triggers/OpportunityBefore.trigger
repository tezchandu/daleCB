trigger OpportunityBefore on Opportunity (before insert, before update) {
    if(system.label.trac_SwitchForOppTrigger =='true'){
        OpportunityBeforeTriggerHandler.setCurrencyIsoCode(Trigger.new);
        OpportunityBeforeTriggerHandler.populateContactSourceDetailOnOpp(Trigger.new);
    }
}