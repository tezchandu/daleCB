trigger TrainerCertificationTrigger on Trainer_Certification_Event__c (before insert, before update, after insert, after update, after delete, before delete) {
// Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
      FranchiseSharingHandler.handleTrainerCertification(Trigger.new);
    } 
    
}