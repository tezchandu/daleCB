/**
* ProgramHistoryAfter - Trigger to update Contact field on AFTER insert
* 
* @Date:    10.31.2016
* @Author:  Usman Ali (Magnet 360)
* @Jira:    MSP-1142
* 
* @Updates: 
* 12.06.2016	Sophia Murphy (Magnet 360)
*				Updated to include after update, too.
*
*/
trigger ProgramHistoryAfter on Program_History__c(after insert, after update) 
{
    ProgramHistoryTriggerHandler.updateContact(Trigger.new);
}