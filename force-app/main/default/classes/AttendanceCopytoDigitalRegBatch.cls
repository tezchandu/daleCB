global class AttendanceCopytoDigitalRegBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext context) { 
        // Query Attendance records with related DigitalReg records
        return Database.getQueryLocator([
            Select Id, Source_Registration_ID_Digital__c, Digital_Shared_Copy__c, Session_1_Award__c, Session_2_Award__c, Session_3_Award__c, Session_4_Award__c,
            Session_5_Award__c, Session_6_Award__c, Session_7_Award__c, Session_8_Award__c, Session_9_Award__c, Session_10_Award__c,
            Session_11_Award__c, Session_12_Award__c, Session_13_Award__c, Session_14_Award__c, Session_15_Award__c, Session_16_Award__c,
            Awareness_Award__c, Orientation_Award__c, Sustainment_Award__c , Session_1_Date__c, Session_2_Date__c, Session_3_Date__c, 
            Session_4_Date__c, Session_5_Date__c, Session_6_Date__c, Session_7_Date__c, Session_8_Date__c, Session_9_Date__c,
            Session_10_Date__c, Session_11_Date__c, Session_12_Date__c, Session_13_Date__c, Session_14_Date__c, Session_15_Date__c, 
            Session_16_Date__c, Awareness_Date__c, Sustainment_Date__c, Orientation_Date__c 
            , Attended_Session_1__c, Attended_Session_2__c, Attended_Session_3__c, Attended_Session_4__c, Attended_Session_5__c, Attended_Session_6__c,
            Attended_Session_7__c, Attended_Session_8__c, Attended_Session_9__c, Attended_Session_10__c, 
            Attended_Session_11__c, Attended_Session_12__c, Attended_Session_13__c, Attended_Session_14__c, Attended_Session_15__c, Attended_Session_16__c,
            Attended_Awareness__c, Attended_Orientation__c, Attended_Sustainment__c, ExitDate__c, ExitType__c
            from Registration__c where Digital_Shared_Copy__c = true 
                                             and Source_Registration_ID_Digital__c != null]);
    }

    global void execute(Database.BatchableContext context, List<Registration__c> scope) {
        List<Registration__c> regs = [Select Id, Confirm_Share_with_Franchisee__c, Responsible_Franchise__c, Session_1_Award__c, Session_2_Award__c, Session_3_Award__c, 
                                      Session_4_Award__c,
            Session_5_Award__c, Session_6_Award__c, Session_7_Award__c, Session_8_Award__c, Session_9_Award__c, Session_10_Award__c,
            Session_11_Award__c, Session_12_Award__c, Session_13_Award__c, Session_14_Award__c, Session_15_Award__c, Session_16_Award__c,
            Awareness_Award__c, Orientation_Award__c, Sustainment_Award__c , Session_1_Date__c, Session_2_Date__c, Session_3_Date__c, 
            Session_4_Date__c, Session_5_Date__c, Session_6_Date__c, Session_7_Date__c, Session_8_Date__c, Session_9_Date__c,
            Session_10_Date__c, Session_11_Date__c, Session_12_Date__c, Session_13_Date__c, Session_14_Date__c, Session_15_Date__c, 
            Session_16_Date__c, Awareness_Date__c, Sustainment_Date__c, Orientation_Date__c 
            , Attended_Session_1__c, Attended_Session_2__c, Attended_Session_3__c, Attended_Session_4__c, Attended_Session_5__c, Attended_Session_6__c,
            Attended_Session_7__c, Attended_Session_8__c, Attended_Session_9__c, Attended_Session_10__c, 
            Attended_Session_11__c, Attended_Session_12__c, Attended_Session_13__c, Attended_Session_14__c, Attended_Session_15__c, Attended_Session_16__c,
            Attended_Awareness__c, Attended_Orientation__c, Attended_Sustainment__c, ExitDate__c, ExitType__c from Registration__c where Confirm_Share_with_Franchisee__c = true 
                                      and Responsible_Franchise__c != null /*and Id = 'a0v3J0000001VdTQAU' */];
        List<Registration__c> rtlist = new List<Registration__c>();
        
        for (Registration__c digitalReg : scope) {
                        for (Registration__c reg : regs) {
                
                        if (reg.Id == digitalReg.Source_Registration_ID_Digital__c) {
                            Registration__c rt = new Registration__c();
                            rt.Id = digitalReg.Id;
                            
                            rt.Session_1_Award__c = reg.Session_1_Award__c;
                            rt.Session_2_Award__c = reg.Session_2_Award__c;
                             rt.Session_3_Award__c = reg.Session_3_Award__c;
                             rt.Session_4_Award__c = reg.Session_4_Award__c;
                             rt.Session_5_Award__c = reg.Session_5_Award__c;
                             rt.Session_6_Award__c = reg.Session_6_Award__c;
                             rt.Session_7_Award__c = reg.Session_7_Award__c;
                             rt.Session_8_Award__c = reg.Session_8_Award__c;
                             rt.Session_9_Award__c = reg.Session_9_Award__c;
                             rt.Session_10_Award__c = reg.Session_10_Award__c;
                             rt.Session_11_Award__c = reg.Session_11_Award__c;
                             rt.Session_12_Award__c = reg.Session_12_Award__c;
                             rt.Session_13_Award__c = reg.Session_13_Award__c;
                             rt.Session_14_Award__c = reg.Session_14_Award__c;
                             rt.Session_15_Award__c = reg.Session_15_Award__c;
                             rt.Session_16_Award__c = reg.Session_16_Award__c;
                            rt.Awareness_Award__c = reg.Awareness_Award__c;
                            rt.Orientation_Award__c = reg.Orientation_Award__c;
                            rt.Sustainment_Award__c = reg.Sustainment_Award__c;
                            rt.Session_1_Date__c = reg.Session_1_Date__c;
                            rt.Session_2_Date__c = reg.Session_2_Date__c;
                            rt.Session_3_Date__c = reg.Session_3_Date__c;
                            rt.Session_4_Date__c = reg.Session_4_Date__c;
                            rt.Session_5_Date__c = reg.Session_5_Date__c;
                            rt.Session_6_Date__c = reg.Session_6_Date__c;
                            rt.Session_7_Date__c = reg.Session_7_Date__c;
                            rt.Session_8_Date__c = reg.Session_8_Date__c;
                            rt.Session_9_Date__c = reg.Session_9_Date__c;
                            rt.Session_10_Date__c = reg.Session_10_Date__c;
                            rt.Session_11_Date__c = reg.Session_11_Date__c;
                            rt.Session_12_Date__c = reg.Session_12_Date__c;
                            rt.Session_13_Date__c = reg.Session_13_Date__c;
                            rt.Session_14_Date__c = reg.Session_14_Date__c;
                            rt.Session_15_Date__c = reg.Session_15_Date__c;
                            rt.Session_16_Date__c = reg.Session_16_Date__c;
                           // rt.Awareness_Date__c = reg.Awareness_Date__c;
                            rt.Sustainment_Date__c = reg.Sustainment_Date__c;
                            rt.Orientation_Date__c = reg.Orientation_Date__c;
                            rt.Attended_Session_1__c = reg.Attended_Session_1__c;
                            rt.Attended_Session_2__c = reg.Attended_Session_2__c;
                            rt.Attended_Session_3__c = reg.Attended_Session_3__c;
                            rt.Attended_Session_4__c = reg.Attended_Session_4__c;
                            rt.Attended_Session_5__c = reg.Attended_Session_5__c;
                            rt.Attended_Session_6__c = reg.Attended_Session_6__c;
                            rt.Attended_Session_7__c = reg.Attended_Session_7__c;
                            rt.Attended_Session_8__c = reg.Attended_Session_8__c;
                            rt.Attended_Session_9__c = reg.Attended_Session_9__c;
                            rt.Attended_Session_10__c = reg.Attended_Session_10__c;
                            rt.Attended_Session_11__c = reg.Attended_Session_11__c;
                            rt.Attended_Session_12__c = reg.Attended_Session_12__c;
                            rt.Attended_Session_13__c = reg.Attended_Session_13__c;
                            rt.Attended_Session_14__c = reg.Attended_Session_14__c;
                            rt.Attended_Session_15__c = reg.Attended_Session_15__c;
                            rt.Attended_Session_16__c = reg.Attended_Session_16__c;
                            rt.Attended_Awareness__c = reg.Attended_Awareness__c;
                            rt.Attended_Orientation__c = reg.Attended_Orientation__c;
                            rt.Attended_Sustainment__c = reg.Attended_Sustainment__c;
                            rt.ExitDate__c = reg.ExitDate__c;
                            rt.ExitType__c = reg.ExitType__c;
                            
                            
                            rtlist.add(rt);
                        }
                           // Database.update(rtlist);
          		}
        }

        if (!rtlist.isEmpty()) {
               Database.update(rtlist);

        }
    }

    global void finish(Database.BatchableContext context) {
        // Optional: Add any post-processing logic if needed
    }
}