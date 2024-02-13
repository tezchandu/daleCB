/**
 * Created by ssalvatore on 4/18/2019.
 */

global class ContentDocumentLinkBatch implements Database.Batchable<SObject>  {

    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator('SELECT Id FROM ContentDocument USING SCOPE Team' + (Test.isRunningTest() ? ' LIMIT 200':''));
    }

    global void execute(Database.BatchableContext BC, List<ContentDocument> contentDocuments)
    {
        Set<Id> contentDocumentIds = new Set<Id>();
        for(ContentDocument cd: contentDocuments) {
            contentDocumentIds.add(cd.Id);
        }
        List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, ContentDocumentId, Visibility FROM ContentDocumentLink WHERE ContentDocumentId IN :contentDocumentIds];
        Map<Id,List<ContentDocumentLink>> contentDocumentLinksByIds = new Map<Id, List<ContentDocumentLink>>();
        for (ContentDocumentLink cdl : contentDocumentLinks) {
            if (!contentDocumentLinksByIds.containsKey(cdl.ContentDocumentId)) {
               contentDocumentLinksByIds.put(cdl.ContentDocumentId,new List<ContentDocumentLink>());
            }
            contentDocumentLinksByIds.get(cdl.ContentDocumentId).add(cdl);
        }

        List<ContentDocumentLink> contentDocumentLinksToUpdate = new List<ContentDocumentLink>();

        for (Id cdr : contentDocumentLinksByIds.keySet()) {
            if (contentDocumentLinksByIds.get(cdr).size() < 50) {
                contentDocumentLinksToUpdate.addAll(contentDocumentLinksByIds.get(cdr));
            }
        }
        updateContentDocumentLinks(contentDocumentLinksToUpdate);
    }

    global void finish(Database.BatchableContext BC)
    {
        System.debug('Batch job finished') ;
    }

    public void updateContentDocumentLinks (List<ContentDocumentLink> contentDocumentLinks) {
        List<ContentDocumentLink> cdsToUpdate = new List<ContentDocumentLink>();
        for (ContentDocumentLink l : contentDocumentLinks) {
            if (l.Visibility != 'AllUsers' && l.Visibility != 'SharedUsers') {
                l.Visibility = 'AllUsers';
                cdsToUpdate.add(l);
            }
        }

        List<Database.SaveResult> saveResult = Database.update(cdsToUpdate, false);
    }
}