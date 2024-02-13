public with sharing class TrainerCertificationEventRequestForm {
 public String validFor;
    @AuraEnabled
    public static List<string> getAcademyPicklistValues(){
        Schema.DescribeFieldResult fieldResult = Trainer_Certification_Event__c.Academy__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        // Create a list to store the picklist values
        List<String> academyValues = new List<String>();
        for (Schema.PicklistEntry entry : picklistValues) {
            academyValues.add(entry.getValue());
        }

        return academyValues;
    }
	
    @AuraEnabled(cacheable=true)
    public static string getCustomSettings(){
        PushtoWebAccess__c acc = PushtoWebAccess__c.getInstance('API Access Token');
        system.debug(acc.trainercertificationeventRecordId__c);
       return acc.trainercertificationeventRecordId__c;
	}
    
    @AuraEnabled(cacheable=true)
    public static Map<string,string> getActiveAccountsPicklist() {
        Map<string,string> options = new Map<string,string>();
        Id FranchiseID = [select id from RecordType where DeveloperName ='Franchisee' and SobjectType ='Account'][0].id;
        // Query for active accounts
        List<Account> activeAccounts = [SELECT Id, Name, Account_Name_Formula__c,Franchise_Principle_Name__c FROM Account WHERE Status__c='Active' and RecordTypeId =: FranchiseID];//'0123K000000AB7uQAG'];
        
        // Create SelectOption objects from the queried accounts
        for (Account acc : activeAccounts) {
            options.put(acc.Id, acc.Account_Name_Formula__c);
        }
        
        return options;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getweekDaysValues() {
        // Query distinct Status__c values from your records
        Schema.DescribeFieldResult fieldResult = Trainer_Certification_Event__c.Weekdays__c.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

        // Create a list to store the picklist values
        List<String> weekDaysValues = new List<String>();
        for (Schema.PicklistEntry entry : picklistValues) {
            weekDaysValues.add(entry.getValue());
        }
        system.debug(weekDaysValues);
        return weekDaysValues;
        
    }

    @AuraEnabled
    public static void handleSave(String wrapParams){
        List<createTrainerCertEvent> listOfParams = (List<createTrainerCertEvent>) JSON.deserialize(wrapParams, List<createTrainerCertEvent>.class);
            system.debug(listOfParams);
        List<Trainer_Certification_Event__c> ers = new List<Trainer_Certification_Event__c>();
       Group grp = [select id, name from Group where name = 'CLC Queue' ];
        for(createTrainerCertEvent cte :listOfParams){
             Trainer_Certification_Event__c elc = new Trainer_Certification_Event__c();
            elc.Academy__c = cte.controllerValue;
			elc.Additional_Information__c =  cte.addInfo;
           // elc.Additional_Online_Sessions__c = 
            elc.City__c= cte.city;
            elc.OwnerId = grp.id;
            elc.Street__c = cte.street;
            elc.Zip_Postal_Code__c= cte.zip;  
            elc.Country__c = cte.country;
             elc.State_Province__c = cte.state;
            if(cte.selectedAdtnlSessions!=null && cte.selectedAdtnlSessions!=''){
            elc.Additional_Online_Sessions__c = Decimal.ValueOf(cte.selectedAdtnlSessions);
            }else{
                elc.Additional_Online_Sessions__c = 0;
            }
            elc.Timezone_Notes__c = cte.enteredTimeZone;
            elc.Total_Sessions__c = Integer.ValueOf(cte.selectedTotalSessions);
            //elc.Additional_Online_Sessions__c = Integer.ValueOf(cte.selectedAdtnlSessions);
            elc.Event_Location_Phone__c = cte.eventphone;
            //elc.Event_Subtype__c = 
            elc.Event_Type__c = cte.dependentValue;
            //elc.Total_Sessions__c = 2;
            elc.Name = 'sample event req- ' +cte.dependentValue;
          
            elc.Franchisee__c = cte.selectedAccountId;
            elc.Host_Franchisee_Email_Address__c = cte.email;
            elc.Hotel_City__c = cte.reccity;
            elc.Hotel_country__c = cte.reccountry; 
            elc.Hotel_Phone_Number__c = cte.recphone;
            elc.Hotel_State__c = cte.recstate;
           	elc.Hotel_Street_Address__c = cte.recstreet;
            elc.Hotel_Zip__c =  cte.reczip;
            
           /* List<String> languages = cte.language;
                if (languages != null && !languages.isEmpty()) {
            		elc.Language__c = String.join(languages, ';'); // Save as comma-separated string
        		}*/
            elc.Language__c =cte.language;
            elc.Local_Contact_Name__c = cte.name;
            elc.Contact_Email__c =cte.selectedEmail;
            elc.Contact_Phone__c = cte.selectedPhone;
           
            if(cte.blended == 'true') {
            elc.Blended__c = true;
            }
            elc.Location__c = cte.eventLoc;
            //elc.Master_Trainer_Fee__c =
            if(cte.showConditionalFields == 'true') {
            elc.Online_Event__c = true;
            }
            elc.Public_Private__c =  cte.publicprivate;
            elc.Recommended_Hotel_Name__c = cte.recHotelName;
            elc.Requested_Carnegie_Master_Master_Trainer__c= cte.reqMaster;
            elc.Additional_Session_Notes__c = cte.sessNotes;
           
            List<String> timeParts = cte.selectedEndTime.split(':');

                Integer hours = Integer.valueOf(timeParts[0]);
                Integer minutes = Integer.valueOf(timeParts[1]);
                Integer seconds = Integer.valueOf(timeParts[2]);

    // Create a Time instance
			Time timeValue = Time.newInstance(hours, minutes, seconds, 0);
            elc.Session_One_End_Date_Time__c = Datetime.newInstance(Date.ValueOf(cte.selectedDate), timeValue);
            List<String> timeParts1 = cte.selectedStartTime.split(':');

                Integer hours1 = Integer.valueOf(timeParts1[0]);
                Integer minutes1 = Integer.valueOf(timeParts1[1]);
                Integer seconds1 = Integer.valueOf(timeParts1[2]);

   			Time selectedStartTime = Time.newInstance(hours1, minutes1, seconds1, 0);
            //elc.Session_One_End_Time__c = timeValue;
            //elc.Session_One_Start_Time__c = selectedStartTime;
            elc.Session_One_Start_DateTime__c = Datetime.newInstance(Date.ValueOf(cte.selectedDate), selectedStartTime);
           
            elc.Request_Status__c = 'In Review';
            List<String> weekdays = cte.weekDays;
           
             if (weekdays != null && !weekdays.isEmpty()) {
            		elc.Weekdays__c = String.join(weekdays, ';'); // Save as comma-separated string
        		}
            ers.add(elc);
        }
        system.debug('erc - '+ers.size());
        //database.insert(ers,true);
       List<Database.upsertResult> insertResults = Database.upsert(ers, false);
    	for (Database.upsertResult sr : insertResults) {
            if (sr.isSuccess()) {
                // The record was successfully inserted
                System.debug('Record successfully inserted. Id: ' + sr.getId());
                //System.debug('Record successfully inserted. Id elc: ' + elc);
                //Event_Registration_CLC__c ercl = [select id,trainer__c from Event_Registration_CLC__c where Trainer_Certification_Event__c =:eventId Order by CreatedDate DESC LIMIT 1 ];
                
                
        }
             else {
                // The record failed to insert, handle the error
                for (Database.Error err : sr.getErrors()) {
                    System.debug('Error message: ' + err.getMessage());
                    System.debug('Fields that caused the error: ' + err.getFields());
                }
            }
        }
    }
    public class createTrainerCertEvent {
        @AuraEnabled public String controllerValue{get;set;}
        @AuraEnabled public String dependentValue{get;set;}
        
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String email{get;set;}
        @AuraEnabled public String selectedPhone{get;set;}
        @AuraEnabled public String selectedEmail{get;set;}
        @AuraEnabled public String selectedDate{get;set;}
        @AuraEnabled public String addInfo{get;set;}
         @AuraEnabled public String reqMaster{get;set;}
         @AuraEnabled public String eventLoc{get;set;}
        
         @AuraEnabled public String sessNotes{get;set;}
        @AuraEnabled public String selectedTotalSessions{get;set;}
        @AuraEnabled public String selectedAdtnlSessions{get;set;}
        @AuraEnabled public String selectedStartTime{get;set;}
        @AuraEnabled public String selectedEndTime{get;set;}
        @AuraEnabled public String eventphone{get;set;}
        @AuraEnabled public String enteredTimeZone{get;set;}
        
        @AuraEnabled public String street{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String country{get;set;}
        @AuraEnabled public String zip{get;set;}
        @AuraEnabled public String state{get;set;}

        @AuraEnabled public String recHotelName{get;set;}
        @AuraEnabled public String reccountry{get;set;}
        @AuraEnabled public String reccity{get;set;}
        @AuraEnabled public String recstate{get;set;}
        @AuraEnabled public String recstreet{get;set;}
        @AuraEnabled public String reczip{get;set;}
        
        
        @AuraEnabled public String showConditionalFields{get;set;}
        @AuraEnabled public String blended{get;set;}
        @AuraEnabled public String publicprivate{get;set;}
        @AuraEnabled public String language{get;set;}
        @AuraEnabled public String selectedAccountId{get;set;}
        @AuraEnabled public List<String> weekDays{get;set;}
        @AuraEnabled public String recphone{get;set;}
            
    }
}