public with sharing class Graduation_Helper_Class {
   @AuraEnabled(cacheable=true)
        public static List<SessionWrapper> getSessionNumberPicklistValues(String id) {
            system.debug(id);
            List<String> picklistValues = new List<String>();
            List<SessionWrapper> options = new List<SessionWrapper>();
            List<Session__c> sessRecs = [select id, Name,SessionNumber__c, AttendanceTaken__c, SessionDate__c,
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
                options.add(new SessionWrapper(session.SessionNumber__c, session.SessionDate__c, session.id, session.Name));
            }
            system.debug(options);
            return options;
        }
}