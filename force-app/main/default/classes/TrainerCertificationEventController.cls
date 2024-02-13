public   without sharing class TrainerCertificationEventController {
    @AuraEnabled(cacheable=true)
    
    public static List<Trainer_Certification_Event__c> getTrainerCertEvent(String eventType) {
        date todaydate = system.today();
        List<Trainer_Certification_Event__c> trainers = [select id, Event_Type__c, Location__c,Level__c, Event_Subtype__c,Deadline__c,Session_One_Date_from_DateTime__c,Total_Sessions_with_Additional__c,Estimated_Cost_per_Candidate__c,
                                                        Language__c,Request_Status__c,Registration_Status__c, Name,Public_Private__c,Region__c, Master_Trainer_Fee__c, Max_Registrations__c, Status__c,Session_One_Start_DateTime__c,
                                                        Franchisee__r.Name,Street__c,Local_Contact_Name__c,Contact_Email__c,Timezone_Notes__c,
                                                         Country__c from Trainer_Certification_Event__c where Status__c!='Cancelled' and 
                                                          Session_One_Start_DateTime__c >= today and Request_Status__c='Approved' ];
        return trainers;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCountryPicklistValues() {
        // Query distinct Status__c values from your records
        List<String> countryValues = new List<String>();
        for (AggregateResult result : [SELECT Country__c FROM Trainer_Certification_Event__c WHERE Country__c != null GROUP BY Country__c]) {
            countryValues.add((String)result.get('Country__c'));
        }
        return countryValues;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getEventTypeValues() {
        // Query distinct Status__c values from your records
        Schema.DescribeFieldResult fieldResult = Trainer_Certification_Event__c.Event_Type__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        // Create a list to store the picklist values
        List<String> eventTypeValues = new List<String>();
        for (Schema.PicklistEntry entry : picklistValues) {
            eventTypeValues.add(entry.getValue());
        }

        return eventTypeValues;
        
    }

    @AuraEnabled( cacheable=true)
    public static List<Session_CLC_Event__c> getSessions(String eventId){
        system.debug(eventId);
        List<Session_CLC_Event__c> sessions = [select id, Session_Number__c, Session_Date__c, Session_End_Time__c, Session_Start_Time__c,Trainer_Certification_Event__c from Session_CLC_Event__c
                                where Trainer_Certification_Event__c = :eventId];
        system.debug('sessions -' +sessions);
        if(sessions!=null || sessions.size()>0)
               return sessions;
         else
               return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getLanguageValues() {
        // Query distinct Status__c values from your records
        Schema.DescribeFieldResult fieldResult = Trainer_Certification_Event__c.Language__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        // Create a list to store the picklist values
        List<String> languageValues = new List<String>();
        for (Schema.PicklistEntry entry : picklistValues) {
            languageValues.add(entry.getValue());
        }

        return languageValues;
        
    }

    @AuraEnabled
    public static String getStatusFromRecord(){
        List<Trainer_Certification_Event__c> trainers = [select id, Event_Type__c, Location__c,Level__c, Event_Subtype__c,
													 Language__c,Name,Public_Private__c,Master_Trainer_Fee__c, Max_Registrations__c, Status__c,
                                                         Country__c from Trainer_Certification_Event__c ];
        return 'trainers';
        
    }

    @AuraEnabled(cacheable=true)
    public static List<Trainer_Certification_Event__c> getEventTypeVal(string eventId) {
        // Query distinct Event_Subtype__c values from your records
        List<Trainer_Certification_Event__c> trainers = [select id, Event_Type__c, Location__c,Level__c, Event_Subtype__c,Franchisee__r.Name,Street__c,Local_Contact_Name__c,Contact_Email__c,Timezone_Notes__c,
                                                         Language__c,Name,Public_Private__c,Region__c,Estimated_Cost_per_Candidate__c, Master_Trainer_Fee__c, Max_Registrations__c, Status__c,
                                                         Country__c from Trainer_Certification_Event__c where id=:eventId];
        return trainers;
    }

    @AuraEnabled(cacheable=true)
    public static List<Date> getDatePicklistValues() {
        // Query distinct Event_Subtype__c values from your records
        List<Date> DateValues = new List<Date>();
        for (AggregateResult result : [SELECT Session_One_Date_from_DateTime__c FROM Trainer_Certification_Event__c WHERE Session_One_Date_from_DateTime__c != null GROUP BY Session_One_Date_from_DateTime__c]) {
            DateValues.add((Date)result.get('Session_One_Date_from_DateTime__c'));
        }
        system.debug(DateValues);
        return DateValues;
    }

    @AuraEnabled
    public static void handleSave(String wrapParams) {
        List<createTrainerCertEvent> listOfParams = (List<createTrainerCertEvent>) JSON.deserialize(wrapParams, List<createTrainerCertEvent>.class);
            system.debug(listOfParams);
        
        List<Event_Registration_CLC__c> ers = new List<Event_Registration_CLC__c>();
        List<Education_History__c> ehcList = new List<Education_History__c>();
        string eventId ;
       List<EducationRowWrapper> educationRows = new List<EducationRowWrapper>();
        List<Trainer__c> trainersListForUpdate = new List<Trainer__c>();
        Group grp = [select id, name from Group where name = 'CLC Queue' ];
        for(createTrainerCertEvent cte :listOfParams){
            Event_Registration_CLC__c elc = new Event_Registration_CLC__c();
            system.debug(cte.language);
            List<Trainer__c> trainer = [select id ,Name from Trainer__c where (First_Name__c = : cte.firstName and Last_Name__c = :cte.lastName 
                                 and Primary_Email_Address__c =:cte.emailAddress) limit 1 ];
            system.debug('trainer '  +trainer);
            
            if(trainer!=null && trainer.size()>0){
                elc.Trainer__c = trainer[0].id;
                Trainer__c trainers = new Trainer__c();
                if(cte.Salutation != null)
                    trainers.Salutation__c = cte.Salutation;
                // trainer.Secondary_Email_Address__c = 
                if(cte.trainerManEmail != null)
                    trainers.Trainer_Manager_Email__c = cte.trainerManEmail;
                if(cte.trainerManFN != null)
                    trainers.Trainer_Manager_First_Name__c = cte.trainerManFN;
                if(cte.trainerManLN != null)
                    trainers.Trainer_Manager_Last_Name__c = cte.trainerManLN;
                if(cte.city!=null)
                    trainers.Organization_City__c = cte.city;
                if(cte.country!=null)
                    trainers.Organization_Country__c = cte.country;
                
                if(cte.telephone != null)
                    trainers.Organization_Phone__c = cte.telephone;
                if(cte.extension != null)
                    trainers.Organization_Phone_Extension__c = cte.extension;
                if(cte.state != null)
                    trainers.Organization_State__c = cte.state;
                if(cte.streetAddress !=null)
                    trainers.Organization_Street_Address__c = cte.streetAddress;
                if(cte.zip != null)
                    trainers.Organization_Zip__c = cte.zip;
                if(cte.city!=null)
                    trainers.Home_City__c = cte.city;
                if(cte.country!=null)
                    trainers.Home_Country__c = cte.country;
                if(cte.telephone != null)
                    trainers.Home_Phone__c = cte.telephone;
                if(cte.state != null)
                    trainers.Home_State__c = cte.state;
                if(cte.streetAddress !=null)
                    trainers.Home_Street_Address__c = cte.streetAddress;
                if(cte.zip != null)
                    trainers.Home_Zip__c = cte.zip;
                if(cte.jobTitle != null)
                    trainers.Job_Title__c = cte.jobTitle;
                trainers.Id = trainer[0].id;
                trainersListForUpdate.add(trainers);
                
                  //  trainer.Personal_Mobile_Phone__c = 
            }else{
                elc.Trainer__c = null;
            }
            system.debug('trainersListForUpdate - '+trainersListForUpdate);
            educationRows = cte.educationRows;
           // elc.Exit_Date__c = system.today();
            elc.Exit_Type__c = '';
            elc.Registration_Date__c = system.today(); 
            eventId = cte.eventId;
            elc.Salutation__c = cte.Salutation;
                elc.First_Name__c = cte.firstName;
                //elc.Gender__c = 'Male';
            if(cte.addressType == 'Business'){
                elc.Organization_City__c = cte.city;
                elc.Organization_Country__c = cte.country;
                elc.Organization_Mobile_Phone__c = cte.telephone;
                elc.Organization_Phone__c =cte.telephone;
                elc.Organization_State__c = cte.state;
                elc.Organization_Street_Address__c = cte.streetAddress ;
                elc.Organization_Phone_Extension__c = cte.extension;
                elc.Organization_Zip__c = cte.zip;
            } else if(cte.addressType == 'Home'){
                elc.Home_City__c = cte.city;
                elc.Home_Country__c = cte.country;
                elc.Home_Phone__c = cte.telephone;
                elc.Home_State__c = cte.state;
                elc.Home_Street_Address__c = cte.streetAddress ;
                elc.Home_Zip__c = cte.zip;
            }
                elc.OwnerId = grp.id;
                elc.Last_Name__c = cte.lastName;
                elc.Job_Title__c = cte.jobTitle;
            List<String> languages = cte.language;
               if (languages != null && !languages.isEmpty()) {
            		elc.Languages_Spoken__c = String.join(languages, ';'); // Save as comma-separated string
        		}
            
            	// elc.Languages_Spoken__c =cte.language;
                elc.Primary_Email_Address__c = cte.emailAddress;
               elc.Trainer_Certification_Event__c =  cte.eventId;
                elc.Trainer_Manager_Email__c = cte.trainerManEmail;
                elc.Trainer_Manager_First_Name__c= cte.trainerManFN;
                elc.Trainer_Manager_Last_Name__c = cte.trainerManLN;
               elc.Trainer_s_Franchise__c = cte.franchise;
                elc.Program_Exposure__c = cte.prgExpose;
            ers.add(elc);
        }
			system.debug(ers.Size());
       // database.insert(ers,true);
        
       
       List<Database.upsertResult> insertResults = Database.upsert(ers, false);
    	for (Database.upsertResult sr : insertResults) {
            if (sr.isSuccess()) {
                // The record was successfully inserted
                System.debug('Record successfully inserted. Id: ' + sr.getId());
                //System.debug('Record successfully inserted. Id elc: ' + elc);
                //Event_Registration_CLC__c ercl = [select id,trainer__c from Event_Registration_CLC__c where Trainer_Certification_Event__c =:eventId Order by CreatedDate DESC LIMIT 1 ];
                
   				List<Database.upsertResult> updateResults = Database.upsert(trainersListForUpdate, false);
                for (Database.upsertResult sr1 : updateResults) {
                    if (sr1.isSuccess()) {
                        System.debug('Record successfully Updated. Id: ' + sr.getId());
                    }else {
                        // The record failed to insert, handle the error
                        for (Database.Error err : sr1.getErrors()) {
                            System.debug('Error message: ' + err.getMessage());
                            System.debug('Fields that caused the error: ' + err.getFields());
                        }}
                }
                
                insertEducationHistory(educationRows,eventId,sr.getId());
        }
             else {
                // The record failed to insert, handle the error
                for (Database.Error err : sr.getErrors()) {
                    System.debug('Error message: ' + err.getMessage());
                    System.debug('Fields that caused the error: ' + err.getFields());
                }
            }
        }
        
        //system.debug('ed - '+ehcList);
        system.debug('ers - '+ers);
       
      // database.insert(ehcList,true);
        
    }

    public static void insertEducationHistory (List<EducationRowWrapper> educations,String eventId , String RegId){
        
        system.debug('RegId - ' +RegId);
        //Event_Registration_CLC__c ercl = [select id,trainer__c from Event_Registration_CLC__c where Trainer_Certification_Event__c =:eventId and Id = :RegId Order by CreatedDate DESC LIMIT 1 ];
                List<Education_History__c> ehcList = new List<Education_History__c>();
        for(EducationRowWrapper erw :educations){
                        Education_History__c egc = new Education_History__c();
                   // egc.Degree__c = erw.degree;
                    egc.School__c = erw.school;
                    egc.Degree_Type__c = erw.degreeType;
                    egc.Major__c = erw.major;
            		egc.Location__c = erw.location ;
                    //egc.Trainer_CLC_Contact__c = ercl.trainer__c;
                    //egc.Event_Registration__c = ercl.id;
                    egc.Event_Registration_Id__c = RegId;
                    ehcList.add(egc);
        }
        savepoint sp = database.setsavepoint();
        List<Database.upsertResult> insertResults1 = Database.upsert(ehcList, false);
        
    	for (Database.upsertResult sr : insertResults1) {
            if (sr.isSuccess()) {
                // The record was successfully inserted
                System.debug('Ed Record successfully inserted. Id: ' + sr.getId());
                 List<Education_History__c> ehc = [select id,name from Education_History__c where id = :sr.getId()];
                        system.debug('education - '+ehc);
            } else {
                // The record failed to insert, handle the error
                for (Database.Error err : sr.getErrors()) {
                    database.rollback(sp);
                    System.debug('Error message: ' + err.getMessage());
                    System.debug('Fields that caused the error: ' + err.getFields());
                }
            }
        }
       

    }
    public class createTrainerCertEvent {
        @AuraEnabled public String eventId{get;set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String Salutation{get;set;}
        @AuraEnabled public String middleName{get;set;}
        @AuraEnabled public String jobTitle{get;set;}
        
        @AuraEnabled public String streetAddress{get;set;}
                
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String country{get;set;}
        @AuraEnabled public String zip{get;set;}
        @AuraEnabled public String state{get;set;}

        @AuraEnabled public String telephone{get;set;}
        @AuraEnabled public String extension{get;set;}
        @AuraEnabled public String emailAddress{get;set;}
        @AuraEnabled public String confemailAddress{get;set;}
        @AuraEnabled public String trainerManFN{get;set;}
        @AuraEnabled public String trainerManLN{get;set;}
        @AuraEnabled public String trainerManEmail{get;set;}
        @AuraEnabled public List<String> language{get;set;}
        @AuraEnabled public String franchise{get;set;}
        @AuraEnabled public String addressType{get;set;}
        @AuraEnabled public String prgExpose{get;set;}
        @AuraEnabled public List<EducationRowWrapper> educationRows{get;set;}
    }
	public class EducationRowWrapper {
    @AuraEnabled
    public String school { get; set; }
    @AuraEnabled
    public String degreeType { get; set; }
    @AuraEnabled
    public String location { get; set; }
    @AuraEnabled
    public String major { get; set; }
         
        
}
}