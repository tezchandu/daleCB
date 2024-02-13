/**
* ProgramHistoryTriggerHandler - Handler class for ProgramHistoryTrigger
* 
* @Date:    10.31.2016
* @Author:  Usman Ali (Magnet 360)
* @Jira:    MSP-1142
* 
* @Updates: 
*
*/

@isTest
private class ProgramHistoryTriggerHandlerTest 
{
    static testMethod void updateContactTest() 
    {
        TestUtil testUtil = new TestUtil();
        
        // Create account
        Account account = testUtil.getAccounts(1, null, UserInfo.getUserId() )[0];
        insert account ;

        // Create Contact
        Contact cont = testUtil.getContacts(1, account.Id )[0] ;
        insert cont ; 

        // Create Program History
        Program_History__c ph = testUtil.getProgramHistories(1, null, null, UserInfo.getUserId() )[0] ;
        ph.Contact__c = cont.Id ;
        ph.Exit_Type__c = 'Graduate';
        insert ph ;
    }
}