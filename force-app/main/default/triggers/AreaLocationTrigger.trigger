trigger AreaLocationTrigger on Area_Location__c (before insert, before update) {
// Process sharing rules 
if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleAreaLocation(Trigger.new);
    } 
}