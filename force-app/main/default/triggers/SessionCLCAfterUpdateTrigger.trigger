trigger SessionCLCAfterUpdateTrigger on Session_CLC_Event__c (after update,after insert) {

    SessionCLCAfterUpdateTrigger sf = new SessionCLCAfterUpdateTrigger();
    //system.debug('Trigger.new[0].SessionDate__c  ' + Trigger.new[0].Session_Date__c );
    //system.debug('Trigger.oldMap.get(Trigger.new[0].id).SessionDate__c '+ Trigger.oldMap.get(Trigger.new[0].id).Session_Date__c);
    if(trigger.isAfter && trigger.isUpdate){
        if(Trigger.new[0].Session_Date__c != Trigger.oldMap.get(Trigger.new[0].id).Session_Date__c){
    		sf.handleAfterUpdate(trigger.new,Trigger.oldMap);
        }
    }
    
    if(trigger.isAfter && trigger.isInsert){
        system.debug('Trigger.new  '+ Trigger.new);
        List<Session_CLC_Event__c> slist = new List<Session_CLC_Event__c>();
        system.debug('length '+ Trigger.new.size() );
        for(Session_CLC_Event__c s : Trigger.new){
       List<Trainer_Certification_Event__c> TCE = [select id,Session_One_Start_DateTime__c ,Session_One_End_Date_Time__c from Trainer_Certification_Event__c where Id =: Trigger.new[0].Trainer_Certification_Event__c];
       Session_CLC_Event__c sess = [select id,Session_Start_Time__c,Session_End_Time__c from Session_CLC_Event__c where Id =: s.id ];
       system.debug('TCE  '+TCE);
        SYSTEM.DEBUG('sess  '+sess);
       sess.Session_Start_Time__c = TCE[0].Session_One_Start_DateTime__c.TIME();
       sess.Session_End_Time__c = TCE[0].Session_One_End_Date_Time__c.TIME();
            slist.add(sess);
        system.debug('TCE[0].Session_One_Start_DateTime__c.TIME()  '+TCE[0].Session_One_Start_DateTime__c.TIME());    
            system.debug('TCE[0].Session_One_End_Date_Time__c.TIME()  '+TCE[0].Session_One_End_Date_Time__c.TIME()); 
        }
        update slist;
    }

}