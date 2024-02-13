/**
* 
* @Date: 18.07.2023
* @Author: Joylin Karupalli (SpringML)
* 
* @Purpose:  Code to Prevent, Update, Delete payments for previous months, previous years of date selected in 'Payment Date' field.
-- > Called from 'feePaymentTrigger'
*
* @Testclass Name : PreventPaymentRecordModificationTest
*/
public class PreventPaymentRecordModification {
    
    public static void preventDeletion(List<Fee_Payment__c> records)
    {
        Integer currentYear = Date.today().Year();
        Integer currentDay = Date.today().day();
        Integer currentMonth = Date.today().month();
        Integer previousmonth = Date.today().month() - 1;
        
        Profile_Record_ID__c acc = Profile_Record_ID__c.getInstance('ID');
            system.debug(acc);
        if(UserInfo.getProfileId() != acc.System_Admin__c ){
            for(Fee_Payment__c record : records){
                if(record.Payment_Date__c != null){
                    Integer paymentMonth = record.Payment_Date__c.month();
                    Integer paymentYear = record.Payment_Date__c.year();
                    
                    if(paymentYear < currentYear && currentMonth == 1 && previousmonth == 12 && currentDay > 10){
                        record.addError('Payment modification is not allowed after the 10th of current month for payments made in any previous months.');
                    }
                    
                    else if(paymentYear < currentYear && paymentMonth != 12)
                    {
                        record.addError('Payment creation is not allowed for last year payments.');
                        
                    }
                    
                    else if((paymentYear == currentYear) && (paymentMonth < previousmonth) && (paymentMonth != previousmonth) ) 
                    {
                        record.addError('Payment deletion is not allowed for any previous months.');
                        
                    }
                    else if(((paymentYear == currentYear) && ((paymentMonth < currentMonth) && (paymentMonth == previousmonth))&& currentDay > 10)){
                        record.addError('Payment deletion is not allowed after the 10th of current month for payments made in any previous months.');
                    } 
                }
            }
        }
    } 
    public static void preventInsertion(List<Fee_Payment__c> records)
    {
        Integer paymentMonth;
        Integer currentDay;
        Integer currentMonth = Date.today().month();
        Integer previousmonth = Date.today().month() - 1;
        Integer currentYear = Date.today().Year();
        Profile_Record_ID__c acc = Profile_Record_ID__c.getInstance('ID');
            system.debug(acc);
        //if(!Test.isRunningTest()){
        if(UserInfo.getProfileId() != acc.System_Admin__c ){ 
            for(Fee_Payment__c record : records){
                if(record.Payment_Date__c != null){
                    paymentMonth = record.Payment_Date__c.month();
                    currentDay = Date.today().day();
                    Integer paymentYear = record.Payment_Date__c.year();
                    
                    if(paymentYear < currentYear && currentMonth == 1 && previousmonth == 12 && currentDay > 10){
                        record.addError('Payment modification is not allowed after the 10th of current month for payments made in any previous months.');
                    }
                    
                    else if(paymentYear < currentYear && paymentMonth != 12)
                    {
                        record.addError('Payment creation is not allowed for last year payments.');
                        
                    }
                    else if(((paymentYear == currentYear) && (paymentMonth < previousmonth)) && (paymentMonth != previousmonth)){
                        record.addError('Payment creation is not allowed for previous months');
                    } 
                    else if(((paymentYear == currentYear) && (paymentMonth < currentMonth)&& (paymentMonth == previousmonth)) && currentDay > 10){
                        record.addError('Payment creation is not allowed after the 10th of current month');
                    } 
                    
                }
            }
        }
        //}
    }
    
    public static void preventUpdation(List<Fee_Payment__c> records, map<Id, Fee_Payment__c> oldpaymentrecord)
    {
        Integer existingrecordmonth;
        Integer currentDay;
        Integer currentMonth = Date.today().month();
        System.debug('current month is ' +currentMonth);
        Integer previousmonth = Date.today().month() - 1 ;
        Boolean monthcheck = false;
        Integer updatedmonth;
        Integer currentYear = Date.today().Year();
        
		Profile_Record_ID__c acc = Profile_Record_ID__c.getInstance('ID');
            system.debug(acc);
        //if(!Test.isRunningTest()){
        if(UserInfo.getProfileId() != acc.System_Admin__c ){
            for(Fee_Payment__c record : records){
                if(record.Payment_Date__c != null){
                    existingrecordmonth = oldpaymentrecord.get(record.Id).Payment_Date__c.month();
                    System.debug('existingrecordmonth on the record is' +existingrecordmonth);
                    updatedmonth   = record.Payment_Date__c.month();
                    Integer paymentyear = record.Payment_Date__c.year();
                    Integer previousyear;                    
                    currentDay = Date.today().day();
                    
                    //if payment date is in current month, it can't be changed to previous months
                    if(existingrecordmonth == currentMonth && paymentYear == currentYear && currentDay > 10){
                        if(updatedmonth < existingrecordmonth){
                            monthcheck = true;
                            System.debug('checking monthcheck true or false');
                        }   
                    }
                    
                    if(monthcheck){
                        record.addError('Payment Date cannot be changed to previous months after the 10th of current month.');
                    }
                    
                    // prevents December record edit after Jan 10
                    if(paymentYear < currentYear && currentMonth == 1 && existingrecordmonth == 12 && currentDay > 10){
                        System.debug('checking for jan dec');
                        record.addError('Payment modification is not allowed after the 10th of current month for payments made in any previous months.');
                    }
                    
                    //prevents record edits for previous year payments except for December 
                    //if current month is in Jan
                    if(paymentYear < currentYear && existingrecordmonth != 12)
                    {
                        System.debug('checking for previous mon');
                        record.addError('Payment updation is not allowed for last year payments.');                       
                    }
                    
                    //prevents record modification for previous month
                    if(((paymentYear == currentYear) && (existingrecordmonth < currentMonth) && (existingrecordmonth == previousmonth) && currentDay > 10 )){
                        System.debug('checking for previous month');
                        System.debug('paymentMonth is ' +existingrecordmonth);
                        System.debug('currentMonth is ' +currentMonth);
                        System.debug('previousmonth is ' +previousmonth);
                        
                        record.addError('Payment modification is not allowed after the 10th of current month for payments made in any previous months.');
                    } 
                    
                    //prevents record edit for all months less than currentmonth-1
                    if((paymentYear == currentYear) && (existingrecordmonth < previousmonth) && (existingrecordmonth != previousmonth))
                    {
                        System.debug('checking for all previous months');
                        record.addError('Payment modification is not allowed to previous months');
                    }
                }
            }
        }
        //}
    }   
}