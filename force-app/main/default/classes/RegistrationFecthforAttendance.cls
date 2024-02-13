public class RegistrationFecthforAttendance {
    @AuraEnabled(cacheable=true)
    public static String getRegistrationsByProgramId(String programId) {
        system.debug('programId--' +programId);
        
    return programId;
    }
    @AuraEnabled
    public static List<RegWrapper> fetchRegistrationRecs(String programId){
        system.debug('programId--' +programId);
        List<RegWrapper> options = new List<RegWrapper>();
        List<Registration__c> gradRegs2UpdateList = new List<Registration__c>();
        //String prgId = RegistrationFecthforAttendance.updateRegistrationGraduate(programId);
        List<Registration__c> regs = [SELECT Id, Name,ContactName__r.name,ProgramCode__c,ExitType__c,ProgramCode__r.Program_Graduation_Start_Date_Time__c,TotalPayments__c,
                                      Collected__c,ProgramCode__r.MinimumSessions__c ,Completed_Sessions_Count__c 
                                      FROM Registration__c WHERE ProgramCode__c = :programId AND ExitType__c=null  ];
        
        for(Registration__c rg: regs){
       
                if(rg.Completed_Sessions_Count__c>= rg.ProgramCode__r.MinimumSessions__c ){
                    rg.exitType__c = 'Graduate';
                    rg.ExitDate__c = rg.ProgramCode__r.Program_Graduation_Start_Date_Time__c.date();
                    gradRegs2UpdateList.add(rg);
                }
        }
        if(gradRegs2UpdateList.size()>0){
            system.debug('gradRegs2UpdateList - '+gradRegs2UpdateList);
            Database.SaveResult[] results = Database.update(gradRegs2UpdateList, false);
            for (Database.SaveResult result : results) {
                if (result.isSuccess()) {
                        System.debug('The Registration is updated. ' );
                        Program__c p = new Program__c();
                        p.Status__c= 'Graduated';
                        p.Id = programId;
                        system.debug(p);
                        update p;
                    }else{
                        for(Database.Error err : result.getErrors()) {
                                System.debug('The following error has occurred while updte.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Registration fields that affected this error: ' + err.getFields());
                            }
                        }
            }
        }
        List<Registration__c> regs2Update = [SELECT Id, Name,ContactName__r.name,ProgramCode__c,ExitType__c,Collected__c,TotalPayments__c,
        								ProgramCode__r.MinimumSessions__c ,Completed_Sessions_Count__c,No_Of_Payments__c,ProgramCode__r.Fee_payments_count__c
                                      FROM Registration__c WHERE ProgramCode__c = :programId AND ExitType__c=null  ];
        system.debug(regs2Update);
            for (Registration__c rg : regs2Update) {
                options.add(new RegWrapper(rg.Name, rg.ProgramCode__c,rg.id,rg.ContactName__r.Name,rg.No_Of_Payments__c,rg.TotalPayments__c));
            }
    system.debug(options);
    return options;
    }
    
    public static String updateRegistrationGraduate(String programId){
        List<Registration__c> gradRegs2UpdateList = new List<Registration__c>();
        List<Registration__c> regs = [SELECT Id, Name,ContactName__r.name,ProgramCode__c,ExitType__c,
        								ProgramCode__r.MinimumSessions__c ,Completed_Sessions_Count__c 
                                      FROM Registration__c WHERE ProgramCode__c = :programId AND ExitType__c=null  ];
       
        for(Registration__c rg: regs){
       
                if(rg.Completed_Sessions_Count__c>= rg.ProgramCode__r.MinimumSessions__c ){
                    rg.exitType__c = 'Graduate';
                    gradRegs2UpdateList.add(rg);
                }
        }
        if(gradRegs2UpdateList.size()>0){
            system.debug('gradRegs2UpdateList - '+gradRegs2UpdateList);
            Database.SaveResult[] results = Database.update(gradRegs2UpdateList, false);
            for (Database.SaveResult result : results) {
                if (!result.isSuccess()) {
                    Program__c p = new Program__c();
                    p.Status__c= 'Graduated';
                    p.Id = programId;
                    system.debug(p);
                    update p;
                    
                        System.debug('The Registration is updated. ' );
                    }else{
                        for(Database.Error err : result.getErrors()) {
                                System.debug('The following error has occurred while updte.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Registration fields that affected this error: ' + err.getFields());
                            }
                        }
            }
        }
        return programId;
    }
    @AuraEnabled
    public static boolean handleProduct(String registrationId, string prgmID){
        Registration__c reg = [select id,BalanceDue__c,programcode__c,ProgramCode__r.Product__c,ProgramCode__r.TotalSessions__c,ProgramCode__r.Product_Type__c from Registration__c where id=:registrationId limit 1];
        Program__c prg = [select id,Product__c,Product_Type__c,TotalSessions__c, Name from Program__c where id =: prgmID limit 1 ];
        AggregateResult[] attendances = [select Count(id)cnt from Attendance__c where Registration__c=:registrationId  group by Registration__c ];
        system.debug(reg.ProgramCode__r.Product__c);
        system.debug(prg.Product__c);
                    if(((reg.ProgramCode__r.Product__c == prg.Product__c )|| ((prg.Product_Type__c=='Tailored') && (prg.TotalSessions__c==reg.ProgramCode__r.TotalSessions__c)) || (attendances.size()>0))){
                        system.debug(prg.Product_Type__c);
                        system.debug(prg.TotalSessions__c);
                        system.debug(reg.ProgramCode__r.TotalSessions__c);
                        return true;
                    }else{
                        return false;
                    }
        
    }
    
    @AuraEnabled
    public static boolean handleProgramifSame(String registrationId,string programId, string prgmID){
        Registration__c reg = [select id,BalanceDue__c,programcode__c,Collected__c,ProgramCode__r.Product__c,ProgramCode__r.TotalSessions__c,ProgramCode__r.Product_Type__c from Registration__c where id=:registrationId limit 1];
        Program__c prg = [select id,Product__c,Product_Type__c,TotalSessions__c, Name from Program__c where id =: prgmID limit 1 ];
        system.debug(reg.ProgramCode__r.Product__c);
        system.debug(prg.Product__c);
                    if(programId == prgmID ){
                        system.debug(prg.Product_Type__c);
                        system.debug(prg.TotalSessions__c);
                        system.debug(reg.ProgramCode__r.TotalSessions__c);
                        return true;
                    }else{
                        return false;
                    }
        
    }
    
    @AuraEnabled
    public static List<Registration__c> getRefund(List<Id> registrationIds){
        List<Registration__c> regs = [select id,BalanceDue__c,programcode__c,TotalPayments__c,AccountName__c,Collected__c,
                               ContactName__c,Total__c,BaseRegistrationFee__c,ProgramCode__r.Product__c from Registration__c where id IN :registrationIds];
        System.debug(regs);
        return regs;
    }
    @AuraEnabled
    @future
    public static void handleSave(String wrapParams, string prgmID){
          Boolean isExecuting = false;
        List<Registration__c> regs = new List<Registration__c>();
        List<Fee_Payment__c> feepayments2Insert = new List<Fee_Payment__c>();
        List<Fee_Payment__c> feepayments2Update = new List<Fee_Payment__c>();
        List<Attendance__c> atnd2Insert = new List<Attendance__c>();
        if(wrapParams!=null){
            if(!isExecuting){
                isExecuting = true;
            List<createAttendancenPayments> wrapList = (List<createAttendancenPayments>) JSON.deserialize(wrapParams, List<createAttendancenPayments>.class);
            for(createAttendancenPayments wrap :wrapList){
                list<Attendance__c> attRecs = [select id,AttendedPartA__c,AttendedPartB__c,AwardPartA__c,AwardPartB__c,FullAttendance__c,
                                               Name,Program__c ,Registration__c,Session__c,session__r.SessionNumber__c from Attendance__c where Registration__c=:wrap.registrationId];
                System.debug('1.Number of Queries(attRecs) used in this apex code so far: ' + Limits.getQueries());
                if(wrap.exitType == 'Transfer'){
                    system.debug('transfer  '+ wrap.exitType);
                    Registration__c reg = [select id,BalanceDue__c,programcode__c,TotalPayments__c,Collected__c,AccountName__c,ContactName__c,Total__c,BaseRegistrationFee__c,ProgramCode__r.Product__c from Registration__c where id=:wrap.registrationId limit 1];
       				reg.ExitDate__c =system.today();
                    reg.ExitType__c = 'Transfer';
                    update reg;
                     Registration__c rg = new Registration__c();
                    rg.programcode__c = wrap.programCode;
                    rg.AccountName__c = reg.AccountName__c;
                   
                    rg.RegistrationDate__c = system.today();
                    rg.BaseRegistrationFee__c = reg.BaseRegistrationFee__c;
                    //rg.Tax__c = reg.Tax__c;
                    rg.ContactName__c = reg.ContactName__c;
                    insert rg;
                    if(wrap.atttendance=='Yes'){
                        for(Attendance__c atd :attRecs){
                           // session__c sess = [select id,SessionNumber__c from session__c where SessionNumber__c =:atd.session__r.SessionNumber__c AND Program__c =:wrap.programCode limit 1];
                           System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
                            Attendance__c atnd = new Attendance__c();
                            if(atd.AttendedPartA__c =='Yes')
                            	atnd.AttendedPartA__c = 'Yes (Transfer)';
                            else if(atd.AttendedPartA__c == 'No')
                                atnd.AttendedPartA__c = 'No (Transfer)';
                            else if(atd.AttendedPartA__c == 'Makeup')
                                atnd.AttendedPartA__c = 'Makeup (Transfer)';
                            if(atd.AttendedPartB__c =='Yes')
                            	atnd.AttendedPartB__c = 'Yes (Transfer)';
                            else if(atd.AttendedPartB__c == 'No')
                                atnd.AttendedPartB__c = 'No (Transfer)';
                            else if(atd.AttendedPartB__c == 'Makeup')
                                atnd.AttendedPartB__c = 'Makeup (Transfer)';
                              
                            atnd.AwardPartA__c = atd.AwardPartA__c;
                            atnd.AwardPartB__c = atd.AwardPartB__c;
                            atnd.Program__c = wrap.programCode;
                            atnd.Registration__c = rg.id;
                            atnd.Name = atd.Name;
                            //atnd.Session__c = sess.Id;
                            atnd2Insert.add(atnd);
                            
                        }
                    
                        if(atnd2Insert.size()>0) {
                            system.debug('Attendance to create '+atnd2Insert);
                            Database.SaveResult[] results = Database.insert(atnd2Insert, false);
                            for (Database.SaveResult result : results) {
                                if (result.isSuccess()) {
                                    
                                    System.debug('The Attendance Created');
                                }else{
                                    for(Database.Error err : result.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('Attendance fields that affected this error: ' + err.getFields());
                                    }
                                    
                                }
                            }
                        }
                    }
                    if(wrap.noPayment =='Yes'){
                    Fee_Payment__c fp = new Fee_Payment__c();
                            fp.Participant_Registration__c = reg.Id;
                            fp.Payment_Type__c = 'Credit';
                            fp.Payment_Date__c = system.today();
                            fp.Payment_Amount__c = reg.BalanceDue__c;
                            fp.Program_Code__c=reg.ProgramCode__c;
                        feepayments2Insert.add(fp);
                        }
                    if(wrap.transPay =='Yes'){
                        Fee_Payment__c fp = new Fee_Payment__c();
                            fp.Participant_Registration__c = reg.Id;
                            fp.Payment_Type__c = 'Credit';
                            fp.Payment_Date__c = system.today();
                            fp.Payment_Amount__c = reg.Total__c;
                            fp.Program_Code__c=reg.ProgramCode__c;
                         
                        feepayments2Insert.add(fp);
                        List<Fee_Payment__c> fps = [select id,Program_Code__c,Participant_Registration__c from Fee_Payment__c where Participant_Registration__c = :reg.Id];
                        for(Fee_Payment__c fpmnt :fps){
                            Fee_Payment__c fpmt = new Fee_Payment__c();
                            fpmt.Participant_Registration__c= rg.id;
                            fpmt.Program_Code__c = wrap.programCode;
                            fpmt.Id = fpmnt.Id;
                            feepayments2Update.add(fpmt);
                        }
                        
                    }
                    
                       if(feepayments2Insert.size()>0) {
                            system.debug('feepayments2Insert - '+feepayments2Insert);
                            Database.UpsertResult[] results = Database.upsert(feepayments2Insert, false);
                            for (Database.UpsertResult result : results) {
                                if (result.isSuccess()) {
                                    
                                    System.debug('The Fee Payment Created');
                                }else{
                                    for(Database.Error err : result.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('Fee Payment fields that affected this error: ' + err.getFields());
                                    }
                                    
                                }
                            }
                        }
                    if(feepayments2Update.size()>0) {
                            system.debug('feepayments2Update - '+feepayments2Update);
                            Database.SaveResult[] results = Database.Update(feepayments2Update, false);
                            for (Database.SaveResult result : results) {
                                if (result.isSuccess()) {
                                    
                                    System.debug('The Fee Payment Created');
                                }else{
                                    for(Database.Error err : result.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('Fee Payment fields that affected this error: ' + err.getFields());
                                    }
                                    
                                }
                            }
                        }
                    
                }else if(wrap.exitType == 'Drop' || wrap.exitType == 'Cancel'){
                    Registration__c rg = new Registration__c();
                    rg.ExitDate__c = system.today();
                        rg.id= wrap.registrationId;
                    rg.ExitType__c = wrap.exitType;
                    regs.add(rg);
                    update rg;
                    Registration__c reg = [select id,BalanceDue__c,Collected__c,AccountName__c,ContactName__c,Total__c,No_Of_Payments__c,TotalPayments__c,programcode__c from Registration__c where id=:rg.id limit 1];
                    if(wrap.noPayment =='Yes'){
                        if(reg.No_Of_Payments__c==0){
                    Fee_Payment__c fp = new Fee_Payment__c();
                            fp.Participant_Registration__c = wrap.registrationId;
                            fp.Payment_Type__c = 'Credit';
                            fp.Payment_Date__c = system.today();
                            fp.Payment_Amount__c = reg.BalanceDue__c;
                            fp.Program_Code__c=reg.ProgramCode__c;
                            fp.Account__c = reg.AccountName__c;
                        	fp.Contact_Lookup__c = reg.ContactName__c;
                        feepayments2Insert.add(fp);
                        }
                    }
                        
                    
                    if(wrap.refPay =='Yes'){
                        Fee_Payment__c fp = new Fee_Payment__c();
                            fp.Participant_Registration__c = rg.Id;
                            fp.Payment_Type__c = 'Credit';
                            fp.Payment_Date__c = system.today();
                        	fp.Account__c = reg.AccountName__c;
                        	fp.Contact_Lookup__c = reg.ContactName__c;
                            //fp.Payment_Amount__c = reg.Total__c;
                        if(wrap.refAmountVal == null){
                            fp.Payment_Amount__c = reg.Total__c;
                        }else{
                            fp.Payment_Amount__c = reg.BalanceDue__c + wrap.refAmountVal;
                        }
                            fp.Program_Code__c=reg.ProgramCode__c;
                         Fee_Payment__c fp1 = new Fee_Payment__c();
                            fp1.Participant_Registration__c = reg.Id;
                            fp1.Payment_Type__c = 'Refund';
                            fp1.Payment_Date__c = system.today();
                        	fp1.Account__c = reg.AccountName__c;
                        	fp1.Contact_Lookup__c = reg.ContactName__c;
                        if(wrap.refAmountVal == null){
                            fp1.Payment_Amount__c = reg.Collected__c;
                        }else{
                            fp1.Payment_Amount__c = wrap.refAmountVal;
                        }
                            
                            
                            fp1.Program_Code__c=reg.ProgramCode__c;
                        feepayments2Insert.add(fp1);
                        feepayments2Insert.add(fp);
                        //feepayments2Insert.add(fp);
                    }
                    
                    if(feepayments2Insert.size()>0) {
                            system.debug('feepayments - '+feepayments2Insert);
                            Database.upsertResult[] results = Database.upsert(feepayments2Insert, false);
                            for (Database.upsertResult result : results) {
                                if (result.isSuccess()) {
                                    
                                    System.debug('The Fee Payment Created');
                                }else{
                                    for(Database.Error err : result.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('Fee Payment fields that affected this error: ' + err.getFields());
                                    }
                                    
                                }
                            }
                        }
                    
                }
                
            }
        }
        }
    }
    public class RegWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String programCode;
        @AuraEnabled public String Id;
        @AuraEnabled public String contactName;
        @AuraEnabled public Decimal feePaymentCount;
        @AuraEnabled public Decimal totalPayment;
        
        public RegWrapper(String name, String programCode, String Id, String contactName ,Decimal feePaymentCount, Decimal totalPayment) {
            this.name = name;
            this.programCode = programCode;
            this.Id = Id;
            this.contactName = contactName;
            this.feePaymentCount = feePaymentCount;
            this.totalPayment = totalPayment;
        }
    }
    public class createAttendancenPayments {
        @AuraEnabled public String prgmID{get;set;}
        @AuraEnabled public String registrationId{get;set;}
        @AuraEnabled public String exitType{get;set;}
        @AuraEnabled public String atttendance{get;set;}
        @AuraEnabled public String noPayment{get;set;}
        @AuraEnabled public Decimal refAmountVal{get;set;}
        
        @AuraEnabled public String transPay{get;set;}
        @AuraEnabled public String refPay{get;set;}
        @AuraEnabled public String programCode{get;set;}
        
        @AuraEnabled public String contactName{get;set;}
    }
}