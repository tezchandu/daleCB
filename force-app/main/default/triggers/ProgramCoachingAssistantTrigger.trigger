trigger ProgramCoachingAssistantTrigger on Program_Coaching_Assistant__c (before insert, before update) {
 // Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleProgCoachAsst(Trigger.new);
    } 
}