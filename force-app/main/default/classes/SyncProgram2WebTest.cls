@isTest
private class SyncProgram2WebTest {

    @isTest
    static void testCreateProgram() {
        Test.startTest();

        // Test when HTTP response is successful
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, '{"event_id": "sampleEventId", "status": "success"}'));
        Program_Location__c pl = new Program_Location__c();
        pl.Location_Country__c = 'United States';
        pl.Location_State_Province__c = 'AH';
        pl.Location_City__c = 'Hyderabad';
        pl.Location_Zip_Postal_Code__c = '89898';
        pl.Name = 'test';
        insert pl;
        
                Area_Location__c al = new Area_Location__c();
        //al.Site_ID__c = '232';
        al.Name = 'iiii';
        
        insert al;
         
        Site__c ss = new Site__c();
        ss.Area_Location__c = al.id;
        ss.Site_ID__c ='232';
        ss.Franchise_Code__c = '232';
        insert ss;
        Product2 pp = new Product2();
        pp.Name = 'eee';
        pp.ProgramName__c = 'event';
        pp.Website_Course_ID__c ='8989';
        pp.Total_Sessions__c = 3;
        pp.Minimum_Registrations__c = 3;
        pp.Maximum_Registrations__c = 5;
        pp.Minimum_Sessions__c = 1;
        pp.Continuing_Education_Units__c = 3;
        pp.Product_Availability__c = 'Carnegie Learning Center';
        Id PrdctRecTypeId = [select id from RecordType where DeveloperName = 'Client_Builder_Master' and SobjectType ='Product2'][0].id;
        pp.RecordTypeId  = PrdctRecTypeId;
            insert pp;
        
        program__c prgm = new program__c();
        prgm.name = 'event';
        prgm.Program_Location__c = pl.id;
        prgm.Area_Location__c = al.id;
        prgm.Product__c = pp.id;
		//prgm.Program_Location__r.Location_Country__c = 'United States';
        //prgm.Program_Location__r.Location_State_Province__c = 'AH';
        //prgm.Program_Location__r.Location_City__c = 'Hyderabad';
        //prgm.Program_Location__r.Location_Zip_Postal_Code__c = '89898';
        prgm.TotalSessions__c = 2;
        prgm.Absorb_Token__c = '9089898';
        prgm.eVolve_Course_Slug__c = 'lkkkj';
        prgm.Push_to_Web__c = true;
        insert prgm;
        program__c pps = new program__c();
        pps.Id = prgm.id;
        pps.Push_to_Web__c = true;
        //pps.Website_Event_ID__c = 33333;
        update pps;

            
        SyncProgram2Web.ProgramData1 programData1 = new SyncProgram2Web.ProgramData1();
        
        programData1.location = 'Sample Location';
        programData1.address_1 = 'Sample Address';
        programData1.course_slug = 'SampleSlug';
        programData1.country = 'SampleCountry';
        // Set values for other existing fields
        programData1.state_or_province = 'SampleState';
        programData1.city = 'SampleCity';
        programData1.zip_code = '12345';
        programData1.duration_amount = 10;
        programData1.start_date_time = Datetime.now();
        programData1.end_date_time = Datetime.now().addDays(10);
        programData1.spots_available = 50;
        programData1.evolve = true;
        programData1.evolve_sublicense_id = 'SampleSublicenseId';
        programData1.learn_from_anywhere = true;
        programData1.price = 99.99;
        programData1.expired_at = Datetime.now().addDays(20);
        programData1.sustainment = false;
        programData1.salesforce_program_id = prgm.id;
        // ... (set values for other existing fields)

        // Set values for additional fields
      
        
        String currencyVal1 = 'USD';
        SyncProgram2Web.sendProgram(prgm.id);
        //SyncProgram2Web.updateProgram(prgm.id);
        SyncProgram2Web.createProgram(programData1, currencyVal1);

        // Add assertions based on the expected behavior of your code
        // For example, assert that the Website_Event_ID__c field is updated in Salesforce

        Test.stopTest();
    }

    @isTest
    static void testUpdateProgram() {
        Test.startTest();

        // Test when HTTP response is successful
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, '{"event_id": "updatedEventId", "status": "success"}'));
        Program_Location__c pl = new Program_Location__c();
        pl.Location_Country__c = 'United States';
        pl.Location_State_Province__c = 'AH';
        pl.Location_City__c = 'Hyderabad';
        pl.Location_Zip_Postal_Code__c = '89898';
        pl.Name = 'test';
        insert pl;
        
                Area_Location__c al = new Area_Location__c();
        //al.Site_ID__c = '232';
        al.Name = 'iiii';
        
        insert al;
         
        Site__c ss = new Site__c();
        ss.Area_Location__c = al.id;
        ss.Site_ID__c ='232';
        ss.Franchise_Code__c = '232';
        insert ss;
        Product2 pp = new Product2();
        pp.Name = 'eee';
        pp.ProgramName__c = 'event';
        pp.Website_Course_ID__c ='8989';
        pp.Total_Sessions__c = 3;
        pp.Minimum_Registrations__c = 3;
        pp.Maximum_Registrations__c = 5;
        pp.Minimum_Sessions__c = 1;
        pp.Continuing_Education_Units__c = 3;
        pp.Product_Availability__c = 'Carnegie Learning Center';
        Id PrdctRecTypeId = [select id from RecordType where DeveloperName = 'Client_Builder_Master' and SobjectType ='Product2'][0].id;
        pp.RecordTypeId  = PrdctRecTypeId;
            insert pp;
        
        program__c prgm = new program__c();
        prgm.name = 'event';
        prgm.Program_Location__c = pl.id;
        prgm.Area_Location__c = al.id;
        prgm.Product__c = pp.id;
		//prgm.Program_Location__r.Location_Country__c = 'United States';
        //prgm.Program_Location__r.Location_State_Province__c = 'AH';
        //prgm.Program_Location__r.Location_City__c = 'Hyderabad';
        //prgm.Program_Location__r.Location_Zip_Postal_Code__c = '89898';
        prgm.TotalSessions__c = 2;
        prgm.Absorb_Token__c = '9089898';
        prgm.eVolve_Course_Slug__c = 'lkkkj';
        insert prgm;
        program__c pps = new program__c();
        pps.Id = prgm.id;
        pps.Website_Event_ID__c = '33333';
		pps.ProgramType__c = 'public';
