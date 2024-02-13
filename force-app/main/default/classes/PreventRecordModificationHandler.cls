public class PreventRecordModificationHandler {
     public static void preventCreation(List<Fee_Payment__c> records) {
        preventModification(records);
    }  
    public static void preventUpdate(List<Fee_Payment__c> records) {
        preventModification(records);
    }
   
  
    public static void preventDeletion(List<Fee_Payment__c> records) {
        Date currentDate = Date.today();
        Integer currentMonth = currentDate.month();
        Integer lastmonth = currentDate.month() - 1;
        Integer currentYear = Date.today().year();
        Integer paymentMonth;
            Integer paymentYear;
            Integer currentDay;
            Integer previousPaymentMonth = null;
            Integer previousPaymentYear = null;
            Integer futurePaymentMonth = null;
        Id systemAdminProfileId = [SELECT ProfileId FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1].ProfileId;
        
        for (Fee_Payment__c record : records) {
            if(record.Payment_Date__c!=null){
             paymentMonth = record.Payment_Date__c.month();
             paymentYear = record.Payment_Date__c.year();
             currentDay = Date.today().day();
            
            }
            if (record.Payment_Date__c != null) {
                previousPaymentMonth = record.Payment_Date__c.month() < currentMonth - 1 ? record.Payment_Date__c.month() : null;
                futurePaymentMonth = record.Payment_Date__c.month() > currentMonth ? record.Payment_Date__c.month() : null;
                previousPaymentYear = record.Payment_Date__c.month() < currentMonth ? record.Payment_Date__c.year() : null;
            }
            
            system.debug('UserInfo.getProfileId()  '+UserInfo.getProfileId());
            system.debug('systemAdminProfileId' +systemAdminProfileId);
            if (UserInfo.getProfileId() == systemAdminProfileId) {
                continue;
            }
            if (paymentYear < currentYear || 
                (paymentYear == currentYear && paymentMonth == lastmonth && paymentMonth == previousPaymentMonth && currentDay > 10)&& 
                (futurePaymentMonth != currentMonth && currentDay > 10 ) &&
                (paymentMonth != currentMonth)
               )  
            {
                record.addError('Payment modification is not allowed after the 10th of current month for payments made in any previous months.');
            }
        }
        
    }
    
    public static void preventModification(List<Fee_Payment__c> records) {
        Date currentDate = Date.today();
        Integer currentMonth = currentDate.month();
        Integer lastmonth = Date.today().month() - 1;
        Integer currentYear = Date.today().year();
        Integer paymentMonth;
            Integer paymentYear;
            Integer currentDay;
        Integer previousmonth;
            Integer previousPaymentMonth = null;
            Integer previousPaymentYear = null;
            Integer futurePaymentMonth = null;
        
        Id systemAdminProfileId = [SELECT ProfileId FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1].ProfileId;
        
        for (Fee_Payment__c record : records) {
            if (record.Payment_Date__c != null) {
             paymentMonth = record.Payment_Date__c.month();
             paymentYear = record.Payment_Date__c.year();
             currentDay = Date.today().day();
                System.debug('current date is' +currentDay);
               previousmonth = Date.today().month() - 1;
                System.debug('previous month is' +previousmonth);
           
            
                previousPaymentMonth = record.Payment_Date__c.month() < currentMonth - 1 ? record.Payment_Date__c.month() : null;
                futurePaymentMonth = record.Payment_Date__c.month() > currentMonth ? record.Payment_Date__c.month() : null;
                previousPaymentYear = record.Payment_Date__c.month() < currentMonth ? record.Payment_Date__c.year() : null;
            }
            
          if (UserInfo.getProfileId() == systemAdminProfileId) {
                continue;
            } 
            
                        //system.debug(paymentMonth +' - ' +)
            system.debug('UserInfo.getProfileId()  '+UserInfo.getProfileId());
            system.debug('systemAdminProfileId' +systemAdminProfileId);
            if (UserInfo.getProfileId() == systemAdminProfileId) {
                continue;
            }
            
           if (paymentYear < currentYear || 
               // (paymentYear == currentYear && paymentMonth == currentMonth && paymentMonth == lastmonth && paymentMonth == previousPaymentMonth && currentDay > 10)||
              //  (futurePaymentMonth != currentMonth && currentDay > 10)                ||
              (paymentMonth != previousPaymentMonth && paymentMonth != futurePaymentMonth && paymentMonth != currentMonth && currentDay < 15)
               )
            {
                system.debug(paymentYear+' - '+currentYear+' - '+paymentMonth+' - '+currentMonth +' - '+futurePaymentMonth +' - '+
                          currentDay +' - '+lastmonth  );
               record.addError('Payment modification is not allowed after the 10th of current month for payments made in any previous months.');
            } 
        }       
        
    }
    
}