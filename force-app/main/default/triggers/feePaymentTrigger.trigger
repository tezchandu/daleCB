trigger feePaymentTrigger on Fee_Payment__c (before insert, before update, before delete) {
public static Boolean isExecuting = false;
    if (Trigger.isBefore && Trigger.isInsert) {
        if(!isExecuting){
			isExecuting = true;
            system.debug('Before insert ');
            system.debug('Trigger.new[0].Process_Sharing__c  '+Trigger.new[0].Process_Sharing__c);
        FranchiseSharingHandler.handleFeePayment(Trigger.new);
        }
        
        PreventPaymentRecordModification.preventInsertion(Trigger.new);
        
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        system.debug('Before  ');
        for(Fee_Payment__c fp :trigger.new){
            if(!isExecuting){
                system.debug('executing  ');
                isExecuting = true;
          FranchiseSharingHandler.handleFeePayment(Trigger.new);
            }
            system.debug('fp  '+fp);
            Fee_Payment__c oldfp = Trigger.oldMap.get(fp.Id);
        system.debug('oldfp.OwnerId  '+oldfp.OwnerId);
            system.debug('fp.OwnerId  '+fp.OwnerId);
        if(oldfp.OwnerId != fp.OwnerId){
            
            /*if(!isExecuting){
                system.debug('executing  ');
                isExecuting = true;
          FranchiseSharingHandler.handleFeePayment(Trigger.new);
            }*/
        }
        }
        
          PreventPaymentRecordModification.preventUpdation(Trigger.new, Trigger.oldMap);
        
    }

    if (Trigger.isBefore && Trigger.isDelete) {
			   PreventPaymentRecordModification.preventDeletion(Trigger.old);

    }
}