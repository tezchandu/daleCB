/*
    01.18.2023	Sophia Murphy (Demand Chain)
				Updated to handle cases that are auto-related to DFG contacts
    02.03.2023	Sophia Murphy (Demand Chain)
				Update to 1/18 change - needs to be applied to ALL non-Franchising contacts; not JUST DFG
*/
public with sharing class CaseAfterTriggerHandler {
    public static void handleTrigger(Map<Id,Case> triggerNewMap) {
        System.debug('DC: CaseAfterTrigger');
        Map<Id, CaseContactInfo> newCaseContactInfos = new Map<Id, CaseContactInfo>();
        List<CaseContactInfo> caseContactInfos = new List<CaseContactInfo>();
        List<String> caseEmailAddresses = new List<String>();
        Map<String, Id> caseEmailAddressMap = new Map<String, Id>();
        Map<Id, Id> existingContactIds = new Map<Id, Id>();
        /* Map<Id,Id> updateCaseContactIds = new Map<Id,Id>(); */
        /* Map<String, List<Contact>> existingEmailContacts = new Map<String, List<Contact>>(); */
        
        for (Case c : triggerNewMap.values()) {
           System.debug('DC: ContactId: ' + c.ContactId);
           if (c.ContactId == null) {
                caseEmailAddressMap.put(c.SuppliedEmail, c.Id);
           }
           //In the cases where there IS a contactId... it could be that this email address already
           //exists as a DFG contact, not a Franchising contact
           //We need to make sure it's related to the right type of contact too.  
            if(c.ContactId != null) {
                existingContactIds.put(c.ContactId, c.Id);
            }  
        }
        
        System.debug('DC: caseEmailAddressMap: ' + caseEmailAddressMap);
        System.debug('DC: existingContactIds: ' + existingContactIds);

        if(existingContactIds.size() > 0) {
            for(Contact cnt : [SELECT Id, Email, Franchise_ID__c FROM Contact WHERE Id IN :existingContactIds.keySet()]) {
                //If this is a DFG contact... we need to put their email and Case Id in the list... so it gets reassigned
                //if(cnt.Franchise_ID__c == 'DFG') {
                if(cnt.Franchise_ID__c != 'Franchising') {
                    caseEmailAddressMap.put(cnt.Email, existingContactIds.get(cnt.Id));
                }
            }
        }
        
        System.debug('DC: caseEmailAddressMap: ' + caseEmailAddressMap);

        Map<Id,Id> updateCaseContactIds = CaseContactHandler.fetchExistingCaseContacts(caseEmailAddressMap);
        System.debug('DC: updateCaseContact ' + updateCaseContactIds);

        for (Id caseId : caseEmailAddressMap.values()) {
            if (!updateCaseContactIds.keySet().contains(caseId)) {
                String name = String.isBlank(triggerNewMap.get(caseId).SuppliedName) ? 'Unknown' : triggerNewMap.get(caseId).SuppliedName;
                CaseContactInfo newCaseContactInfo = new CaseContactInfo(name, triggerNewMap.get(caseId).SuppliedEmail);
                caseContactInfos.add(newCaseContactInfo);
        }

        List<Contact> newContacts = CaseContactHandler.createNewContact(caseContactInfos);

        for (Contact newContact : newContacts) {
            updateCaseContactIds.put(caseEmailAddressMap.get(newContact.Email), newContact.Id);
        }

        CaseContactHandler.attachContactToCase(updateCaseContactIds);
        }
    }
}