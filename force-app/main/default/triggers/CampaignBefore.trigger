/**
* Trigger on all before events for the Campaign
* 
* @Date:    01.22.2016
* @Author:  Usman Ali (Magnet30)
*           Added called to FranchiseSharingHandler
* 
* @Updates: 
* 
*/

trigger CampaignBefore on Campaign(before insert, before update) 
{
    // Process sharing rules 
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
        FranchiseSharingHandler.handleCampaigns(Trigger.new);
    } 
}