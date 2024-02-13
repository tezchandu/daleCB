public with sharing class ContactBeforeTriggerHandler {
    
    public static void setCurrencyIsoCode (List<Contact> contacts) {
        Set<Id> userIds = new Set<Id>();
        for (Contact c : contacts) {
            if(c.recordTypeId != trac_Constants.dfgConRT){
                userIds.add(c.OwnerId);
            }            
        }
        Map<Id, User> userMap = new Map<Id, User>([Select u.DefaultCurrencyIsoCode From User u Where u.Id IN :userIds]);
        if(!userMap.isEmpty()){
            for (Contact c : contacts) {            
                if(userMap.containsKey(c.OwnerId)){
                    if(userMap.get(c.OwnerId).DefaultCurrencyIsoCode != null){
                        c.CurrencyIsoCode = userMap.get(c.OwnerId).DefaultCurrencyIsoCode ;
                    }
                }
                
            }
        }        
    }
}