pps.AwarenessSustainmentFee__c = 2300;
pps.BaseRegistrationFee__c = 1000;
pps.UseInHouseProgramPricing__c = false;
pps.Program_Description_for_Website__c = 'teetet';   
        pps.Federal_Tax__c = 3;
        pps.Value_Added_Tax__c = 3;
        pps.Local_Tax__c = 3;
        pps.State_Tax__c = 3;
        pps.Push_to_Web__c = true;     
        update pps;
String soqlList = ' id,Site_ID__c, Name, Account_Address__c, Account_Name__c, Website_Event_ID__c,Program_Location__r.Name,CurrencyIsoCode,Franchise_ID__c,ProgramName__c,Program_Location__r.Location_state_code__c,';
            String soqlList1=    soqlList +' Delivery_Language__c, Program_Description_for_Website__c, DeliveryMethod__c, Program_Location__c, Absorb_Token__c,Local_Tax__c,State_Tax__c,';
            String soqlList2=    soqlList1 +' ProgramType__c,BaseRegistrationFee__c,UseInHouseProgramPricing__c,InHouseProgramPrice__c,ProgramAwarenessFee__c ,Total_Tax__c,AwarenessSustainmentFee__c ,Federal_Tax__c,Tax_Actual__c,';
            String soqlList3 =   soqlList2+ ' Delivered_on_eVolve__c, eVolve_Course_Slug__c, eVolve_sublicense_ID__c, Timezone__c, TotalSessions__c, Duration_Category__c,Area_Location__c, Value_Added_Tax__c,';
            String soqlList4 =   soqlList3+'  Session1StartDateTime__c, Program_Graduation_Start_Date_Time__c, MaximumRegistrations__c, OrientationEndDateTime__c,OrientationStartDateTime__c, ';
            String soqlList5=  soqlList4+' SustainmentEndDateTime__c, SustainmentStartDateTime__c, Program_Graduation_End_Date_Time__c, Private_Event__c, RecordTypeId,Session1EndDateTime__c,  ';
            String soqlList6=  soqlList5+ 'Program_Location__r.Location_Street__c, Program_Location__r.Location_State_Province__c,Program_Location__r.Location_State_US__c, Program_Location__r.Location_Country__c, Program_Location__r.Location_Zip_Postal_Code__c, Program_Location__r.Location_City__c';
          
            //soqlList = soqlList.removeEnd(',');
            system.debug('soqlList '+soqlList6);
        string programID = pps.id;
            String query = 'select '+ soqlList6 +' from  Program__c where Id=:programId';
            system.debug(query);
            List<program__c> programQuery = database.query(query);
            system.debug('programQuery '+programQuery);
            program__c prgms = programQuery[0];        
        SyncProgram2Web.ProgramData programData = new SyncProgram2Web.ProgramData();
        programData.location = 'Updated Location';
        programData.address_1 = 'Updated Address';
        programData.course_slug = 'UpdatedSlug';
        programData.country = 'UpdatedCountry';
        // Set values for other existing fields
        programData.state_or_province = 'UpdatedState';
        programData.city = 'UpdatedCity';
        programData.zip_code = '54321';
        programData.duration_amount = 15;
        programData.start_date_time = Datetime.now().addDays(5);
        programData.end_date_time = Datetime.now().addDays(20);
        programData.spots_available = 30;
        programData.evolve = false;
        programData.evolve_sublicense_id = 'UpdatedSublicenseId';
        programData.learn_from_anywhere = false;
        programData.price = 129.99;
        programData.expired_at = Datetime.now().addDays(25);
        programData.sustainment = true;
        // ... (set values for other existing fields)

        // Set values for additional fields
       
        String currencyVal = 'EUR';
        //SyncProgram2Web.putProgram(pps.id);
        SyncProgram2Web.updateProgram(prgms.id);
RefreshAccessToken4Push2Web.ftest();
        // Add assertions based on the expected behavior of your code
        // For example, assert that the Website_Event_ID__c field is updated in Salesforce

        Test.stopTest();
    }

    // Create a mock HTTP response class
    private class MockHttpResponse implements HttpCalloutMock {
        private Integer statusCode;
        private String response;

        MockHttpResponse(Integer statusCode, String response) {
            this.statusCode = statusCode;
            this.response = response;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setBody(response);
            return res;
        }
    }
}