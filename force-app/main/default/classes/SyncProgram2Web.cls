public class SyncProgram2Web {
 public static string resEventId ;
    public class ProgramData {
        public String location;
        public string short_description;
       
        public String address_1;
        public String course_slug;
        public String country;
        public String state_or_province;
        public String city;
        public String zip_code;
        public Integer duration_amount;
        public Datetime start_date_time;
        public Datetime end_date_time;
        public Integer spots_available;
        public Boolean evolve;
        public String evolve_sublicense_id;
        public Boolean learn_from_anywhere;
        //public string currency;
        public Decimal price;
        public Datetime expired_at;
        public Boolean sustainment;
        public List<sustainment_dates> sustainment_dates;
        public Boolean kickoff;
        public Datetime kickoff_date;
        public Datetime kickoff_end_date;
        public String timezone;
        public Integer course_id;
        public String locale;
        public Integer duration_type_id;
        public Integer duration_category_id;
        public String delivery_language;
        public String program_code;
       public Integer event_id;
        public Integer franchise_id;
        public String post_purchase_information;
        //public boolean private_event;
        public String salesforce_program_id;
    }
    public class ProgramData1 {
        public String location;
        public String address_1;
        public String course_slug;
        public String country;
        public String state_or_province;
        public String city;
        public String zip_code;
        public Integer duration_amount;
        public Datetime start_date_time;
        public Datetime end_date_time;
        public Integer spots_available;
        public Boolean evolve;
        public String evolve_sublicense_id;
        public Boolean learn_from_anywhere;
        //public string currency;
        public Decimal price;
        public Datetime expired_at;
        public Boolean sustainment;
        public string short_description;
        public List<sustainment_dates> sustainment_dates;
        public Boolean kickoff;
        public Datetime kickoff_date;
        public Datetime kickoff_end_date;
        public String timezone;
        public Integer course_id;
        public String locale;
        public Integer duration_type_id;
        public Integer duration_category_id;
        public String delivery_language;
        public String program_code;
     // public Integer event_id;
        public Integer franchise_id;
        public String post_purchase_information;
        //public boolean private_event;
        public String salesforce_program_id;
    }

    public class sustainment_dates {
        public Datetime start_date;
        public Datetime end_date;
    }
    public class short_description {
        public string css;
        public string html;
    }
	public class ProgramParse{
        public String event_id;
        public String status;
    }
    
    public class ProgramParseError{
        public String error;
        public String status;
    }
    
    public static void createProgram(ProgramData1 programData,string currencyVal) {
         boolean flag = false;
        
        if(!flag){
        try {
            PushtoWebAccess__c acc = PushtoWebAccess__c.getInstance('API Access Token');
             decimal priceHouse;
            String jsonData = JSON.serialize(programData);
            jsonData = jsonData.substring(0, jsonData.length() - 1); // Remove the closing bracket '}'
			jsonData += ',"private":false}';
            system.debug('JSON UPDATE CREATE- '+jsonData);
            jsonData = jsonData.substring(0, jsonData.length() - 1); // Remove the closing bracket '}'
			jsonData += ',"currency" :"'+currencyVal+'"}';
            system.debug('jsonData - '+jsonData);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(acc.EndPointURL__c);
            req.setBody(jsonData);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer '+acc.Access_Token__c);
            //req.setHeader('Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTViNzAzNDVmODczMzAwMTg5ZGNiNTgiLCJpZCI6IjY1NWI3MDM0NWY4NzMzMDAxODlkY2I1OCIsImlhdCI6MTcwMDc1NTMyOCwiZXhwIjoxNzAzMzQ3MzI4fQ.38oQhSE6e8dUPLNjBHb7BLUCw3SCTsbxmoVd9nw8X_o'); // Replace with your access token
            System.debug('Request body: ' + jsonData);
            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug('Response Status: ' + res.getStatusCode());
            System.debug('Response body: ' + res.getBody());

            if (res.getStatusCode() == 200) {
                flag = true;
                
                ProgramParse prgmEvent = (ProgramParse) JSON.deserialize(res.getBody(), ProgramParse.class);
                System.debug('Program Event ID: ' + prgmEvent.event_id);
                resEventId = prgmEvent.event_id;
                saveProgramEventID(prgmEvent.event_id, programData.salesforce_program_id);
            } else {
                System.debug('Error while creation - ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception at ' + e.getLineNumber() + ' ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
        }
    }

    public static void saveProgramEventID(String eventID, String prgmId) {
        try {
            Program__c pgm = [SELECT Id, Website_Event_ID__c FROM Program__c WHERE Id = :prgmId];
            pgm.Website_Event_ID__c = eventID;
            update pgm;
        } catch (Exception e) {
            System.debug('Exception at ' + e.getLineNumber() + ' ' + e.getMessage());
        }
    }

    public static void putProgram(ProgramData programData,string currencyVal) {
        
        try {
            PushtoWebAccess__c acc = PushtoWebAccess__c.getInstance('API Access Token');
            String jsonData = JSON.serialize(programData);
            jsonData = jsonData.substring(0, jsonData.length() - 1); // Remove the closing bracket '}'
            jsonData += ',"private":false}';
            system.debug('JSON UPDATE PUT- '+jsonData);
            jsonData = jsonData.substring(0, jsonData.length() - 1); // Remove the closing bracket '}'
			jsonData += ',"currency" :"'+currencyVal+'"}';
           HttpRequest req = new HttpRequest();
            req.setEndpoint(acc.EndPointURL__c);
            req.setBody(jsonData);
            req.setMethod('PUT');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer '+acc.Access_Token__c); // Replace with your access token
            System.debug('Request body: ' + jsonData);
            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug('Response Status: ' + res.getStatusCode());
            System.debug('Response body: ' + res.getBody());

            if (res.getStatusCode() == 200) {
                ProgramParse prgmEvent = (ProgramParse) JSON.deserialize(res.getBody(), ProgramParse.class);
                System.debug('Program Event ID: ' + prgmEvent.event_id);
                //saveProgramEventID(prgmEvent.event_id, programData.salesforce_program_id);
            } else {
                System.debug('Error - ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception at ' + e.getLineNumber() + ' ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
    }
@future(callout= true)
    public static void sendProgram(String programId ) {
         decimal priceHouse;
       		 String soqlList = ' id,Site_ID__c, Name, Account_Address__c, Account_Name__c, Website_Event_ID__c,Program_Location__r.Name,CurrencyIsoCode,Franchise_ID__c,ProgramName__c,Program_Location__r.Location_state_code__c,';
            String soqlList1=    soqlList +' Delivery_Language__c, Program_Description_for_Website__c, DeliveryMethod__c, Program_Location__c, Absorb_Token__c,Local_Tax__c,State_Tax__c,';
            String soqlList2=    soqlList1 +' ProgramType__c,Delivery_Language_label__c,BaseRegistrationFee__c,Product__c,UseInHouseProgramPricing__c,InHouseProgramPrice__c,ProgramAwarenessFee__c ,Total_Tax__c,AwarenessSustainmentFee__c ,Federal_Tax__c,Tax_Actual__c,';
            String soqlList3 =   soqlList2+ ' Delivered_on_eVolve__c, eVolve_Course_Slug__c, eVolve_sublicense_ID__c, Timezone__c, TotalSessions__c, Duration_Category__c,Area_Location__c, Value_Added_Tax__c,';
            String soqlList4 =   soqlList3+'  Session1StartDateTime__c, Program_Graduation_Start_Date_Time__c, MaximumRegistrations__c, Connection_Information__c,OrientationEndDateTime__c,OrientationStartDateTime__c, ';
            String soqlList5=  soqlList4+' SustainmentEndDateTime__c, SustainmentStartDateTime__c, Program_Graduation_End_Date_Time__c, Private_Event__c, RecordTypeId,Session1EndDateTime__c,  ';
            String soqlList6=  soqlList5+ 'Program_Location__r.Location_Street__c, Program_Location__r.Location_State_Province__c,Program_Location__r.Location_State_US__c, Program_Location__r.Location_Country__c, Program_Location__r.Location_Zip_Postal_Code__c, Program_Location__r.Location_City__c';
          
            //soqlList = soqlList.removeEnd(',');
            system.debug('soqlList '+soqlList6);
            String query = 'select '+ soqlList6 +' from  Program__c where Id=:programId';
            system.debug(query);
            List<program__c> programQuery = database.query(query);
            system.debug('programQuery '+programQuery);
            program__c prgm = programQuery[0];
        string currencyVal = prgm.CurrencyIsoCode;
        Site__c site = [SELECT Id, Site_ID__c, Name, Area_Location__c FROM Site__c WHERE Area_Location__c = :prgm.Area_Location__c LIMIT 1];
        Product2 prdct = [SELECT Id, Website_Course_ID__c, Name FROM Product2 WHERE id=:prgm.Product__c LIMIT 1];
        
        ProgramData1 programData1 = new ProgramData1();
        ProgramData1.location = prgm.Program_Location__r.Name;
        //programData.event_id = Integer.valueOf(prgm.Website_Event_ID__c);
        ProgramData1.address_1 = prgm.Program_Location__r.Location_Street__c;
        ProgramData1.course_slug = prgm.eVolve_Course_Slug__c;
            ProgramData1.country = prgm.Program_Location__r.Location_Country__c;
            if(prgm.Program_Location__r.Location_Country__c == 'United States'){
                ProgramData1.state_or_province = prgm.Program_Location__r.Location_state_code__c;
            }else{
            ProgramData1.state_or_province = prgm.Program_Location__r.Location_State_Province__c;
            }
            ProgramData1.city = prgm.Program_Location__r.Location_City__c;
            ProgramData1.zip_code = prgm.Program_Location__r.Location_Zip_Postal_Code__c;
            ProgramData1.duration_amount = Integer.valueOf(prgm.TotalSessions__c);
            ProgramData1.start_date_time = prgm.Session1StartDateTime__c;
            ProgramData1.end_date_time = prgm.Program_Graduation_End_Date_Time__c;
            //ProgramData1.spots_available = Integer.valueof(prgm.MaximumRegistrations__c);
            //programData.spots_used_offline = prgm.Program_Location__r.Name;//question
            ProgramData1.evolve = prgm.Delivered_on_eVolve__c;//question
            ProgramData1.evolve_sublicense_id = prgm.eVolve_sublicense_ID__c;
            ProgramData1.learn_from_anywhere = false;//question
           // programData.currency =prgm.CurrencyIsoCode;//CurrencyIsoCode
           decimal localTax = ((prgm.Local_Tax__c!=null ) ?prgm.Local_Tax__c:0 );
        decimal stateTax = ((prgm.State_Tax__c!=null ) ?prgm.State_Tax__c:0 );
        decimal federalTax = ((prgm.Federal_Tax__c!=null ) ?prgm.Federal_Tax__c:0 );
        decimal valueAddedTax = ((prgm.Value_Added_Tax__c!=null ) ?prgm.Value_Added_Tax__c:0 );
        //system.debug('(prgm.BaseRegistrationFee__c + prgm.AwarenessSustainmentFee__c)' +(prgm.BaseRegistrationFee__c + prgm.AwarenessSustainmentFee__c));    
        if(prgm.UseInHouseProgramPricing__c == True && prgm.ProgramType__c =='In-house'){
                priceHouse = prgm.InHouseProgramPrice__c + prgm.ProgramAwarenessFee__c + prgm.Total_Tax__c;
            }else if(prgm.UseInHouseProgramPricing__c == False && prgm.ProgramType__c =='In-house'){
                priceHouse = prgm.BaseRegistrationFee__c + prgm.AwarenessSustainmentFee__c + prgm.Total_Tax__c ;
                
            }
        else if( prgm.ProgramType__c =='Public'){
                priceHouse = prgm.AwarenessSustainmentFee__c + prgm.BaseRegistrationFee__c+ (
                    ( localTax+ stateTax + federalTax + valueAddedTax )*(prgm.BaseRegistrationFee__c + prgm.AwarenessSustainmentFee__c));
            }
            system.debug('priceHouse -' +priceHouse);
            ProgramData1.price = priceHouse;//question//ask
           // programObject.put('published_at',prgm.Program_Location__r.Name);//question
            ProgramData1.expired_at = prgm.Program_Graduation_End_Date_Time__c;//question
            if(prgm.SustainmentStartDateTime__c!=null)
            	ProgramData1.sustainment =true;//question
            else
                ProgramData1.sustainment = false;
        List<sustainment_dates> sustainmentList = new List<sustainment_dates>();
       
        //List<short_description> sds = new List<short_description>();
        //short_description sss= new short_description();
        //sss.html = prgm.Program_Description_for_Website__c;
        //sds.add(sss);
        
        	sustainment_dates sustainment = new sustainment_dates();
            	sustainment.start_date = prgm.SustainmentStartDateTime__c;
				sustainment.end_date = prgm.SustainmentEndDateTime__c;
        sustainmentList.add(sustainment);
        ProgramData1.short_description = prgm.Program_Description_for_Website__c;
            ProgramData1.sustainment_dates = sustainmentList;//question
            if(prgm.OrientationStartDateTime__c != null)
            	ProgramData1.kickoff = true;//question
            else
                ProgramData1.kickoff = false;
            ProgramData1.kickoff_date = prgm.OrientationStartDateTime__c;//question
             ProgramData1.kickoff_end_date = prgm.OrientationEndDateTime__c;//question
             ProgramData1.timezone = prgm.Timezone__c;//question
        		if(prdct!=null && prdct.Website_Course_ID__c!=null){
             			ProgramData1.course_id = Integer.valueof(prdct.Website_Course_ID__c);
                }else{
                    ProgramData1.course_id =null;
                }
             ProgramData1.locale = 'En';//question
             programData1.duration_type_id = 7;//question
            if(prgm.Duration_Category__c == 'Multi Session'){
                ProgramData1.duration_category_id = 1;
            }else if(prgm.Duration_Category__c == 'Full Consecutive Days'){
                ProgramData1.duration_category_id = 2;
            }else if(prgm.Duration_Category__c == '<2 Hours'){
                ProgramData1.duration_category_id = 3;
            }else if(prgm.Duration_Category__c == '2-3 Hours'){
                ProgramData1.duration_category_id = 4;
            }else if(prgm.Duration_Category__c == '3+ Hours'){
                ProgramData1.duration_category_id =5;
            }
            // programObject.put('duration_category_id',prgm.Duration_Category__c);//question
             ProgramData1.delivery_language = prgm.Delivery_Language_label__c;
            ProgramData1.program_code = prgm.Name;
        if(prgm.Connection_Information__c!=null){
				programData1.post_purchase_information = prgm.Connection_Information__c;
        }
        else{
            programData1.post_purchase_information = '';
        }
            ProgramData1.franchise_id = integer.valueof(site.Site_ID__c);
            // programData.private_event = false;
             ProgramData1.salesforce_program_id = prgm.Id;
        
        createProgram(ProgramData1,currencyVal);
    }
	@future(callout= true)
    public static void updateProgram(String programId) {
        decimal priceHouse;
       		 String soqlList = ' id,Site_ID__c, Name, Account_Address__c, Account_Name__c, Website_Event_ID__c,Program_Location__r.Name,CurrencyIsoCode,Franchise_ID__c,ProgramName__c,Program_Location__r.Location_state_code__c,';
            String soqlList1=    soqlList +' Delivery_Language__c,Delivery_Language_label__c, Program_Description_for_Website__c, DeliveryMethod__c, Program_Location__c, Absorb_Token__c,Local_Tax__c,State_Tax__c,';
            String soqlList2=    soqlList1 +' ProgramType__c,BaseRegistrationFee__c,UseInHouseProgramPricing__c,InHouseProgramPrice__c,ProgramAwarenessFee__c ,Total_Tax__c,AwarenessSustainmentFee__c ,Federal_Tax__c,Tax_Actual__c,';
            String soqlList3 =   soqlList2+ ' Delivered_on_eVolve__c, eVolve_Course_Slug__c, eVolve_sublicense_ID__c, Timezone__c, TotalSessions__c,Connection_Information__c, Duration_Category__c,Area_Location__c, Value_Added_Tax__c,';
            String soqlList4 =   soqlList3+'  Session1StartDateTime__c, Program_Graduation_Start_Date_Time__c,Product__c, MaximumRegistrations__c, OrientationEndDateTime__c,OrientationStartDateTime__c, ';
            String soqlList5=  soqlList4+' SustainmentEndDateTime__c, SustainmentStartDateTime__c, Program_Graduation_End_Date_Time__c, Private_Event__c, RecordTypeId,Session1EndDateTime__c,  ';
            String soqlList6=  soqlList5+ 'Program_Location__r.Location_Street__c, Program_Location__r.Location_State_Province__c,Program_Location__r.Location_State_US__c, Program_Location__r.Location_Country__c, Program_Location__r.Location_Zip_Postal_Code__c, Program_Location__r.Location_City__c';
          
            //soqlList = soqlList.removeEnd(',');
            system.debug('soqlList '+soqlList6);
            String query = 'select '+ soqlList6 +' from  Program__c where Id=:programId';
            system.debug(query);
            List<program__c> programQuery = database.query(query);
            system.debug('programQuery '+programQuery);
            program__c prgm = programQuery[0];
        Site__c site = [SELECT Id, Site_ID__c, Name, Area_Location__c FROM Site__c WHERE Area_Location__c = :prgm.Area_Location__c LIMIT 1];
        Product2 prdct = [SELECT Id, Website_Course_ID__c, Name FROM Product2 WHERE id=:prgm.Product__c LIMIT 1];
        string currencyVal = prgm.CurrencyIsoCode;
        ProgramData programData = new ProgramData();
        programData.location = prgm.Program_Location__r.Name;
        programData.event_id = Integer.valueOf(prgm.Website_Event_ID__c);
        programData.address_1 = prgm.Program_Location__r.Location_Street__c;
        // Set other program data properties here
        
            //programObject.put('address_2',prgm.Program_Location__r.Name);
           // programObject.put('phone_number',prgm.Program_Location__r.Name);
            programData.course_slug = prgm.eVolve_Course_Slug__c;
            programData.country = prgm.Program_Location__r.Location_Country__c;
            if(prgm.Program_Location__r.Location_Country__c == 'United States'){
                programData.state_or_province = prgm.Program_Location__r.Location_state_code__c;
            }else{
            programData.state_or_province = prgm.Program_Location__r.Location_State_Province__c;
            }
            programData.city = prgm.Program_Location__r.Location_City__c;
            programData.zip_code = prgm.Program_Location__r.Location_Zip_Postal_Code__c;
            programData.duration_amount = Integer.valueOf(prgm.TotalSessions__c);
            programData.start_date_time = prgm.Session1StartDateTime__c;
            programData.end_date_time = prgm.Program_Graduation_End_Date_Time__c;
            //programData.spots_available = Integer.valueof(prgm.MaximumRegistrations__c);
            //programData.spots_used_offline = prgm.Program_Location__r.Name;//question
            programData.evolve = prgm.Delivered_on_eVolve__c;//question
            programData.evolve_sublicense_id = prgm.eVolve_sublicense_ID__c;
            programData.learn_from_anywhere = false;//question
           // programData.currency =prgm.CurrencyIsoCode;//CurrencyIsoCode
           decimal localTax = ((prgm.Local_Tax__c!=null ) ?prgm.Local_Tax__c:0 );
        decimal stateTax = ((prgm.State_Tax__c!=null ) ?prgm.State_Tax__c:0 );
        decimal federalTax = ((prgm.Federal_Tax__c!=null ) ?prgm.Federal_Tax__c:0 );
        decimal valueAddedTax = ((prgm.Value_Added_Tax__c!=null ) ?prgm.Value_Added_Tax__c:0 );
        system.debug('(prgm.BaseRegistrationFee__c + prgm.AwarenessSustainmentFee__c)' +(prgm.BaseRegistrationFee__c + prgm.AwarenessSustainmentFee__c));    
        if(prgm.UseInHouseProgramPricing__c == True && prgm.ProgramType__c =='In-house'){
                priceHouse = prgm.InHouseProgramPrice__c + prgm.ProgramAwarenessFee__c + prgm.Total_Tax__c;
            }else if(prgm.UseInHouseProgramPricing__c == False && prgm.ProgramType__c =='In-house'){
                priceHouse = prgm.BaseRegistrationFee__c + prgm.AwarenessSustainmentFee__c + prgm.Total_Tax__c ;
                
            }
        else if( prgm.ProgramType__c =='Public'){
                priceHouse = prgm.AwarenessSustainmentFee__c + prgm.BaseRegistrationFee__c+ (
                    ( localTax+ stateTax + federalTax + valueAddedTax )*(prgm.BaseRegistrationFee__c + prgm.AwarenessSustainmentFee__c));
            }
            system.debug('priceHouse -' +priceHouse);
            programData.price = priceHouse;//question//ask
           // programObject.put('published_at',prgm.Program_Location__r.Name);//question
            programData.expired_at = prgm.Program_Graduation_End_Date_Time__c;//question
            if(prgm.SustainmentStartDateTime__c!=null)
            	programData.sustainment =true;//question
            else
                programData.sustainment = false;
        	List<sustainment_dates> sustainmentList = new List<sustainment_dates>();
       			sustainment_dates sustainment = new sustainment_dates();
            	sustainment.start_date = prgm.SustainmentStartDateTime__c;
				sustainment.end_date = prgm.SustainmentEndDateTime__c;
        sustainmentList.add(sustainment);
            programData.sustainment_dates = sustainmentList;
        //List<short_description> sds = new List<short_description>();
        //short_description sss= new short_description();
       // sss.html = prgm.Program_Description_for_Website__c;
       // sds.add(sss);
            programData.short_description = prgm.Program_Description_for_Website__c;
            if(prgm.OrientationStartDateTime__c != null)
            	programData.kickoff = true;//question
            else
                programData.kickoff = false;
            programData.kickoff_date = prgm.OrientationStartDateTime__c;//question
             programData.kickoff_end_date = prgm.OrientationEndDateTime__c;//question
             programData.timezone = prgm.Timezone__c;//question
             programData.course_id = Integer.valueof(prdct.Website_Course_ID__c);//question(new to create)
             programData.locale = 'En';//question
        system.debug('prgm.Duration_Category__c = '+prgm.Duration_Category__c);
             programData.duration_type_id = 7;//question
            if(prgm.Duration_Category__c == 'Multi Session'){
                programData.duration_category_id = 1;
            }else if(prgm.Duration_Category__c == 'Full Consecutive Days'){
                programData.duration_category_id = 2;
            }else if(prgm.Duration_Category__c == '<2 Hours'){
                programData.duration_category_id = 3;
            }else if(prgm.Duration_Category__c == '2-3 Hours'){
                programData.duration_category_id = 4;
            }else if(prgm.Duration_Category__c == '3+ Hours'){
                programData.duration_category_id =5;
            }
        system.debug('prgm.Duration_Category__c = '+programData.duration_category_id);
            // programObject.put('duration_category_id',prgm.Duration_Category__c);//question
             programData.delivery_language = prgm.Delivery_Language_label__c;
            programData.program_code = prgm.Name;
					programData.post_purchase_information = prgm.Connection_Information__c;
            programData.franchise_id = integer.valueof(site.Site_ID__c);
            // programData.private_event = false;
             programData.salesforce_program_id = prgm.Id;
        	
        // Set other program data properties for updating
        
        putProgram(programData, currencyVal );
    }
}