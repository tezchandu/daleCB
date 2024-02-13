public with sharing class EmailTemplateIdSave {
    @AuraEnabled(cacheable=true)
    public static string getProgramRec(String id){
        System.debug('id - '+id);
        String emailTemName ='';
        Program__c program = [select id ,Email_Template_Id__c from Program__c where id =:id];
        if(program!=null){
            EmailTemplate emp= [select id ,Name from EmailTemplate where id =:program.Email_Template_Id__c];
            if(emp!=null)
            emailTemName= emp.Name;
        else
            emailTemName = '';
        }
        
        return emailTemName ;
    }
    @AuraEnabled
    public static void handleSave(String emailId, string prgmID){
        system.debug('email id  -  ' +emailId);
        system.debug('prgmID - '+prgmID);
        Program__c p = new Program__c();
        p.Email_Template_Id__c = emailId;
        p.id = prgmID;
        system.debug(p);
        update p;
    }
    public static void emailTrigger4mRegistration(List<Registration__c> regs){
        List<Registration__c> toSend = new List<Registration__c>();
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {};
        List<String> toAddresses = new List<String>();
        Registration__c rgEmail = [select id,ProgramCode__r.Email_Template_Id__c from Registration__c where id in:regs limit 1 ];
        List<Registration__c> registrations = [
        SELECT Id,  Contact_Full_Name__c, Completed_Sessions_Count__c, ProgramCode__r.MinimumSessions__c,
            ExitType__c,Approved__c,ContactName__c,ProgramCode__c,ContactName__r.Email,ProgramCode__r.Email_Template_Id__c
        FROM Registration__c
        WHERE Id IN :regs
    ];
        EmailTemplate emailTemplate =[Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where id= :rgEmail.ProgramCode__r.Email_Template_Id__c];
        for(Registration__c rg :registrations){
            if(rg.Approved__c == true && rg.ContactName__c!=null && rg.ContactName__r.Email != null && rg.ProgramCode__c!= null){
                system.debug(rg);
                toSend.add(rg);
                toAddresses.add(rg.ContactName__r.Email);
            }
        }
        for(Registration__c rg:toSend){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateID(emailTemplate.Id);
            //if(ons.email!=null)
            mail.toAddresses = new String[] {'chandana.ch@springml.com'}; 
                    // String[] toAddresses = new String[] {};'6month-lhi@propartnershealthcare.com'
                    
                    //mail.setWhatId(ons.Contact__c);
            mail.setTargetObjectId(rg.ContactName__c);
            mail.setTreatTargetObjectAsRecipient(false);
             //mail.setTargetObjectId('xxxxxxxxxxx');// This is the ID of rel 
       // mail.setSaveAsActivity(false);
        mail.setWhatId('a0v3J0000001SY5QAM');
            //mail.setOrgWideEmailAddressId(owa.id);
            messages.add(mail);
            // onsListUpdate.add(ons);
            
        }
        try{
            if(messages.size()>0){
                system.debug('mes - '+messages);
                messaging.sendEmail(messages);
               }
        }
        catch(Exception e){
            
        }
        
    }
}