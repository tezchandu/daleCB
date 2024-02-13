@isTest
private class DatedCurrencyXE_Test {

    @isTest
    static void testCurrencyCallout() {
        Test.setMock(HttpCalloutMock.class, new httpResponseClass());
        Test.startTest();
        String sch = '20 10 10 * * ?';
        ScheduleDatedCurrencyXE slea = new ScheduleDatedCurrencyXE();
        RefreshAccessToken4Push2Web dea = new RefreshAccessToken4Push2Web();
            System.schedule('access Job', sch, slea);
        System.schedule('refresh Job', sch, dea);
        DatedCurrencyXE.getAccessToken();
        Test.stopTest();

        // Add assertions based on the expected behavior after calling makeCallout
    }

    @isTest
    static void testInsertDatedCurrencyExchange() {
        String mockJsonResponse = '{"to": [{"quotecurrency": "EUR", "mid": "1.2345"}]}';
Test.setMock(HttpCalloutMock.class, new httpResponseClass());
        Test.startTest();
        DatedCurrencyXE.insertDatedCurrencyExchange(mockJsonResponse);
        Test.stopTest();

        // Add assertions based on the expected behavior after calling insertDatedCurrencyExchange
    }

    @isTest
    static void testUpdateCurrienciesData() {
        // Mock DatedConversionRateCollection data
        DatedConversionRateCollection mockCollection = new DatedConversionRateCollection();
        // Add some mock records to the collection
Test.setMock(HttpCalloutMock.class, new httpResponseClass());
        Test.startTest();
        DatedCurrencyXE.updateCurrienciesData(mockCollection);
        Test.stopTest();

        // Add assertions based on the expected behavior after calling updateCurrienciesData
    }
    public class httpResponseClass implements HttpCalloutMock
    {
         public HTTPResponse respond(HTTPRequest req)
         {
             HttpResponse res = new HttpResponse(); 
             res.setHeader('Content-Type', 'application/JSON');
             /*if(req.getEndpoint() == 'https://drchrono.com/api/appointments')
             {
                res.setStatusCode(201);
              	res.setBody('{"id":1234567890}');
             }
             if(req.getEndpoint() == 'https://drchrono.com/api/clinical_note_field_values')
             {
                res.setStatusCode(201);
              	res.setBody('{"id":1234567890}');
             }*/
             res.setStatusCode(201);
             res.setBody('{"to": [{"quotecurrency": "EUR", "mid": "1.2345"}]}');
             return res;
         }
    }
}