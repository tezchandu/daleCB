/**
 * Created by ssalvatore on 4/23/2019.
 */

@IsTest
private class ContentDocumentLinkBatchTest {
    @testSetup
    static void setup() {
        List<ContentDocument> contentDocuments = new List<ContentDocument>();
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        // insert 10 accounts

        for (Integer i=0; i < 500; i++) {
            ContentVersion contentVersionInsert = new ContentVersion(
                    Title = 'Test' + i,
                    PathOnClient = 'Test.jpg',
                    VersionData = Blob.valueOf('Test Content Data'),
                    IsMajorVersion = true
            );
            contentVersions.add(contentVersionInsert);
        }

        insert contentVersions;

    }
    @IsTest
    static void testContentDocumentLinkBatch() {
        Test.startTest();
        ContentDocumentLinkBatch myBatch = new ContentDocumentLinkBatch();
        Id jobId = Database.executeBatch(myBatch,200);
        Test.stopTest();
    }
}