@isTest
public class TrainerCertificationEventController_Test {

    @isTest
    static void Test(){
        Test.startTest();
        Id FranchiseeRecTypeId =[select id from RecordType where DeveloperName = 'Franchisee'][0].id;
        Account acc = new Account();
        acc.Name = 'Test Franchise '+ DateTime.now();
        acc.RecordTypeId = FranchiseeRecTypeId;
        insert acc;
        String accId = acc.Id;
        Trainer_Certification_Event__c tce = new Trainer_Certification_Event__c();
        tce.Name = 'Test';
        tce.Total_Sessions__c = 10;
        tce.Session_One_End_Date_Time__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        tce.Session_One_Start_DateTime__c = DateTime.newInstance(2023, 1, 1,1,0,0);
        tce.Request_Status__c = 'Approved';
        tce.Weekdays__c = 'Monday;Wednesday;Friday';
        tce.Country__c = 'India';
        insert tce;
        Event_Registration_CLC__c ER = new Event_Registration_CLC__c();
        ER.Trainer_Certification_Event__c = tce.id;
        insert ER;
        
        //Id FranchiseID = [Select id from Account where RecordType.Name = 'Franchisee'][0].id;
         // '0013J00000XX3VgQAL'
        
        Trainer__c t = new Trainer__c();
        
	t.Name = 'Trainer';
    
    t.Contact__c = null;
    t.Trainer_Manager_Email__c = 'managerfname@name.com';
    t.Trainer_Manager_First_Name__c = 'manager FName';
    t.Trainer_Manager_Last_Name__c = 'Maanager LNam';
    
    t.Process_Sharing__c = false;
    t.Primary_Email_Address__c = 'tester@new.com';
    t.Contracted_By__c = acc.Id; //'0013J00000XBjr9QAD';
    t.First_Name__c = 'Tester';
    t.Franchisee_Approval__c = false;
    t.Gender__c = 'Male';
    t.Higher_Education__c = null;
    t.Home_City__c = 'home city';
    t.Home_Country__c = 'home country';
    t.Home_Phone__c = '9876532104';
    t.Home_State__c = 'home state';
    t.Home_Street_Address__c = 'home street';
    t.Home_Zip__c = 'home zip';
    t.Is_Available_to_Travel__c = false;
    t.Job_Title__c = 'job';
    t.Languages_Spoken__c = 'Arabic;Bahasa-Malaysian;Bulgarian';
    t.Last_Name__c = '1';
    t.Latest_Recertification_Date__c = null;
    t.Nick_Name__c = null;
    t.Notes__c = null;
    t.Organization_City__c = 'org city';
    t.Organization_Country__c = 'org country';
    t.Organization_Mobile_Phone__c = '9876532103';
    t.Organization_Name__c = 'org name';
    t.Organization_Phone_Extension__c = '9876532102';
    t.Organization_Phone__c = '9876532101';
    t.Organization_State__c = 'org state';
    t.Organization_Street_Address__c = 'org street';
    t.Organization_Zip__c = 'org zip';
    t.Personal_Mobile_Phone__c = '9876532100';
    t.Recertification_Due_Date__c = null;
    t.Salutation__c = null;
    t.Secondary_Email_Address__c = 'dalecarnegie@trainer.com';
    t.Share_Profile__c = false;
    t.Status__c = null;
    t.Transcript_Received__c = false;
    t.Digital_Producer__c = false;

        insert t;
        
        List<TrainerCertificationEventController.EducationRowWrapper> rslt = new List<TrainerCertificationEventController.EducationRowWrapper>();
        TrainerCertificationEventController.EducationRowWrapper wrap = new TrainerCertificationEventController.EducationRowWrapper();
        wrap.school = 'School';
        wrap.degreeType = 'BA';
        wrap.location = 'Location';
        wrap.major = 'Major';
        rslt.add(wrap);
        
        TrainerCertificationEventController.getTrainerCertEvent('');
    	TrainerCertificationEventController.getCountryPicklistValues();
        TrainerCertificationEventController.getDatePicklistValues();
        TrainerCertificationEventController.getEventTypeValues();
        TrainerCertificationEventController.getSessions(tce.Id);
        TrainerCertificationEventController.getSessions('');
        TrainerCertificationEventController.getStatusFromRecord();
        TrainerCertificationEventController.getLanguageValues();
        TrainerCertificationEventController.getEventTypeVal(tce.Id);
        TrainerCertificationEventController.insertEducationHistory(rslt,tce.Id,ER.Id);
        TrainerCertificationEventController.handleSave(TestcreateTrainerCertEvent());
        Test.stopTest();
    }
    
