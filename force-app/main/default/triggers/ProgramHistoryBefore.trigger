/**
* Trigger on all before events for the ProgramHistory
* 
* @Date: 	01.22.2016
* @Author: 	Usman Ali (Magnet30)
*			Added called to FranchiseSharingHandler
* 
* @Updates:	
* 
*/

trigger ProgramHistoryBefore on Program_History__c(before insert, before update) 
{
	// Process sharing rules 
	if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
    	FranchiseSharingHandler.handleProgramHistory(Trigger.new);
    } 
}