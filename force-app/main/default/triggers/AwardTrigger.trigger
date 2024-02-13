trigger AwardTrigger on Award__c (before insert, before update) {
// Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleAward(Trigger.new);
    } 
}