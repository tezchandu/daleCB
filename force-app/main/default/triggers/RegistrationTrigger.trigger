trigger RegistrationTrigger on Registration__c (before insert, before update) {
// Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert) )
    {
        system.debug('before  ');
      FranchiseSharingHandler.handleRegistration(Trigger.new);
    } 
    if(trigger.isBefore && trigger.isupdate){
        FranchiseSharingHandler.handleRegistration(Trigger.new);
        /*for(Registration__c rg : trigger.new){
            string regOwnerId = rg.OwnerId;
        Registration__c regOld = trigger.oldMap.get(rg.id);
            if(regOld.OwnerId!=rg.OwnerId){
            string regOwnerIdOld = regOld.OwnerId;
            if(regOwnerId!= regOwnerIdOld){
                FranchiseSharingHandler.handleRegistration(Trigger.new);
            }
            }
            }*/
    }
    /*if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        system.debug('any');
        List<Registration__c> registrations = [
        SELECT Id,  Contact_Full_Name__c, Completed_Sessions_Count__c, ProgramCode__r.MinimumSessions__c,
            ExitType__c,Approved__c,ContactName__c,ProgramCode__c,ContactName__r.Email,ProgramCode__r.Email_Template_Id__c
        FROM Registration__c
        WHERE Id IN :Trigger.newMap.keySet()
    ];
        //EmailTemplateIdSave.emailTrigger4mRegistration(registrations);
    }*/
}