trigger SessionTrigger on Session__c (before insert, before update) {
// Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
        FranchiseSharingHandler.handleSession(Trigger.new);
    } 
    
}