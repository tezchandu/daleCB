/**
* Trigger on all before events for the Contact
* 
* @Date: xx.xx.xxxx
* @Author: unknown
* 
* @Updates:
* 01.21.2016    Sophia Murphy (Magnet 360)
*               Added called to FranchiseSharingHandler
* 
*/
trigger ContactBefore on Contact (before insert, before update) {
    ContactBeforeTriggerHandler.setCurrencyIsoCode(Trigger.new);

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
        FranchiseSharingHandler.handleContacts(Trigger.new);
    } 
}