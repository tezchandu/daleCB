public with sharing class AccountBeforeTriggerHandler {
    
    public static void setCurrencyIsoCode (List<Account> accounts) {
        
        Set<Id> userIds = new Set<Id>();
        for (Account a : accounts) {
            if(a.recordTypeId != trac_constants.dfgAccountRT){
                userIds.add(a.OwnerId);
            }            
        }
        
        Map<Id, User> userMap = new Map<Id, User>([Select u.DefaultCurrencyIsoCode From User u Where u.Id IN :userIds]);
        for (Account a : accounts) {
            if(a.recordTypeId != trac_constants.dfgAccountRT){
                a.CurrencyIsoCode = userMap.get(a.OwnerId).DefaultCurrencyIsoCode ;
            }
        } 
    }
}