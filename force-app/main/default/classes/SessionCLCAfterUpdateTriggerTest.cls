@isTest
public class SessionCLCAfterUpdateTriggerTest {
    @isTest
    public static void testHandleAfterUpdate() {
    
        Trainer_Certification_Event__c TCE = new Trainer_Certification_Event__c();
        TCE.Name = 'Test TCE';
        TCE.Weekdays__c = 'Monday;Wednesday;Friday';
        TCE.Total_Sessions__c = 10;
        TCE.Session_One_Start_DateTime__c=DateTime.newInstance(2023, 1, 1,1,0,0);
        TCE.Session_One_End_Date_Time__c = datetime.newInstance(2023, 1, 1,2,0,0);
        TCE.Process_Sharing__c = true;
        insert TCE;
        
        
        List<Session_CLC_Event__c> Sinsert = new List<Session_CLC_Event__c>();
        Session_CLC_Event__c Sess1 = new Session_CLC_Event__c();
        Sess1.Name = TCE.Name + ' S1';
        Sess1.Session_Date__c = Date.newInstance(2023, 1, 1);
        Sess1.Session_Number__c = '1';
        Sess1.Trainer_Certification_Event__c = TCE.ID;
        sess1.Session_Start_Time__c = TCE.Session_One_Start_DateTime__c.TIME();
        sess1.Session_End_Time__c = TCE.Session_One_End_Date_Time__c.TIME();
        Sinsert.add(Sess1);
        
        Session_CLC_Event__c Sess2 = new Session_CLC_Event__c();
        Sess2.Name = TCE.Name + ' S2';
        Sess2.Session_Date__c = Date.newInstance(2023, 1, 2);
        Sess2.Session_Number__c = '2';
        Sess2.Trainer_Certification_Event__c = TCE.ID;
        sess2.Session_Start_Time__c = TCE.Session_One_Start_DateTime__c.TIME();
        sess2.Session_End_Time__c = TCE.Session_One_End_Date_Time__c.TIME();
        Sinsert.add(Sess2);
        
        Session_CLC_Event__c Sess3 = new Session_CLC_Event__c();
        Sess3.Name = TCE.Name + ' S3';
        Sess3.Session_Date__c = Date.newInstance(2023, 1, 3);
        Sess3.Session_Number__c = '3';
        Sess3.Trainer_Certification_Event__c = TCE.ID;
        sess3.Session_Start_Time__c = TCE.Session_One_Start_DateTime__c.TIME();
        sess3.Session_End_Time__c = TCE.Session_One_End_Date_Time__c.TIME();
        Sinsert.add(Sess3);
        insert Sinsert;
        
        Map < Id, Session_CLC_Event__c > oMap = new Map < Id, Session_CLC_Event__c > ([select id,Name, Session_Date__c,Session_Number__c,
                                                                                                  Trainer_Certification_Event__c,Session_Start_Time__c,
                                                                                                 Session_End_Time__c from Session_CLC_Event__c where Id =:Sess2.id] );
        
        Session_CLC_Event__c S = [select id, Session_Date__c from Session_CLC_Event__c where Trainer_Certification_Event__c =:TCE.ID and Session_Number__c = '2'];
        //Session_CLC_Event__c Sess = new Session_CLC_Event__c();
        //Sess.Name = TCE1[0].Name + ' S1';
        S.Session_Date__c = Date.newInstance(2023, 1, 3);
        List<Session_CLC_Event__c> SUpdate = new List<Session_CLC_Event__c>();
        //Test.startTest();
        SUpdate.add(S);
        
        update SUpdate;
      
        //SessionCLCAfterUpdateTrigger.handleAfterUpdate(SUpdate, oMap);
		//Test.stopTest();        
        
        
        
    
    }

}