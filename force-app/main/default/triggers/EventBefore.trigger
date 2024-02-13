/******************************************************************************
 * Name: 		EventBefore 
 *
 * Purpose:		Master Trigger to fire ON ALL BEFORE events of Event records. 
 * 				Follows the super trigger framework to control the order in which trigger actions occur.
 * 				
 * @Author:		Abdul Sattar (Magnet 360)
 * @Date:		08.27.2015
 *
 * @Updates:
 * 
 ******************************************************************************/
trigger EventBefore on Event(before insert, before update) {

	// Set or make events public
	EventTriggerHandler.setEventsPublic(Trigger.New);
}