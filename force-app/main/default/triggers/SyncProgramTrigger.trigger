trigger SyncProgramTrigger on Program__c (after insert, After update) {
    SyncProgram2Web sync = new SyncProgram2Web();
     if(System.isFuture()) {
        return; // This is a recursive update, let's skip
    }
    if(trigger.isAfter  && ( trigger.isInsert)){
        system.debug(trigger.new);
        for(Program__c pg : trigger.new){
            system.debug('creation only');
            if(pg.Website_Event_ID__c== null && pg.Push_to_Web__c == true){
        SyncProgram2Web.sendProgram(pg.Id);
            }
        }
        
    }
    if(!System.isFuture() && !System.isBatch()){
    // your future method call here

   if(trigger.isAfter && trigger.Isupdate){
        system.debug(trigger.old);
        for(Program__c pg : trigger.new){
            system.debug(trigger.oldMap);
             program__c oldPgm = trigger.oldMap.get(pg.Id);
            system.debug(trigger.oldMap);
            system.debug('updation only');
           // Program__c prg = trigger.oldMap.get(pg.Id);
            //if(prg.Website_Event_ID__c!=''){
            if(pg.Website_Event_ID__c!= null && pg.Push_to_Web__c == true){
        SyncProgram2Web.updateProgram(pg.Id);
            }
           
            else if((pg.Website_Event_ID__c== null ) && (pg.Push_to_Web__c == true&& oldPgm.Push_to_Web__c == false  )){
                SyncProgram2Web.sendProgram(pg.Id);
            }
           // }
        }
    }
}

}