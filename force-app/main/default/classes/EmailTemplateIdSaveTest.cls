@isTest
public class EmailTemplateIdSaveTest {
    @isTest
    static void setupData() {
        
        
        
        EmailTemplate em = [select id from EmailTemplate limit 1];
        
        
        Product2 prdct = new Product2();
        prdct.Name ='Test Product';
        prdct.Product_Type__c = '10 Sessions';
        prdct.Product_Group__c = 'Leadership';
        prdct.Product_Subgroup__c = 'DCD-MGSEE-2';
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
        program.Email_Template_Id__c = em.id;
        insert program;
        Registration__c reg = new Registration__c();
        reg.ProgramCode__c = program.Id;
        reg.RegistrationType__c = 'Registration';
        reg.RegistrationDate__c = Date.Today();
        reg.Lead_Source__c = 'Event';
        reg.ContactName__c = con.Id;
        reg.Completed_Sessions_Count__c = 5;
        insert reg;
        List<Registration__c> Regs = [select id from Registration__c where Id =:reg.Id];
        
        
        EmailTemplateIdSave.getProgramRec(program.Id);
        EmailTemplateIdSave.handleSave(em.id, program.Id);
        EmailTemplateIdSave.getProgramRec(program.Id);
        EmailTemplateIdSave.emailTrigger4mRegistration(Regs);
    }

}