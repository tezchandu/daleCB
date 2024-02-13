trigger AlternateRevenueTypeTrigger on Alternate_Revenue_Type__c (before insert, before update) {
// Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleAlternateRevenueType(Trigger.new);
    } 
}