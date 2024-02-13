/**
*  TestCode for FranchiseTeamMemberTriggerHandler
* 
* @Date:    02.17.2016
* @Author:  Usman Ali (Magnet 360)
* @Jira:    MSP-862
*
*/
@isTest
private class FranchiseTeamMemberTriggerHandlerTest 
{
 	public static testMethod void deleteFTM()    
	{
		TestUtil testUtil = new TestUtil();

		// Create Accounts
        Account account = testUtil.getAccounts(1, null, UserInfo.getUserId() )[0];
        insert account;

        // Create Franchise team records
        Franchise_Team__c ft = testUtil.getFranchiseTeams( 1, 'AAAAA', account.Id, UserInfo.getUserId() )[0];
        insert ft; 

        // Create FranchiseTeamMember record
        Franchise_Team_Member__c ftm = testUtil.getFranchiseTeamMembers(1, ft.Id, UserInfo.getUserId() , FranchiseSharingUtil.STR_ADMIN )[0] ;
        insert ftm ; 

        // Update franchise Team flag 
        ft.Process_Sharing__c = false ; 
        update ft; 

        // delete FranchiseTeamMember record 
        delete ftm  ; 

	}
}