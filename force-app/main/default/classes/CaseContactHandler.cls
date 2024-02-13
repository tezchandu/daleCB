/*
    01.18.2023	Sophia Murphy (Demand Chain)
				Updated to handle cases that are auto-related to DFG contacts
*/
public with sharing class CaseContactHandler {
    public static void handleEmailTrigger(Map<Id, EmailMessage> triggerNewMap) {
        System.debug('DC: entering handleEmailTrigger');
        EmailMessage em = triggerNewMap.values()[0];
        //if (em.ParentId == null) {
        if(em.Incoming == true && em.ParentId != null) {
            Map<Id,Id> caseContactMap = fetchExistingCaseContacts(new Map<String, Id> {em.FromAddress => em.ParentId} );
            if (caseContactMap.keySet().isEmpty()) {
                CaseContactInfo newContactInfo = new CaseContactInfo(em.FromName, em.FromAddress);
                Contact newContact = createNewContact(new List<CaseContactInfo> { newContactInfo })[0];
                caseContactMap.put(em.ParentId, newContact.Id);
            }
            System.debug('DC: emailTrigger: ' + caseContactMap);
            attachContactToCase(caseContactMap);
        }
    }

    public static List<Contact> createNewContact(List<CaseContactInfo> contactInfos) {
        System.debug('DC: entering createNewContact');
        //Create new contact for where no contact was found, and attach it to the generic unassigned account
        List<Contact> newContacts = new List<Contact>();
        Map<Id,Id> caseContacts = new Map<Id,Id>();

        for (CaseContactInfo cci : contactInfos) {
            Contact newContact = new Contact(FirstName = cci.FirstName, LastName = cci.LastName, Email = cci.EmailAddress, Accountid=System.Label.UnassignedContactAccountForServiceCloud);
            newContacts.add(newContact);
        }
        
        insert newContacts;
        return newContacts;
    }

    public static void attachContactToCase(Map<Id,Id> caseContactIdMap) {
        System.debug('DC: entering attachContactToCase');
        System.debug('DC: caseContactIdMap123: ' + caseContactIdMap);
        List<Case> updateCases = new List<Case>();
        for(Case cs : [Select id, ContactId From case where Id IN :caseContactIdMap.keySet()]){
            System.debug('DC: cs: ' + cs);
            Id newContactId = caseContactIdMap.get(cs.id);
            //12.13.2023	Sophia Murphy (Demand Chain)
            //Updated to NOT update the contactId if it's already been set - only if it's empty
            //if(newContactId != null && (cs.ContactId == null || cs.ContactId != newContactId) ) {
            if(newContactId != null && cs.ContactId == null) {
               Case updateCase = new Case();
               updateCase.Id = cs.id;
               updateCase.ContactId = caseContactIdMap.get(cs.id);
               updateCases.add(updateCase);
            } 
      	}
      /*
      for (Id caseId : caseContactIdMap.keySet()) {
            if(caseId != null) {
                Case updateCase = new Case();
                updateCase.Id = caseId;
                updateCase.ContactId = caseContactIdMap.get(caseId);
                updateCases.add(updateCase);
            }
        }
        */
        System.debug('DC: updateCases: ' + updateCases);
        if(updateCases.size() > 0) {
            update updateCases;
        }
    }

    //returns a map of 
    public static Map<Id,Id> fetchExistingCaseContacts(Map<String, Id> emailCaseIdMap) {
        System.debug('DC: entering fetchExistingCaseContacts');
        Map<Id,Id> returnCaseContactIdMap = new Map<Id, Id>(); 
        List<Contact> existingContacts = [SELECT Id, Email, Contact_Status__c, Account.Status__c FROM Contact WHERE Email IN :emailCaseIdMap.keySet() AND Franchise_Id__c = 'Franchising'];
        System.debug('DC: existing contacts ' + existingContacts);
        Map<String, List<Contact>> existingEmailContactMap = new Map<String, List<Contact>>();

        for (Contact c : existingContacts) {
            if (existingEmailContactMap.containsKey(c.Email)) {
                existingEmailContactMap.get(c.Email).add(c);
            } else {
                existingEmailContactMap.put(c.Email, new List<Contact> { c });
            }
        }
        
        for (String emailAddress : existingEmailContactMap.keySet()) {
            if (existingEmailContactMap.get(emailAddress).size() > 1) {
                Boolean hasActiveContact = false;
                for (Contact existingContact : existingEmailContactMap.get(emailAddress)) {
                    System.debug('DC: existing contact ' + existingContact.Contact_Status__c + ' ' + existingContact.Account.Status__c);
                    if (existingContact.Contact_Status__c == 'Active' && existingContact.Account.Status__c == 'Active') {
                        System.debug('DC: active contact ' + existingContact.Id);
                        returnCaseContactIdMap.put(emailCaseIdMap.get(emailAddress), existingContact.Id);
                        break;
                    } else if (existingContact.Contact_Status__c == 'Active' && !hasActiveContact) {
                        returnCaseContactIdMap.put(emailCaseIdMap.get(emailAddress), existingContact.Id);
                        hasActiveContact = true;
                    } else if (!hasActiveContact) {
                        returnCaseContactIdMap.put(emailCaseIdMap.get(emailAddress), existingContact.Id);
                    }
                }
            } else {
                returnCaseContactIdMap.put(emailCaseIdMap.get(emailAddress), existingEmailContactMap.get(emailAddress)[0].Id);
            }
        }

        System.debug('DC: returnCaseContactIdMap ' + returnCaseContactIdMap);

        return returnCaseContactIdMap;
    }
}