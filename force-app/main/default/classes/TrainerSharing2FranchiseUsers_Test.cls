@isTest
public class TrainerSharing2FranchiseUsers_Test {
@isTest
    public static void testMethod1(){
        Test.startTest();
        Id profileId =[ SELECT Id, Name FROM Profile  WHERE Name = 'System Administrator' LIMIT 1 ].Id ;
        Id FranchiseeRecTypeId =[select id from RecordType where DeveloperName = 'Franchisee'][0].id;
        
        User l_user = new User();
            l_user.FirstName = 'Test';
            l_user.LastName = 'User ' ;
            l_user.Email = 'noemail@dalecarnegie.com';
            l_user.Alias = 'null';
            l_user.Username = l_user.Email;
           // l_user.CommunityNickname = String.valueOf( l_rand );
            l_user.Franchise_ID__c = '12345';
            l_user.TimeZoneSidKey = 'America/Chicago';
            l_user.LocaleSidKey = 'en_US';
            l_user.EmailEncodingKey = 'ISO-8859-1';
            l_user.LanguageLocaleKey = 'en_US';
            l_user.IsActive = true;
        l_user.ProfileId = profileId;
        insert l_user;
         User l_user_1 = new User();
            l_user_1.FirstName = 'Test';
            l_user_1.LastName = 'User11 ' ;
            l_user_1.Email = 'noemail1@dalecarnegie.com';
            l_user_1.Alias = 'null';
            l_user_1.Username = l_user_1.Email;
           // l_user.CommunityNickname = String.valueOf( l_rand );
            l_user_1.Franchise_ID__c = '123456';
            l_user_1.TimeZoneSidKey = 'America/Chicago';
            l_user_1.LocaleSidKey = 'en_US';
            l_user_1.EmailEncodingKey = 'ISO-8859-1';
            l_user_1.LanguageLocaleKey = 'en_US';
            l_user_1.IsActive = true;
        l_user_1.ProfileId = profileId;
        insert l_user_1;
        
        Product2 prdct = new Product2();
        prdct.Name ='Test Product';
        prdct.Product_Type__c = '10 Sessions';
        prdct.Product_Group__c = 'Leadership';
        prdct.Product_Subgroup__c = 'DCD-MGSEE-2';
        //prdct.CurrencyIsoCode = 'USD - U.S. Dollar';
        prdct.Product_Availability__c = 'DCDigital';
        prdct.Total_Sessions__c = 10;
        prdct.Minimum_Registrations__c = 1;
        prdct.Maximum_Registrations__c = 5;
        prdct.Minimum_Sessions__c = 1;
        prdct.Continuing_Education_Units__c = 2;
        Id RecTypeId = [select id from RecordType where DeveloperName ='Client_Builder_Master'][0].id;
        prdct.RecordTypeId = RecTypeId;
        insert prdct;
        
        Account acc =  new Account();
        acc.Name = 'Test Acc';
        acc.OwnerId = l_user_1.id;
        acc.RecordTypeId = FranchiseeRecTypeId;
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Con';
        con.AccountId = acc.Id;
        con.Email = 'con@gmail.com';
        insert con;
        
        Program__c program = new Program__c();
        program.Name = 'Test Program';
        program.Weekdays__c = 'Monday;Wednesday;Friday';
        program.TotalSessions__c = 10;
        program.Session1StartDateTime__c=DateTime.newInstance(2023, 1, 1,1,0,0);
        program.Session1EndDateTime__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        program.MinimumSessions__c = 2;
        program.Product__c = prdct.Id;
        program.AllSessionsAttendanceTaken__c = true;
        insert program;
        Registration__c reg = new Registration__c();
        reg.ProgramCode__c = program.Id;
        reg.RegistrationType__c = 'Registration';
        reg.RegistrationDate__c = Date.Today();
        reg.Lead_Source__c = 'Event';
        reg.ContactName__c = con.Id;
        reg.Completed_Sessions_Count__c = 5;
        reg.Process_Sharing__c = true;
        insert reg;
        List<Id> ids =new List<Id>();
        ids.add(reg.Id);
        
        Session__c ss = new Session__c();
        ss.AttendanceTaken__c = true;
        ss.Program__c = program.id;
        ss.SessionNumber__c = '1';
        ss.SessionDate__c = Date.newInstance(2023, 1, 1);
        insert ss;
        
        Account accc = new Account();
        accc.Name = 'Test Franchise '+ DateTime.now();
        accc.RecordTypeId = FranchiseeRecTypeId;
        accc.OwnerId  = l_user.id;
        insert accc;
        String accId = accc.Id;
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
    t.OwnerId = l_user.id;
    t.Process_Sharing__c = false;
    t.Primary_Email_Address__c = 'tester@new.com';
    t.Contracted_By__c = accc.Id; //'0013J00000XBjr9QAD';
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
	t.Process_Sharing__c = true;
        insert t;
        Trainer_Certification__c tcs = new Trainer_Certification__c();
        tcs.Trainer__c = t.id;
        tcs.OwnerId = l_user.id;
        tcs.Certification_Level__c ='Master Trainer';
        insert tcs;
      Trainer__c ts  = new Trainer__c();
        ts.Contracted_By__c = acc.id;
        ts.id = t.id;
        //ts.OwnerId = l_user_1.id;
        update ts;
        Trainer_Certification__c tcss = new Trainer_Certification__c();
        //tcss.OwnerId = l_user_1.id;
        tcss.id = tcs.id;
        tcss.Trainer__c = ts.id;
        //update tcss;
        Available_Franchise__c afs = new Available_Franchise__c();
        afs.Trainer__c = t.id;
        afs.Franchise__c = accc.Id;
        afs.OwnerId = l_user.id;
       insert afs;
        Available_Franchise__c afss = new Available_Franchise__c();
        afss.OwnerId = l_user_1.id;
        afss.Id = afs.Id;
        afs.Franchise__c = acc.id;
        //update afss;
        Program_Trainer__c PT= new Program_Trainer__c();
        PT.Trainer__c = ts.id;
        PT.Program__c = program.id;
        PT.Process_Sharing__c = true;
        insert PT;
        
        //delete tce;
        //delete tcs;
        //delete afs;
        //delete ts;
        
        test.stopTest();
        
    }
    
