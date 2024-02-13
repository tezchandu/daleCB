trigger TrainerTrigger on Trainer__c (before insert, before update, after insert, after update, after delete, before delete) {
// Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	//FranchiseSharingHandler.handleTrainer(Trigger.new);
        
    } 
    if (Trigger.isAfter && (Trigger.isInsert) )
    {
        for(Trainer__c trainer:trigger.new){
        TrainerSharing2FranchiseUsers.sharingTrainers(trainer);
            }
    }
   /* if(Trigger.isdelete){
        for(Trainer__c trainer:trigger.old){
        TrainerSharing2FranchiseUsers.deleteTrainerSharing(trainer);
            }

    }*/
    if(Trigger.isAfter && Trigger.isUpdate){
        for (Trainer__c trainer : Trigger.new) {
        Trainer__c oldTrainer = Trigger.oldMap.get(trainer.Id);
	system.debug('oldTrainer - ' +oldTrainer);
            system.debug('trainer - ' +trainer);
        // Check if the owner has changed
        if (trainer.Contracted_By__c != oldTrainer.Contracted_By__c) {
            // Call the Apex method
            system.debug('trainer.OwnerId - ' +trainer.Contracted_By__c);
            system.debug('oldTrainer.OwnerId - '+oldTrainer.Contracted_By__c);
            TrainerSharing2FranchiseUsers.sharingTrainers(trainer);
            //TrainerSharing2FranchiseUsers.deleteTrainerSharing(oldTrainer);
        }
    }
    }

}