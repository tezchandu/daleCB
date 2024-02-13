/**
*   @Author:    Usman Ali (Magnet 360 )
*   @Date:      10.31.2016
*   @Jira:      MSP-1104
*   @Purpose:   Master Trigger to fire ON ALL AFTER events of Task records. 
* 				Follows the super trigger framework to control the order in which trigger actions occur.
*
*/

trigger TaskAfter on Task(after insert, after update) 
{
    TaskTriggerHandler.changeLeadStatus(Trigger.new);
}