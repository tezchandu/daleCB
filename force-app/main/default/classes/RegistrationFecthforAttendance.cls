public with sharing class RegistrationFecthforAttendance {
    @AuraEnabled(cacheable=true)
    public static List<Registration__c> getRegistrationsByProgramId(String programId) {
    return [SELECT Id, Name,ContactName__r.name,ProgramCode__c FROM Registration__c WHERE ProgramCode__c = :programId  WITH SECURITY_ENFORCED];
    }
}