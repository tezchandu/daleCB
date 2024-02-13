trigger CustomerAgreementTrigger on Customer_Agreement__c (before insert, before update) {
    // Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
      FranchiseSharingHandler.handleCustomerAgreement(Trigger.new);
    } 
    
}