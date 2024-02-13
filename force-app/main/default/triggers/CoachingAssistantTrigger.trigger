trigger CoachingAssistantTrigger on Coaching_Assistant__c (before insert, before update) {
// Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleCoachingAsst(Trigger.new);
    }
}