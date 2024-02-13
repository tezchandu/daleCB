/**
 * @description Class to handle triggers for Content Document Links
 * @author Simon Salvatore, Traction on Demand
 * @date 10-04-2019
 */
public with sharing class ContentDocumentLinkTriggerHandler {
    public static void updateContentDocumentLinkVisibility (List<ContentDocumentLink> triggerNew) {
        for (ContentDocumentLink l: triggerNew) {
            l.Visibility='AllUsers';
        }
    }
}