trigger AvailableFranchiseTrigger on Available_Franchise__c (before insert, before update, after insert, after update, after delete, before delete) {
if (Trigger.isAfter && (Trigger.isInsert) )
    {
        for(Available_Franchise__c availFran:trigger.new){
        TrainerSharing2FranchiseUsers.sharingAvailableFranchises(availFran);
            }
    }
    /*if(Trigger.isdelete){
        for(Available_Franchise__c availFran:trigger.old){
        TrainerSharing2FranchiseUsers.deleteAvailFranSharing(availFran);
            }

    }*/
    if(Trigger.isUpdate){
        for (Available_Franchise__c availFran : Trigger.new) {
        Available_Franchise__c oldavailFran= Trigger.oldMap.get(availFran.Id);

        // Check if the owner has changed
        if (availFran.OwnerId != oldavailFran.OwnerId) {
            // Call the Apex method
            TrainerSharing2FranchiseUsers.sharingAvailableFranchises(availFran);
            //TrainerSharing2FranchiseUsers.deleteAvailFranSharing(oldavailFran);
        }
    }
    }
}