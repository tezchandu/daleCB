trigger SessionAfterUpdateTrigger on Session__c (after update) {
     SessionAfterUpdateTrigger sf = new SessionAfterUpdateTrigger();
   /* list<session__c> sess = [select id ,SessionNumber__c ,SessionDate__c  from session__c where 
                             SessionNumber__c!='Orientation' and SessionNumber__c!='Awareness' and SessionNumber__c!='Sustainment'];
        */
   
    sf.handleAfterUpdate(trigger.new,Trigger.oldMap);
    //System.debug('Trigger.new() '+Trigger.new);
     Set<Id> sessionIdsToSendEmail = new Set<Id>();
    
    for (Session__c session : Trigger.new) {
        Session__c oldSession = Trigger.oldMap.get(session.Id);
        
        if (session.AttendanceTaken__c != oldSession.AttendanceTaken__c) {
            sessionIdsToSendEmail.add(session.Id);
        }
    }
    system.debug('sessionIdsToSendEmail - '+sessionIdsToSendEmail);
    if (!sessionIdsToSendEmail.isEmpty()) {
       
        //System.enqueueJob(TestSendEmailTemplate.testSendEmail(sessionIdsToSendEmail));
        AttendanceEmailSendClass.testSendEmail(sessionIdsToSendEmail);
    }
    
    
}