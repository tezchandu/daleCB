trigger AttendanceTrigger on Attendance__c (before insert, before update, after insert, after update) {
    // Process sharing rules 
		Set<Id> attendanceIdsToSendEmail = new Set<Id>();
    	Set<Id> sessionIdsToSendEmail = new Set<Id>();
if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleAttendance(Trigger.new);
    }
    if(trigger.isBefore && trigger.isupdate){
        for(Attendance__c atnd : trigger.new){
            string atndOwnerId = atnd.OwnerId;
        Attendance__c atndOld = trigger.oldMap.get(atnd.id);
            if(atndOld!=null){
            string atndOwnerIdOld = atndOld.OwnerId;
            if(atndOwnerId!= atndOwnerIdOld){
                FranchiseSharingHandler.handleAttendance(Trigger.new);
            }
            }
            }
    }
    if( (Trigger.isAfter && Trigger.isUpdate)){
        
        for (Attendance__c attendance : Trigger.new) {
            Attendance__c oldAttendance = new Attendance__c();
            //system.debug(Trigger.oldMap.get(attendance.Id));
            if(Trigger.isAfter && Trigger.isUpdate && attendance.Session__c!=null){
         		oldAttendance = Trigger.oldMap.get(attendance.Id);
            }
            else
                 oldAttendance = attendance; 
            if(attendance.Session__c!=null){
        Session__c session = [select id,AttendanceTaken__c from session__c where id =:attendance.Session__c limit 1];
            if(session!=null ){
        if (session.AttendanceTaken__c == TRUE && ( oldAttendance.Session_Completed__c !=attendance.Session_Completed__c ||
                                                 oldAttendance.AwardPartA__c!= attendance.AwardPartA__c ||
                                                  attendance.AwardPartB__c != oldAttendance.AwardPartB__c) ) {
           attendanceIdsToSendEmail.add(attendance.Id);
           sessionIdsToSendEmail.add(session.Id);
        }
            }
            }
    }
        system.debug('attendanceIdsToSendEmail - '+attendanceIdsToSendEmail);
        system.debug('sessionIdsToSendEmail - '+sessionIdsToSendEmail);
        if (!attendanceIdsToSendEmail.isEmpty()) {
       
        //System.enqueueJob(TestSendEmailTemplate.testSendEmail(sessionIdsToSendEmail));
        AttendanceEmailSendClass.testSendEmail(sessionIdsToSendEmail);
    }
    
    }
    
    
    }