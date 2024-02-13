/**
*  Trigger to set ProcessSharing checkbox on related FranchiseTeam record
* 
* @Date: 	02.17.2016
* @Author: 	Usman Ali (Magnet 360)
* @Jira: 	MSP-862
*
*/

trigger FranchiseTeamMemberTrigger on Franchise_Team_Member__c(after delete ) 
{
	FranchiseTeamMemberTriggerHandler.setFranchiseSharingFlag( Trigger.Old );  
}