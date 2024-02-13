/**
*  TestCode for FranchiseObjectAccessTriggerHandler
* 
* @Date:    02.17.2016
* @Author:  Usman Ali (Magnet 360)
* @Jira:    MSP-862
*
*/

@isTest
private class FranchiseObjectAccessTriggerHandlerTest 
{
	public static testMethod void  deleteFOA()    
	{
		TestUtil testUtil = new TestUtil();

		// Create Accounts
        Account account = testUtil.getAccounts(1, null, UserInfo.getUserId() )[0];
        insert account;

        // Create Franchise team records
        Franchise_Team__c ft = testUtil.getFranchiseTeams( 1, 'AAAAA', account.Id, UserInfo.getUserId() )[0];
        insert ft; 

        // Create FranchiseObjectAccess record 
        Franchise_Object_Access__c foa = testUtil.getFranchiseObjectAccesses(1, ft.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_ACCOUNT )[0];
        insert foa ; 

        // Update franchise Team flag 
        ft.Process_Sharing__c = false ; 
        update ft; 

        // delete FranchiseObjectAccess record 
        delete foa ; 

	}
}