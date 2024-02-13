/**
* 
* @Date: 18.07.2023
* @Author: Joylin Karupalli (SpringML)
* 
* @Purpose:  Test Code to Prevent, Update, Delete payments for previous months, previous years of date selected in 'Payment Date' field.
			     -- > Class Called from 'feePaymentTrigger'
*
* @Class Name : PreventPaymentRecordModification
*/

@isTest
public class PreventPaymentRecordModificationTest {
    @isTest     
    public static void preventRecordModification() {
        Profile adminId = [Select Id from Profile where Name = 'System Administrator'];
        Profile adminId2 = [Select Id from Profile where Name = 'Standard User'];
        
        User systemAdminUser = new User(
            FirstName = 'joy',
            LastName = '234',
            Email = 'admin@springml.com',
            Alias = 'admin',
            Username = 'testusr@myorg.com',
            ProfileId = adminId.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert systemAdminUser;
        
        User nonAdminUser = new User(
            FirstName = 'joe',
            LastName = 'Doe',
            Email = 'john.doe@springml.com',
            Alias = 'johnd',
            Username = 'joo1@myorg.com',
            ProfileId = adminId2.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert nonAdminUser;
        
        Profile_Record_ID__c PR = new Profile_Record_ID__c();
        PR.Name = 'ID';
        PR.System_Admin__c = 'asdfgh';
        insert PR;
        Integer currentMonth = Date.today().month();
        Integer currentYear = Date.today().year();
        Integer currentDay = Date.today().day();
        
        List<Fee_Payment__c> modificationRecords = new List<Fee_Payment__c>();
        for (Integer i = 0; i < 5; i++) {
            Fee_Payment__c record = new Fee_Payment__c(
                Payment_Date__c = Date.newInstance(currentYear, currentMonth, 1).addMonths(-1)
            );
            modificationRecords.add(record);
        }
        PreventPaymentRecordModification.preventInsertion(modificationRecords);
        insert modificationRecords;
        
        
        System.runAs(systemAdminUser) {
            for (Fee_Payment__c record : modificationRecords) {
                record.Payment_Date__c = Date.today();
            }
            PreventPaymentRecordModification.preventInsertion(modificationRecords);
            update modificationRecords;
        }
        
        System.runAs(nonAdminUser) {
            system.debug(UserInfo.getProfileId());
            try {
                for (Fee_Payment__c record : modificationRecords) {
                    record.Payment_Date__c = Date.today();
                }
                PreventPaymentRecordModification.preventInsertion(modificationRecords);
                update modificationRecords;
                //  System.assert(false, 'Expected exception not thrown');
            } catch (DmlException e) {
                for (Fee_Payment__c record : modificationRecords) {
                    if (record.Payment_Date__c.year() < currentYear) {
                        //  System.assertEquals('Record modification is not allowed because the PaymentDate is in a previous year compared to the current year.', e.getDmlMessage(0));
                    } else if (record.Payment_Date__c.month() < currentMonth && currentDay > 11) {
                        //  System.assertEquals('Record modification is not allowed because the PaymentDate is in the previous month compared to the current month.', e.getDmlMessage(0));
                    }
                }
            }
        }
        
        List<Fee_Payment__c> deletionRecords = new List<Fee_Payment__c>();
        for (Integer i = 0; i < 5; i++) {
            Fee_Payment__c record = new Fee_Payment__c(
                Payment_Date__c = Date.newInstance(currentYear, currentMonth, 1).addMonths(-1)
            );
            deletionRecords.add(record);
        }
        insert deletionRecords;
        
        System.runAs(systemAdminUser) {
            PreventPaymentRecordModification.preventDeletion(deletionRecords);
            delete deletionRecords;
        }
        
        System.runAs(nonAdminUser) {
            try {
                PreventPaymentRecordModification.preventDeletion(deletionRecords);
                delete deletionRecords;
                // System.assert(false, 'Expected exception not thrown');
            } catch (DmlException e) {
                for (Fee_Payment__c record : deletionRecords) {
                    if (record.Payment_Date__c.year() < currentYear) {
                        //System.assertEquals('Record deletion is not allowed because the PaymentDate is in a previous year', e.getDmlMessage(0));
                    } else if (record.Payment_Date__c.month() < currentMonth && currentDay > 11) {
                        //  System.assertEquals('Record deletion is not allowed because the PaymentDate is in the previous month', e.getDmlMessage(0));
                    } 
                }
            }
        }       
    }
}