@isTest
private class AttendanceTaken_Test {

    @isTest
    static void testGetSessionNumberPicklistValues() {
       
        List<AttendanceTaken.SessionWrapper> result = AttendanceTaken.getSessionNumberPicklistValues('YourTestProgramId');

        
        System.assert(result != null, 'Result should not be null');
        // Add more assertions as needed
    }

    @isTest
    static void testFetchRecords() {
        
        List<AttendanceTaken.ResultWrapper> result = AttendanceTaken.fetchRecords(createTestSearchWrapper());

    }

   
    
    @isTest
    public static void testMethod1(){
        Test.startTest();
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
        Id RecTypeId = [select id from RecordType where DeveloperName = 'Client_Builder_Master' and SobjectType ='Product2'][0].id;
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
        ss.Process_Sharing__c = true;
        insert ss;
        
        List<Id> sessids =new List<Id>();
        sessids.add(ss.id);
        AttendanceTaken.getSessionAttendance(ids,sessids);
        AttendanceTaken.checkAttendanceTransfer(sessids,ids,program.id);
        AttendanceTaken.checkAttendanceExists(program.id,ss.id);
        string sessId= ss.id;
        string pgId = program.id;
        AttendanceTaken.insertAttendanceRec(createTestcreateAttendance(),sessId,pgId,'test');
        test.stopTest();
        
    }
    
    @isTest
    public static void testMethod2(){
        Test.startTest();
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
        Id RecTypeId = [select id from RecordType where DeveloperName = 'Client_Builder_Master' and SobjectType ='Product2'][0].id;
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
        insert reg;
        List<Id> ids =new List<Id>();
        ids.add(reg.Id);
        
        Session__c ss = new Session__c();
        ss.AttendanceTaken__c = true;
        ss.Program__c = program.id;
        ss.SessionNumber__c = '1';
        ss.SessionDate__c = Date.newInstance(2023, 1, 1);
        insert ss;
        Attendance__c att = new Attendance__c();
        att.AttendedPartA__c = 'Yes (Transfer)';
        att.AttendedPartB__c = 'Yes (Transfer)';
        att.Registration__c = reg.Id;
        att.Program__c = program.Id;
        att.Session__c = ss.id;
        insert att;
        List<Id> sessids =new List<Id>();
        sessids.add(ss.id);
        string sessId= ss.id;
        string pgId = program.id;
        AttendanceTaken.checkAttendanceTransfer(sessids,ids,program.id);
        AttendanceTaken.insertAttendanceRec(createTestcreateAttendance(),sessId,pgId,'test');
        AttendanceTaken.getRegistrationsByProgramId(pgId);
        test.stopTest();
        
    }
    
    @isTest
    public static void testMethod3(){
        Test.startTest();
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
        acc.Name = 'Test Acc12';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test Con12';
        con.AccountId = acc.Id;
        con.Email = 'con12@gmail.com';
        insert con;
        Contact con1 = new Contact();
        con1.LastName = 'Test Con122';
        con1.AccountId = acc.Id;
        con1.Email = 'con12@gmail.com';
        insert con1;
        
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
        insert reg;
        List<Id> ids =new List<Id>();
        ids.add(reg.Id);
        
        Session__c ss = new Session__c();
        ss.AttendanceTaken__c = true;
        ss.Program__c = program.id;
        ss.SessionNumber__c = '1';
        ss.SessionDate__c = Date.newInstance(2023, 1, 1);
        insert ss;
        Attendance__c att = new Attendance__c();
        att.AttendedPartA__c = 'Yes (Transfer)';
        att.AttendedPartB__c = 'Yes (Transfer)';
        att.Registration__c = reg.Id;
        att.Program__c = program.Id;
        att.Session__c = ss.id;
        insert att;
        Registration__c reg1 = new Registration__c();
        reg1.ProgramCode__c = program.Id;
        reg1.RegistrationType__c = 'Registration';
        reg1.RegistrationDate__c = Date.Today();
        reg1.Lead_Source__c = 'Event';
        reg1.ContactName__c = con1.Id;
        reg1.Completed_Sessions_Count__c = 5;
        insert reg1;
        ids.add(reg1.Id);
        List<Id> sessids =new List<Id>();
        sessids.add(ss.id);
        string sessId= ss.id;
        string pgId = program.id;
        AttendanceTaken.insertAttendanceRec(createTestcreateAttendance(),sessId,pgId,'test');
        test.stopTest();
        
    }
    
     private static AttendanceTaken.SearchWrapper createTestSearchWrapper() {
        AttendanceTaken.SearchWrapper testWrapper = new AttendanceTaken.SearchWrapper();
        testWrapper.objectApiName = 'Award__c';
        testWrapper.fieldApiName = 'Name';
        testWrapper.searchString = 'test';
        // Set necessary properties for your test
        return testWrapper;
    }
    
     private static string createTestcreateAttendance() {
        AttendanceTaken.createAttendance testWrapper = new AttendanceTaken.createAttendance();
         Award__c ac = new Award__c();
         ac.Name = 'test';
         insert ac;
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
         Account acc =  new Account();
        acc.Name = 'Test Acc11';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test Con1';
        con.AccountId = acc.Id;
        con.Email = 'con1@gmail.com';
        insert con;
         Registration__c reg1 = new Registration__c();
        reg1.ProgramCode__c = program.Id;
        reg1.RegistrationType__c = 'Registration';
        reg1.RegistrationDate__c = Date.Today();
        reg1.Lead_Source__c = 'Event';
        reg1.ContactName__c = con.Id;
        reg1.Completed_Sessions_Count__c = 5;
        insert reg1;
        testWrapper.prgmID =program.id ;
        testWrapper.awardPartA = ac.id;
        testWrapper.awardPartB = ac.id;
         testwRapper.attendedPartA = 'No';
         testwRapper.attendedPartB = 'No (Transfer)';
         testWrapper.registrationId = reg1.id;
             testwrapper.contactName = 'test';
         List<AttendanceTaken.createAttendance> attendanceList = new List<AttendanceTaken.createAttendance>();
		attendanceList.add(testwrapper);
        String wrapParams = JSON.serialize(attendanceList);
        return wrapParams;
    }
    
}