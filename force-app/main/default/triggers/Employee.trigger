trigger Employee on Employee__c (before insert, before update) {
if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
    	FranchiseSharingHandler.handleEmployee(trigger.new);
    } 
}