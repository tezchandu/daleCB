/******************************************************************************
 * Name: 		TaskBefore 
 *
 * Purpose:		Master Trigger to fire ON ALL BEFORE events of Task records. 
 * 				Follows the super trigger framework to control the order in which trigger actions occur.
 * 				
 * @Author:		Abdul Sattar (Magnet 360)
 * @Date:		08.27.2015
 *
 * @Updates:
 * 
 ******************************************************************************/
trigger TaskBefore on Task(before insert, before update) {

	// Set or make tasks public
	TaskTriggerHandler.setTasksPublic(Trigger.New);
}