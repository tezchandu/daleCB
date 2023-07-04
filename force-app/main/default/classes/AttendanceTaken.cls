public with sharing class AttendanceTaken {
    
        @AuraEnabled(cacheable=true)
        public static List<SessionWrapper> getSessionNumberPicklistValues(String id) {
            system.debug(id);
            List<String> picklistValues = new List<String>();
            List<SessionWrapper> options = new List<SessionWrapper>();
            List<Session__c> sessRecs = [select id, SessionNumber__c, AttendanceTaken__c, SessionDate__c,
            Program__c from session__c where Program__c = :id WITH SECURITY_ENFORCED];
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
            options.add(new SessionWrapper(session.SessionNumber__c, session.SessionDate__c));
        }
        system.debug(options);
        return options;
        }
        public static void insertAttendanceRec(){

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

    public class ResultWrapper{
        @AuraEnabled public String mainField{get;set;}
        //@AuraEnabled public String subField{get;set;}
        @AuraEnabled public String id{get;set;}
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
            
            public SessionWrapper(String sessionNumber, Date sessionDate) {
                this.sessionNumber = sessionNumber;
                this.sessionDate = sessionDate;
            }
        }
}