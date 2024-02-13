/**
 * @description Unit Test Class to for handler of Content Document Links
 * @author Simon Salvatore, Traction on Demand
 * @date 11-04-2019
 */
@IsTest
private class ContentDocumentLinkTriggerHandlerTest {
    @IsTest
    static void testUpdateContentDocumentLinkVisibility() {
        Test.startTest();

        Account acct = new Account(Name='TEST_ACCT');
        insert acct;

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Test',
                PathOnClient = 'Test.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = acct.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'InternalUsers';
        insert cdl;

        Test.stopTest();
    }
}