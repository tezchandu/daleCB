/**
* Trigger on all before events for the LeadSourceDetail
* 
* @Date: 	01.22.2016
* @Author: 	Usman Ali (Magnet30)
*			Added called to FranchiseSharingHandler
* 
* @Updates:	
* 
*/

trigger LeadSourceDetailBefore on Lead_Source_Detail__c(before insert, before update ) 
{
	// Process sharing rules 
	if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleLeadSourceDetails(Trigger.new);
    } 
}