   /* @isTest
    public static void testMethod2(){
        Test.startTest();
        Id profileId =[ SELECT Id, Name FROM Profile  WHERE Name = 'System Administrator' LIMIT 1 ].Id ;
        User l_user = new User();
            l_user.FirstName = 'Test';
            l_user.LastName = 'User ' ;
            l_user.Email = 'noemail@dalecarnegie.com';
            l_user.Alias = 'null';
            l_user.Username = l_user.Email;
           // l_user.CommunityNickname = String.valueOf( l_rand );
            l_user.Franchise_ID__c = '12345';
            l_user.TimeZoneSidKey = 'America/Chicago';
            l_user.LocaleSidKey = 'en_US';
            l_user.EmailEncodingKey = 'ISO-8859-1';
            l_user.LanguageLocaleKey = 'en_US';
            l_user.IsActive = true;
        l_user.ProfileId = profileId;
        insert l_user;
        Product2 prdct = new Product2();
        prdct.Name ='Test Product';
        prdct.Product_Type__c = '10 Sessions';
        prdct.Product_Group__c = 'Leadership';
        prdct.Product_Subgroup__c = 'DCD-MGSEE-2';
        //prdct.CurrencyIsoCode = 'USD - U.S. Dollar';
        prdct.Product_Availability__c = 'DCDigital';
        prdct.Total_Sessions__c = 10;
        prdct.Minimum_Registrations__c = 1;
        prdct.Maximum_Registrations__c = 5;
        prdct.Minimum_Sessions__c = 1;
        prdct.Continuing_Education_Units__c = 2;
        Id RecTypeId = [select id from RecordType where DeveloperName ='Client_Builder_Master'][0].id;
        prdct.RecordTypeId = RecTypeId;
        insert prdct;
        
        Account acc =  new Account();
        acc.Name = 'Test Acc';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test Con';
        con.AccountId = acc.Id;
        con.Email = 'con@gmail.com';
        insert con;
        
        Program__c program = new Program__c();
        program.Name = 'Test Program';
        program.Weekdays__c = 'Monday;Wednesday;Friday';
        program.TotalSessions__c = 10;
        program.Session1StartDateTime__c=DateTime.newInstance(2023, 1, 1,1,0,0);
        program.Session1EndDateTime__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        program.MinimumSessions__c = 2;
        program.Product__c = prdct.Id;
        program.AllSessionsAttendanceTaken__c = true;
        insert program;
        Registration__c reg = new Registration__c();
        reg.ProgramCode__c = program.Id;
        reg.RegistrationType__c = 'Registration';
        reg.RegistrationDate__c = Date.Today();
        reg.Lead_Source__c = 'Event';
        reg.ContactName__c = con.Id;
        reg.Completed_Sessions_Count__c = 5;
        reg.Process_Sharing__c = true;
        insert reg;
        List<Id> ids =new List<Id>();
        ids.add(reg.Id);
        
        Session__c ss = new Session__c();
        ss.AttendanceTaken__c = true;
        ss.Program__c = program.id;
        ss.SessionNumber__c = '1';
        ss.SessionDate__c = Date.newInstance(2023, 1, 1);
        insert ss;
        Id FranchiseeRecTypeId =[select id from RecordType where DeveloperName = 'Franchisee'][0].id;
        Account accc = new Account();
        accc.Name = 'Test Franchise '+ DateTime.now();
        accc.RecordTypeId = FranchiseeRecTypeId;
        accc.OwnerId  = l_user.id;
        insert accc;
        String accId = accc.Id;
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
	t.Process_Sharing__c = true;
        insert t;
        Trainer_Certification__c tcs = new Trainer_Certification__c();
        tcs.Trainer__c = t.id;
        tcs.Certification_Level__c ='Master Trainer';
        insert tcs;
      
        Trainer_Certification__c tcss = new Trainer_Certification__c();
        tcss.OwnerId = l_user.id;
        tcss.id = tcs.id;
        update tcss;
        Trainer_Certification__c tc_del = [select id from Trainer_Certification__c limit 1];
        //delete tc_del;
        Available_Franchise__c afs = new Available_Franchise__c();
        afs.Trainer__c = t.id;
        afs.Franchise__c = accc.Id;
       insert afs;
        Available_Franchise__c afss = new Available_Franchise__c();
        afss.OwnerId = l_user.id;
        afss.Id = afs.Id;
        update afss;
        test.stopTest();
    }*/
}