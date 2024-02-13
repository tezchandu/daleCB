trigger EmployeeDateTrigger on Employment_Date__c (before insert, before update) {
// Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleEmployeeDate(Trigger.new);
    } 
}