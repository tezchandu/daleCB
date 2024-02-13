trigger ProgramTrigger on Program__c (before insert, before update) {
    // Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert) )
    {
    	FranchiseSharingHandler.handleProgram(Trigger.new);
    }  
if(trigger.isBefore && trigger.isupdate){
        for(Program__c prg : trigger.new){
            string prgOwnerId = prg.OwnerId;
        Program__c prgOld = trigger.oldMap.get(prg.id);
            string prgOwnerIdOld = prgOld.OwnerId;
            if(prgOwnerId!= prgOwnerIdOld){
                FranchiseSharingHandler.handleProgram(Trigger.new);
            }
            }
    }
}