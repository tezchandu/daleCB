/**
*  TriggerController to set ProcessSharing checkbox on related FranchiseTeam record
* 
* @Date:    02.17.2016
* @Author:  Usman Ali (Magnet 360)
* @Jira:    MSP-862
*
*/

public with sharing class FranchiseTeamMemberTriggerHandler {
   	
   	public static void setFranchiseSharingFlag( List<Franchise_Team_Member__c> ftmList )
   	{
   		Set<Id> frachiseIds = new Set<Id>();
   		for( Franchise_Team_Member__c ftm : ftmList )
   		{
   			frachiseIds.add(ftm.Franchise_ID__c);
   		}

   		List<Franchise_Team__c> ftList =  [ SELECT Process_Sharing__c 
   											FROM Franchise_Team__c 
   											WHERE Id IN :frachiseIds AND Process_Sharing__c = false ] ;

   		if( ftList.size() > 0 && ftList != null )
   		{	
	   		for( Franchise_Team__c ft : ftList )
	   		{
	   			ft.Process_Sharing__c = true ; 
	   		}
	   		update ftList ; 
	   	}
   	}
}