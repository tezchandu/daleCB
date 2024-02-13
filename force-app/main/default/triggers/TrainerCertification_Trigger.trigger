trigger TrainerCertification_Trigger on Trainer_Certification__c (after insert,after delete,before update,after update) {
if(Trigger.isUpdate && trigger.isafter){
        for (Trainer_Certification__c trainerCert : Trigger.new) {
        Trainer_Certification__c oldTrainerCert = Trigger.oldMap.get(trainerCert.Id);

        // Check if the owner has changed
        if (trainerCert.OwnerId != oldTrainerCert.OwnerId) {
            // Call the Apex method
            TrainerSharing2FranchiseUsers.sharingTrainersCerts(trainerCert);
            //TrainerSharing2FranchiseUsers.deleteTrainerCertEventSharing(oldTrainerCert);
        }
        

		}
    }
    if(trigger.isAfter && trigger.isInsert){
        for (Trainer_Certification__c trainerCert : Trigger.new) {
            system.debug(trainerCert);
            system.debug(trigger.old);
        TrainerSharing2FranchiseUsers.sharingTrainersCerts(trainerCert);
        }
    }
    /*if(Trigger.isUpdate){
        for (Trainer_Certification__c trainer : Trigger.new) {
            Trainer_Certification__c oldTrainer = Trigger.oldMap.get(trainer.Id);
            system.debug('oldTrainer - ' +oldTrainer);
                system.debug('trainer - ' +trainer);
            // Check if the owner has changed
            if (trainer.Trainer__c != oldTrainer.Trainer__c) {
                // Call the Apex method
                system.debug('trainer.OwnerId - ' +trainer.Trainer__c);
                system.debug('oldTrainer.OwnerId - '+oldTrainer.Trainer__c);
                TrainerSharing2FranchiseUsers.sharingTrainersCerts(trainer);
                TrainerSharing2FranchiseUsers.deleteTrainerCertEventSharing(oldTrainer);
            }
    	}
    }*/
}