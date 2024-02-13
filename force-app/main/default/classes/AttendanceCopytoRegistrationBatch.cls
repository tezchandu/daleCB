global class AttendanceCopytoRegistrationBatch implements Database.Batchable<SObject> { 
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([select id,Session__c, Session__r.SessionNumber__c, Session__r.Name, Session_Attendance_Taken__c,
                                         Session_Number__c, Session__r.SessionDate__c, Registration__c, Registration__r.Session_1_Award__c, 
                                         Registration__r.Session_1_Date__c, Registration__r.Attended_Session_1__c, AttendedPartA__c,
                                         AttendedPartB__c, AwardPartA__c, AwardPartB__c, AwardPartA__r.Name, AwardPartB__r.Name
                                         from Attendance__c where Program__c != null and Registration__c != null]);
    }
    global void execute(Database.BatchableContext context, List<Attendance__c> scope) {
        List<Registration__c> regslist = new List<Registration__c>();
        set<registration__c> regs = new set<registration__c>();
        Set<Id> registrationIds = new Set<Id>();
        
        for (Attendance__c att : scope) {
            if (att.Session__r.SessionNumber__c == '1') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '2') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '3') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '4') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '5') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '6') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '7') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '8') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '9') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '10') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '11') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '12') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '13') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '14') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '15') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == '16') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == 'Awareness') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == 'Sustainment') {
                registrationIds.add(att.Registration__c);
            }
            
            if (att.Session__r.SessionNumber__c == 'Orientation') {
                registrationIds.add(att.Registration__c);
            }
        }
        
        for (Id regId : registrationIds) {
            Registration__c reg = new Registration__c();
            reg.Id = regId;
            
            
            for (Attendance__c att : scope) {
                if (att.Registration__c == regId) {
                    //For Session number 1
                    if (att.Session__r.SessionNumber__c == '1') {
                        reg.Session_1_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_1_Date__c = att.Session__r.SessionDate__c;
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes') ||
                          (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes (Transfer)'))
                        {
                            reg.Attended_Session_1__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ||
                          (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No (Transfer)')){
                               
                               reg.Attended_Session_1__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes') ||
                          (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                          (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Makeup'))
                            
                        {
                            reg.Attended_Session_1__c = 'Makeup';
                        }
                        
                    }
                    
                    //For session number 2
                    
                    if (att.Session__r.SessionNumber__c == '2') {
                        reg.Session_2_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_2_Date__c = att.Session__r.SessionDate__c;
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_2__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_2__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_2__c = 'Makeup';
                        }
                    }
                    
                    //For session 3
                    
                    if (att.Session__r.SessionNumber__c == '3') {
                        reg.Session_3_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_3_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_3__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_3__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_3__c = 'Makeup';
                        }
                        
                    }
                    
                    //For Session 4
                    if (att.Session__r.SessionNumber__c == '4') {
                        reg.Session_4_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_4_Date__c = att.Session__r.SessionDate__c;
                        
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_4__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_4__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_4__c = 'Makeup';
                        }
                    }
                    
                    //For session 5
                    if (att.Session__r.SessionNumber__c == '5') {
                        reg.Session_5_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_5_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_5__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_5__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_5__c = 'Makeup';
                        }
                    }
                    
                    //For session 6
                    if (att.Session__r.SessionNumber__c == '6') {
                        reg.Session_6_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_6_Date__c = att.Session__r.SessionDate__c;
                        
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_6__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_6__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_6__c = 'Makeup';
                        }
                    }
                    
                    //For session 7
                    if (att.Session__r.SessionNumber__c == '7') {
                        reg.Session_7_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_7_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_7__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_7__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_7__c = 'Makeup';
                        }
                    }
                    
                    //For session 8
                    if (att.Session__r.SessionNumber__c == '8') {
                        reg.Session_8_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_8_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_8__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_8__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_8__c = 'Makeup';
                        }
                    }
                    
                    //For session 9
                    
                    if (att.Session__r.SessionNumber__c == '9') {
                        reg.Session_9_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_9_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_9__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_9__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_9__c = 'Makeup';
                        }
                    }
                    
                    //For session 10
                    if (att.Session__r.SessionNumber__c == '10') {
                        reg.Session_10_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_10_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_10__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_10__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_10__c = 'Makeup';
                        }
                    }
                    
                    //For session 11
                    
                    if (att.Session__r.SessionNumber__c == '11') {
                        reg.Session_11_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_11_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_11__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_11__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_11__c = 'Makeup';
                        }
                    }
                    
                    //For session 12
                    if (att.Session__r.SessionNumber__c == '12') {
                        reg.Session_12_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_12_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_12__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_12__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_12__c = 'Makeup';
                        }
                    }
                    
                    //For session 13
                    
                    if (att.Session__r.SessionNumber__c == '13') {
                        reg.Session_13_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_13_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_13__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_13__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_13__c = 'Makeup';
                        }
                        reg.Attended_Session_13__c = 'Yes';
                    }
                    
                    //For session 14
                    if (att.Session__r.SessionNumber__c == '14') {
                        reg.Session_14_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_14_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_14__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_14__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_14__c = 'Makeup';
                        }
                    }
                    
                    //For session 15
                    if (att.Session__r.SessionNumber__c == '15') {
                        reg.Session_15_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_15_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_15__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_15__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_15__c = 'Makeup';
                        }
                    }
                    
                    //For session 16
                    if (att.Session__r.SessionNumber__c == '16') {
                        reg.Session_16_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Session_16_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Session_16__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Session_16__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Session_16__c = 'Makeup';
                        }
                    }
                    
                    //For session sustainment
                    if (att.Session__r.SessionNumber__c == 'Sustainment') {
                        reg.Sustainment_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Sustainment_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Sustainment__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Sustainment__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Sustainment__c = 'Makeup';
                        }
                    }
                    
                    //For session Orientation
                    
                    if (att.Session__r.SessionNumber__c == 'Orientation') {
                        reg.Orientation_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        reg.Orientation_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Orientation__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Orientation__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Orientation__c = 'Makeup';
                        }
                    }
                    
                    //For session Awareness
                    if (att.Session__r.SessionNumber__c == 'Awareness') {
                        reg.Awareness_Award__c = (att.AwardPartA__r.Name != null ? att.AwardPartA__r.Name : '') +
                            (att.AwardPartB__r.Name != null ? (att.AwardPartA__r.Name != null ? ', ' : '') + att.AwardPartB__r.Name : '');
                        
                        //  reg.Awareness_Date__c = att.Session__r.SessionDate__c;
                         if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'Yes'))
                        {
                            reg.Attended_Awareness__c = 'Yes';
                        }
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes')||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup') || 
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Yes (Transfer)' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'Yes (Transfer)') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No') ||
                           (att.AttendedPartA__c == 'No' && att.AttendedPartB__c == 'No (Transfer)') ||
                           (att.AttendedPartA__c == 'No (Transfer)' && att.AttendedPartB__c == 'No') ){
                               
                               reg.Attended_Awareness__c = 'No';
                           }
                        
                        if((att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup') ||
                           (att.AttendedPartA__c == 'Makeup' && att.AttendedPartB__c == 'Yes') ||
                           (att.AttendedPartA__c == 'Yes' && att.AttendedPartB__c == 'Makeup (Transfer)') ||
                           (att.AttendedPartA__c == 'Makeup (Transfer)' && att.AttendedPartB__c == 'Yes'))
                            
                        {
                            reg.Attended_Awareness__c = 'Makeup';
                        }
                    }
                }
            }     
            regslist.add(reg);
        }
        
        
        if(regslist.size()>0){
            system.debug(regslist);
            database.update(regslist,false);
        }
    }
    
    global void finish(Database.BatchableContext context) {
    }
    
}