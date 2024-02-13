trigger AccountBefore on Account (before insert, before update) {
    
    if(system.label.trac_SwitchForAccountTrigger =='true'){
        AccountBeforeTriggerHandler.setCurrencyIsoCode(Trigger.new);
    }
}