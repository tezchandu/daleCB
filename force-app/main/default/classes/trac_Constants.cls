public with sharing class trac_Constants {
    //RecordTypes for sOBjects
    public Static String dfgAccountRT = Schema.SObjectType.Account.RecordTypeInfosByName.get('DFG Account').RecordTypeId; // Added as a part of Org Merge
    public Static String dfgLeadRT = Schema.SObjectType.Lead.RecordTypeInfosByName.get('DFG Lead').RecordTypeId; // Added as a part of Org merge
    public Static String dfgOppRT = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('DFG Opportunity').RecordTypeId; // Added as a part of Org merge 
    public Static String dfgConRT = Schema.SObjectType.Contact.RecordTypeInfosByName.get('DFG Contacts').RecordTypeId;  
    public static String dfgTaskRT = Schema.SObjectType.Task.RecordTypeInfosByName.get('DFG Task').RecordTypeId; //DFG Event
    public static String dfgEventRT = Schema.SObjectType.Event.RecordTypeInfosByName.get('DFG Event').RecordTypeId;
}