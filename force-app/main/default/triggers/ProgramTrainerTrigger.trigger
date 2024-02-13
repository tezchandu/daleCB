trigger ProgramTrainerTrigger on Program_Trainer__c (before insert, before update) {
 // Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
      FranchiseSharingHandler.handleProgTrainer(Trigger.new);
    }
}