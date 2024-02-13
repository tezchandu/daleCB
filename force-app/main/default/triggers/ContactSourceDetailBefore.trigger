/**
* Trigger on all before events for the ContactSourceDetail
* 
* @Date: 	01.22.2016
* @Author: 	Usman Ali (Magnet30)
*			Added called to FranchiseSharingHandler
* 
* @Updates:	
* 
*/

trigger ContactSourceDetailBefore on Contact_Source_Detail__c(before insert, before update ) 
{
	// Process sharing rules 
	if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleContactSourceDetails(Trigger.new);
    } 
}