    private static string TestcreateTrainerCertEvent() {
        Trainer_Certification_Event__c tce = new Trainer_Certification_Event__c();
        tce.Name = 'Test1';
        tce.Total_Sessions__c = 10;
        tce.Session_One_End_Date_Time__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        tce.Session_One_Start_DateTime__c = DateTime.newInstance(2023, 1, 1,1,0,0);
        tce.Request_Status__c = 'Approved';
        tce.Weekdays__c = 'Monday;Wednesday;Friday';
        tce.Country__c = 'India';
        insert tce;
        
        List<TrainerCertificationEventController.EducationRowWrapper> rslt = new List<TrainerCertificationEventController.EducationRowWrapper>();
        TrainerCertificationEventController.EducationRowWrapper wrap = new TrainerCertificationEventController.EducationRowWrapper();
        wrap.school = 'School';
        wrap.degreeType = 'BA';
        wrap.location = 'Location';
        wrap.major = 'Major';
        rslt.add(wrap);
        List<String> Lang = new List<String>();
        Lang.add('English');
         TrainerCertificationEventController.createTrainerCertEvent testwrapper =  new TrainerCertificationEventController.createTrainerCertEvent();
         testwrapper.eventId  = tce.id;
         testwrapper.firstName = 'Tester';
         testwrapper.lastName = '1';
         testwrapper.Salutation = 'Mr.';
         testwrapper.middleName = ' - ';
         testwrapper.jobTitle = 'Dev';
        
         testwrapper.streetAddress = 'Hyd, TS';
         testwrapper.city = 'HYD';
         testwrapper.country = 'India';
         testwrapper.zip = '500032';
         testwrapper.state = 'TS';

         testwrapper.telephone = '8763459178';
         testwrapper.extension = 'No';
         testwrapper.emailAddress = 'tester@new.com';
         testwrapper.confemailAddress = 'tester@new.com';
         testwrapper.trainerManFN = 'TrainerFN';
         testwrapper.trainerManLN = 'TrainerLN';
         testwrapper.trainerManEmail = 'trainerFN@trainer.com';
         testwrapper.language = Lang;
         //Id FranchiseID = [Select id from Account where RecordType.Name = 'Franchisee'][0].id;
         
        Id FranchiseeRecTypeId =[select id from RecordType where DeveloperName = 'Franchisee'][0].id;
        Account acc = new Account();
        acc.Name = 'Test Franchise1 '+ (DateTime.now()+1);
        acc.RecordTypeId = FranchiseeRecTypeId;
        acc.BillingCity = 'aSZxcg';
        insert acc;
         testwrapper.franchise = acc.Id;//'0013J00000XX3VgQAL';
         testwrapper.addressType = 'Home';
         testwrapper.prgExpose = 'False';
         testwrapper.educationRows = rslt;
        List<TrainerCertificationEventController.createTrainerCertEvent> attendanceList = new List<TrainerCertificationEventController.createTrainerCertEvent>();
		attendanceList.add(testwrapper);
        String wrapParams = JSON.serialize(attendanceList);
        return wrapParams;
    }
    @isTest
    static void Test1()
    {
        test.startTest();
        TrainerCertificationEventRequestForm.getAcademyPicklistValues();
        TrainerCertificationEventRequestForm.handleSave(TestcreateTrainerCertEvent1());
        
        test.stopTest();
    }
    @isTest
    static void Test2()
    {
        test.startTest();
        
        TrainerCertificationEventRequestForm.getActiveAccountsPicklist();
        TrainerCertificationEventRequestForm.getweekDaysValues();
        test.stopTest();
    }
    
    
	private static string TestcreateTrainerCertEvent1() {
         TrainerCertificationEventRequestForm.createTrainerCertEvent testwrapper1 =  new TrainerCertificationEventRequestForm.createTrainerCertEvent();
         List<String> day = new List<String>();
        day.add('Monday');
        day.add('Tuesday');
		 testwrapper1.selectedDate  = String.valueOf(Date.newInstance(2023, 1, 1));
         testwrapper1.selectedEmail = 'Tester';
         testwrapper1.selectedPhone = '8765423443';
         testwrapper1.name = 'Test Event';
         testwrapper1.dependentValue = 'Senior Trainer Certification';
         testwrapper1.controllerValue = 'Trainer';
		 
		 testwrapper1.recphone  = '6217314241';
         
         testwrapper1.language = 'English';
         testwrapper1.publicprivate = 'Public';
         testwrapper1.blended = 'true';
         testwrapper1.showConditionalFields = 'Dev';
        
         testwrapper1.recstreet = 'Hyd1, TS1';
         testwrapper1.reccity = 'HYD1';
         testwrapper1.reccountry = 'India';
         testwrapper1.reczip = '500032';
         testwrapper1.recstate = 'TS1';
		 testwrapper1.recHotelName = 'No';
         
		 
		 testwrapper1.street = 'Hyd, TS';
         testwrapper1.city = 'HYD';
         testwrapper1.country = 'India';
         testwrapper1.zip = '500032';
         testwrapper1.state = 'TS';
         
         testwrapper1.eventphone = '7824371912';
         testwrapper1.selectedEndTime = '10:00:00';
         testwrapper1.selectedStartTime = '12:00:00';
         testwrapper1.selectedAdtnlSessions = '3';
         testwrapper1.selectedTotalSessions = '5';
         testwrapper1.weekDays = day;
         
        Id FranchiseeRecTypeId =[select id from RecordType where DeveloperName = 'Franchisee'][0].id;
        Account acc = new Account();
        acc.Name = 'Test Franchise1 '+ (DateTime.now()+1);
        acc.RecordTypeId = FranchiseeRecTypeId;
        acc.BillingCity = 'aSZxcgrfdt';
        insert acc;
        testwrapper1.selectedAccountId = acc.Id;
         testwrapper1.sessNotes = 'Test Note';//'0013J00000XX3VgQAL';
         testwrapper1.eventLoc = 'Home';
         testwrapper1.reqMaster = 'False';
         testwrapper1.addInfo = 'Addditional';
        List<TrainerCertificationEventRequestForm.createTrainerCertEvent> attendanceList = new List<TrainerCertificationEventRequestForm.createTrainerCertEvent>();
		attendanceList.add(testwrapper1);
        String wrapParams = JSON.serialize(attendanceList);
        return wrapParams;
    }
}