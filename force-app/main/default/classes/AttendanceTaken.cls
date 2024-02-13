public with sharing class AttendanceTaken {
    
    @AuraEnabled(cacheable=true)
    public static List<SessionWrapper> getSessionNumberPicklistValues(String id) {
        system.debug(id);
        List<String> picklistValues = new List<String>();
        List<SessionWrapper> options = new List<SessionWrapper>();
        List<Session__c> sessRecs = [select id, Name,SessionNumber__c, AttendanceTaken__c, SessionDate__c,
                                     Program__c from session__c where Program__c = :id order by SessionDate__c ASC];
        List<Attendance__c> attnds = [select id,Registration__c,Program__c,  Session__c, AttendedPartA__c, 
                                     AttendedPartB__c, AwardPartA__c, AwardPartB__c from Attendance__c where Program__c = :id  ];
        for(Session__c sess : sessRecs){
            picklistValues.add(sess.SessionNumber__c);
        }
        system.debug(picklistValues);
        // Schema.DescribeFieldResult fieldResult = Session__c.Session_Number__c.getDescribe();
        //List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        //for (Schema.PicklistEntry entry : picklistEntries) {
        //     picklistValues.add(entry.getValue());
        // }
        
        for (Session__c session : sessRecs) {
            options.add(new SessionWrapper(session.SessionNumber__c, session.SessionDate__c, session.id, session.Name));
        }
        
        system.debug(options);
        return options;
    }
    
    @AuraEnabled(cacheable=true)
    public static string getCustomSettings(){
        PushtoWebAccess__c acc = PushtoWebAccess__c.getInstance('API Access Token');
        system.debug(acc.RedirectURL__c);
       return acc.RedirectURL__c;
	}
    
    @AuraEnabled
    public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper) {
        try {
            if(inputWrapper != null){
                system.debug(inputWrapper);
                String fieldsToQuery = 'SELECT Id, ';
                if(string.isNotBlank(inputWrapper.fieldApiName)){
                    fieldsToQuery = fieldsToQuery + inputWrapper.fieldApiName;
                }
                if(string.isNotBlank(inputWrapper.otherFieldApiName)){
                    fieldsToQuery = fieldsToQuery + ', ' + inputWrapper.otherFieldApiName;
                }
                String query = fieldsToQuery + ' FROM '+ inputWrapper.objectApiName;
                system.debug(query);
                String filterCriteria = inputWrapper.fieldApiName + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 10';
                if(String.isNotBlank(inputWrapper.selectedRecordId)) {
                    system.debug(query);
                    query += ' WHERE Id = \''+ inputWrapper.selectedRecordId + '\'';
                }else if(String.isNotBlank(inputWrapper.parentFieldApiName) && String.isNotBlank(inputWrapper.parentRecordId)){
                    query += ' WHERE '+ inputWrapper.parentFieldApiName+ ' = \''+ inputWrapper.parentRecordId + '\'';
                    query += ' AND ' + filterCriteria;
                    system.debug(query);
                } 
                else {
                    system.debug(query);
                    query += ' WHERE '+ filterCriteria;
                }
                system.debug(query);
                List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
                for(SObject s : Database.query(query)) {
                    ResultWrapper wrap = new ResultWrapper();
                    wrap.mainField = (String)s.get(inputWrapper.fieldApiName);
                    //wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
                    system.debug((String)s.get('Id'));
                    wrap.id = (String)s.get('Id');
                    returnWrapperList.add(wrap);
                }
                system.debug(returnWrapperList);
                return returnWrapperList;
            }
            return null;
        } catch (Exception err) {
            throw new AuraHandledException(err.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Registration__c> getRegistrationsByProgramId(String programId){
        List<Registration__c> regs = new List<Registration__c>();
        try {

            regs = [SELECT Id, Name,ContactName__r.name,ProgramCode__c,ExitType__c FROM Registration__c WHERE ProgramCode__c = :programId and ExitType__c = '' order by  ContactName__r.LastName ASC  ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
		system.debug(regs);
        return regs;
    }

    @AuraEnabled(cacheable=true)
    public static List<Attendance__c> getSessionAttendance(List<Id> sessionIds, List<Id> registrationIds) {
        system.debug('registrationIds - '+registrationIds);
        system.debug('sessionIds - '+sessionIds);
        List<Attendance__c> attendanceRecords = new List<Attendance__c>();

        if (sessionIds != null && !sessionIds.isEmpty() && registrationIds != null && !registrationIds.isEmpty()) {
            system.debug('test');
            // Query the Attendance__c records based on the given session and registration IDs
            attendanceRecords = [SELECT Id, AttendedPartA__c, AttendedPartB__c, AwardPartA__c, AwardPartB__c, Session__c, Registration__c
                                 FROM Attendance__c
                                 WHERE Session__c IN :sessionIds AND Registration__c IN :registrationIds];
        }
		system.debug(attendanceRecords);
        return attendanceRecords;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Attendance__c> checkAttendanceTransfer(List<Id> sessionIds, List<Id> registrationIds, String programId) {
        system.debug('registrationIds - '+registrationIds);
        system.debug('sessionIds - '+sessionIds);
        List<Registration__c> regs = new List<Registration__c>();
        List<Attendance__c> attendanceRecords = new List<Attendance__c>();
		List<Attendance__c> norAtt = new List<Attendance__c>();
        List<Attendance__c> tranAtt = new List<Attendance__c>();
        if (sessionIds != null && !sessionIds.isEmpty() && registrationIds != null && !registrationIds.isEmpty()) {
            system.debug('test');
            // Query the Attendance__c records based on the given session and registration IDs
            attendanceRecords = [SELECT Id,Program__c, AttendedPartA__c, AttendedPartB__c, AwardPartA__c, AwardPartB__c, Session__c, Registration__c
                                 FROM Attendance__c
                                 WHERE Session__c IN :sessionIds AND Registration__c IN :registrationIds];
            regs =[select id ,Name ,(select id,registration__c from attendances__r) from Registration__c  where ProgramCode__c  = :programId  ];
        }
        for(Attendance__c at:attendanceRecords){
            if(at.AttendedPartA__c=='Yes (Transfer)' || at.AttendedPartA__c=='No (Transfer)' || at.AttendedPartA__c=='Makeup (Transfer)' ){
                tranAtt.add(at);
            }
            else if(at.AttendedPartA__c=='Yes' || at.AttendedPartA__c=='No' || at.AttendedPartA__c=='Makeup'){
                norAtt.add(at);
            }
            
        }
        system.debug('transfer - ' +tranAtt);
        system.debug('not transfer -'+norAtt);
        if(norAtt.isEmpty() && !tranAtt.isEmpty()){
            return tranAtt;
        }
        else{
            return null;
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<Registration__c> checkAttendanceExists(String programId, String sessionIds) {
        
        system.debug('programId - '+programId);
         List<Registration__c> registrationsWithoutAttendance = new List<Registration__c>();
        if (programId != null ) {
            system.debug('test');
           
            
            for (Registration__c reg : [SELECT Id, Name FROM Registration__c where ProgramCode__c = :programId]) {
                List<Attendance__c> relatedAttendances = [SELECT Id FROM Attendance__c WHERE Registration__c = :reg.Id and Session__c = :sessionIds];
                
                if (relatedAttendances.isEmpty()) {
                    registrationsWithoutAttendance.add(reg);
                }
            }
        }
        system.debug(registrationsWithoutAttendance.size());
        system.debug(registrationsWithoutAttendance);
        // system.debug(att.Registration__c);
        if(registrationsWithoutAttendance != null ||!(registrationsWithoutAttendance.isempty())){
            return registrationsWithoutAttendance;
            
        }
        else
            return null;
        
        
        
    }
        
        
    
    @AuraEnabled
    public static void insertAttendanceRec(String wrapParams, string sessionId, string prgmID, string sessName){
        system.debug('myListJSON -- ' +wrapParams);
        List<Attendance__c> attLists = new List<Attendance__c>();
        List<Attendance__c> createattLists = new List<Attendance__c>();
        List<Attendance__c> existingAttList = new List<Attendance__c>();
        List<Attendance__c> existingAttList1 = new List<Attendance__c>();
        list<Registration__c> regLists = new list<Registration__c>();
        set<ID> ids = new set<ID>();
        set<ID> regIds = new set<ID>();
        String contactName = '';
        if(prgmID!=null){
            if(wrapParams!=null){
                List<createAttendance> updatedAttList = (List<createAttendance>) JSON.deserialize(wrapParams, List<createAttendance>.class);
            
            for (createAttendance updatedAtt : updatedAttList) {
                regIds.add(updatedAtt.registrationId);
            }
            }
            existingAttList = [SELECT Id, Name, AttendedPartA__c, AttendedPartB__c, AwardPartA__c, AwardPartB__c,
                               Program__c, Session__c, Registration__c FROM Attendance__c
                               WHERE Session__c = :sessionId AND Program__c =:prgmID  ];
            // createAttendance item= (createAttendance)JSON.deserialize(wrapParams,createAttendance.Class);if(prgmID!=null){
            regLists=[select id,Name,ContactName__r.name,ProgramCode__c from Registration__c where ProgramCode__c =:prgmID];
            system.debug('existingAttList - ' +existingAttList);
        }
        if(existingAttList.isempty()){
            for(Registration__c reg :regLists){
                 contactName = reg.ContactName__r.Name;
                Attendance__c attd = new Attendance__c();
                attd.name= contactName +' - '+sessName;
                attd.AttendedPartA__c ='Yes';
                attd.AttendedPartB__c ='Yes';
                attd.Program__c = prgmID;
                attd.Registration__c = reg.id;
                attd.Session__c = sessionId;
                
                attLists.add(attd);
                ids.add(reg.id);
            }
            if(attLists.size()>0) {
                system.debug('full - '+attLists);
                Database.upsertResult[] results = Database.upsert(attLists, Attendance__c.id,false);
                for (Database.upsertResult result : results) {
                    if (result.isSuccess()) {
                        Session__c s = new Session__c();
                        s.id= sessionId;
                        s.AttendanceTaken__c = true;
                        
                        update s;
                        System.debug('The session is updated. ' +s.id);
                    }else{
                        for(Database.Error err : result.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Attendance fields that affected this error: ' + err.getFields());
                        }
                        
                    }
                }
                
                
                
            }
            attLists.clear();
        }else if(!(existingAttList.isempty())){
            List<Registration__c> registrationsWithoutAttendance = new List<Registration__c>();
            for (Registration__c reg : [SELECT Id, Name,ContactName__r.Name FROM Registration__c where ProgramCode__c = :prgmID]) {
                List<Attendance__c> relatedAttendances = [SELECT Id FROM Attendance__c WHERE Registration__c = :reg.Id and Session__c = :sessionId];
                
                if (relatedAttendances.isEmpty()) {
                    registrationsWithoutAttendance.add(reg);
                }
            }
            system.debug('registrationsWithoutAttendance - ' +registrationsWithoutAttendance);
            for(Registration__c reg :registrationsWithoutAttendance){
                contactName = reg.ContactName__r.Name;
                Attendance__c attd = new Attendance__c();
                attd.name= contactName +' - '+sessName;
                attd.AttendedPartA__c ='Yes';
                attd.AttendedPartB__c ='Yes';
                attd.Program__c = prgmID;
                attd.Registration__c = reg.id;
                attd.Session__c = sessionId;
                
                attLists.add(attd);
                ids.add(reg.id);
            }
            if(attLists.size()>0) {
                system.debug('half - '+attLists);
                Database.SaveResult[] results = Database.insert(attLists, false);
                for (Database.SaveResult result : results) {
                    if (result.isSuccess()) {
                        System.debug('The Attendance is created. ' );
                    }else{
                        for(Database.Error err : result.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Attendance fields that affected this error: ' + err.getFields());
                        }
                        
                    }
                }
               }
            attLists.clear();

                }
           system.debug('updated att if- existingAttList '+existingAttList);
        List<String> regId = new List<String>();
        if(wrapParams!=null){
            existingAttList1 = [SELECT Id, Name, AttendedPartA__c, AttendedPartB__c, AwardPartA__c, AwardPartB__c,
                                Program__c, Session__c, Registration__c FROM Attendance__c
                                WHERE Session__c = :sessionId AND Program__c =:prgmID ];
            
            for(Attendance__c attRegId : existingAttList1){
                regId.add(attRegId.Registration__c);
            }
            system.debug('updated att if- existingAttList '+existingAttList1);
            List<createAttendance> updatedAttList = (List<createAttendance>) JSON.deserialize(wrapParams, List<createAttendance>.class);
            
            for (createAttendance updatedAtt : updatedAttList) {
                for (Attendance__c existingAtt : existingAttList1) {
                    system.debug('updated att - '+updatedAtt);
                    if (existingAtt.Registration__c == updatedAtt.registrationId) {
                        existingAtt.AttendedPartA__c = updatedAtt.attendedPartA != null ? updatedAtt.attendedPartA : 'Yes';
                        existingAtt.AttendedPartB__c = updatedAtt.attendedPartB != null ? updatedAtt.attendedPartB : 'Yes';
                        existingAtt.AwardPartA__c = updatedAtt.awardPartA;
                        existingAtt.AwardPartB__c = updatedAtt.awardPartB;
                        existingAtt.Session__c = sessionId;
                        attLists.add(existingAtt);
                        break;
                    } else if(!(regId.contains(updatedAtt.registrationId))){
                        
                		Attendance__c attdnce = new Attendance__c();
                        attdnce.name= updatedAtt.contactName +' - '+sessName;
                        attdnce.AttendedPartA__c = updatedAtt.attendedPartA != null ? updatedAtt.attendedPartA : 'Yes';
                        attdnce.AttendedPartB__c = updatedAtt.attendedPartB != null ? updatedAtt.attendedPartB : 'Yes';
                        attdnce.AwardPartA__c = updatedAtt.awardPartA;
                        attdnce.AwardPartB__c = updatedAtt.awardPartB;
                        existingAtt.Session__c = sessionId;
                        createattLists.add(attdnce);
                    }
                }
            }
            
            
            
        }
        system.debug(attLists);
        if (!attLists.isEmpty()) {
            Database.upsertResult[] results = Database.upsert(attLists,Attendance__c.id, false);
            for (Database.upsertResult result : results) {
                if (result.isSuccess()) {
                   Session__c s = new Session__c();
                        s.id= sessionId;
                        s.AttendanceTaken__c = true;
                        update s;
                        System.debug('The session is updated. ' +s.id);
                    }else{
                        for(Database.Error err : result.getErrors()) {
                                System.debug('The following error has occurred while updte.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Attendance fields that affected this error: ' + err.getFields());
        }
                        
                }
            }
        }
        if (!createattLists.isEmpty()) {
            Database.SaveResult[] results = Database.insert(createattLists, false);
            for (Database.SaveResult result : results) {
                if (result.isSuccess()) {
                   Session__c s = new Session__c();
                        s.id= sessionId;
                        s.AttendanceTaken__c = true;
                        update s;
                        System.debug('The session is updated. ' +s.id);
                    System.debug('The Attendance is updated for - ' +s.id);
                    }else{
                        for(Database.Error err : result.getErrors()) {
                                System.debug('The following error has occurred while updte.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Attendance fields that affected this error: ' + err.getFields());
        }
                        
                }
            }
        }
    }
    
    public class ResultWrapper{
        @AuraEnabled public String mainField{get;set;}
        //@AuraEnabled public String subField{get;set;}
        @AuraEnabled public String id{get;set;}
    }
    
    public class createAttendance {
        @AuraEnabled public String prgmID{get;set;}
        @AuraEnabled public String sessionId{get;set;}
        @AuraEnabled public String sessionName{get;set;}
        
        @AuraEnabled public String awardPartA{get;set;}
        @AuraEnabled public String awardPartB{get;set;}
        
        @AuraEnabled public String attendedPartA{get;set;}
        @AuraEnabled public String attendedPartB{get;set;}
        @AuraEnabled public String registrationId{get;set;}
        
        @AuraEnabled public String contactName{get;set;}
    }
    
    public class SearchWrapper {
        @AuraEnabled public String objectApiName{get;set;}
        @AuraEnabled public String fieldApiName{get;set;}
        @AuraEnabled public String otherFieldApiName{get;set;}
        @AuraEnabled public String searchString{get;set;}
        @AuraEnabled public String selectedRecordId{get;set;}
        @AuraEnabled public String parentRecordId{get;set;}
        @AuraEnabled public String parentFieldApiName{get;set;}
        
    }
    
    public class SessionWrapper {
        @AuraEnabled public String sessionNumber;
        @AuraEnabled public Date sessionDate;
        @AuraEnabled public String id;
        @AuraEnabled public String sessionName;
        
        public SessionWrapper(String sessionNumber, Date sessionDate, String id, String sessionName) {
            this.sessionNumber = sessionNumber;
            this.sessionDate = sessionDate;
            this.id = id;
            this.sessionName = sessionName;
        }
    }
}