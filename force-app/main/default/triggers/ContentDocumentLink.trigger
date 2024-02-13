/**
 * @description Trigger for Content Document Link object
 * @author Simon Salvatore, Traction on Demand
 * @date 10-04-2019
 */
trigger ContentDocumentLink on ContentDocumentLink (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        ContentDocumentLinkTriggerHandler.updateContentDocumentLinkVisibility(Trigger.new);
    }
}