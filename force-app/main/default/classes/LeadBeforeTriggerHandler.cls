public with sharing class LeadBeforeTriggerHandler {
    
    //For web2lead forms, leads come in with no owner
    // and don't have an owner until the after trigger.
    // updated to skip over this if no lead is known.
    public static void setCurrencyIsoCode (List<Lead> leads) {
        System.debug('M360: ' + leads);
        Set<String> userIds = new Set<String>();
        for (Lead l : leads) {
            if(l.OwnerId != null && l.recordTypeId != trac_Constants.dfgLeadRT)
            {
                if (String.valueOf(l.OwnerId).startsWith('005')) {
                    userIds.add(l.OwnerId);
                }
            }
        }
        if(userIds.size() > 0)
        {
            Map<Id, User> userMap = new Map<Id, User>([Select u.DefaultCurrencyIsoCode From User u Where u.Id IN :userIds]);
            for (Lead l : leads) {
                User u = userMap.get(l.OwnerId);
                if(u != null) {
                    l.CurrencyIsoCode = u.DefaultCurrencyIsoCode;
                }
            } 
        }
    }

    public static void setSupervisorName(List<Lead> leads, Boolean isInsert) {
        
        // Variables to hold name parts.
        String lsSupervisorName, lsSupervisorFirstName, lsSupervisorLastName;
        
        // Position of first space in name.
        Integer liPOS;  
        for (Lead l : leads) {
            lsSupervisorName = '';  // Make sure it is empty.

            // Parse the Supervisor name in to Fist & Last Names
            if (String.isNotBlank(l.Supervisor_Name__c) && isInsert && l.recordTypeId != trac_Constants.dfgLeadRT) {
                System.debug('SCS: Parsing firt & last names.');

                lsSupervisorName = l.Supervisor_Name__c;
                liPOS = lsSupervisorName.indexOf(' ');

                if (liPOS <= 0 ) {
                    lsSupervisorFirstName = '';
                    lsSupervisorLastName = lsSupervisorName;
                } else {
                    lsSupervisorFirstName = lsSupervisorName.left(liPOS).trim();
                    lsSupervisorLastName = lsSupervisorName.substring(liPOS).trim();
                }

                System.debug('SCS: liPOS = ' + liPOS + ' lsSupervisorName = (' + lsSupervisorName + ') lsSupervisorFirstName = (' + lsSupervisorFirstName + ') lsSupervisorLastName = (' + lsSupervisorLastName + ')');
                l.Supervisor_FirstName__c = lsSupervisorFirstName;
                l.Supervisor_LastName__c = lsSupervisorLastName;

            } else {
                System.debug('SCS: Concatenating supervisor name.');
                if(l.recordTypeId != trac_Constants.dfgLeadRT){
                    if( String.isNotBlank(l.Supervisor_FirstName__c) || String.isNotBlank(l.Supervisor_LastName__c)) {
                        lsSupervisorName =  ( String.isBlank(l.Supervisor_FirstName__c) ? '' : l.Supervisor_FirstName__c ) + ' ' + 
                                            ( String.isBlank(l.Supervisor_LastName__c) ? '' : l.Supervisor_LastName__c );
                        l.Supervisor_Name__c = lsSupervisorName.trim();
    
                        System.debug('SCS: l.Supervisor_Name__c = (' + l.Supervisor_Name__c + ')');
                    }
                }
            }
        }
    }
}