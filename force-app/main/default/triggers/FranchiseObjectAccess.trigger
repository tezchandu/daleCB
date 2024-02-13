/**
*  Trigger to set ProcessSharing checkbox on related FranchiseTeam record
* 
* @Date: 	02.17.2016
* @Author: 	Usman Ali (Magnet 360)
* @Jira: 	MSP-862
*
*/
trigger FranchiseObjectAccess on Franchise_Object_Access__c(after delete) 
{
	FranchiseObjectAccessTriggerHandler.setFranchiseSharingFlag( Trigger.Old ); 
}