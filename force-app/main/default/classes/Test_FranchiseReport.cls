@isTest
private class Test_FranchiseReport {
    public static String accountRT = Schema.SObjectType.Account.RecordTypeInfosByName.get('DFG Account').RecordTypeId; // Added as a part of Org Merge
    public static String leadRT = Schema.SObjectType.Lead.RecordTypeInfosByName.get('DFG Lead').RecordTypeId; // Added as a part of Org merge
    public static String oppRT = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('DFG Opportunity').RecordTypeId; // Added as a part of Org merge
    
    private static Map<String,String> FranchiseCodeToPostalCodeMap = new Map<String,String>{
                                                                            '903500' => '35146',
                                                                            '913071' => '03031',
                                                                            '902760' => '85000',
                                                                            '908800' => '37501',
                                                                            '129250' => '94203'
                                                                            }; 

    static testMethod void BuildFranchisesWithOpportunities() {
        // Create 5 Franchises & associate 3 opportunities to each one
        // Only 4 of 5 franchises will qualify for franchise report becsuse they will have a Franchisee_Report_Email__c defined  
        // Only 2 of those 3 opps will qualify for the franchise report because of their closedates

        List<Account> fList = new List<Account>(); 
        for (String fc : FranchiseCodeToPostalCodeMap.keySet()){
            Account f = new Account();
            f.Name = 'Test Franchise '+fc;
            f.Type = 'Franchisee';
            f.Franchise_Code__c = fc;
            f.recordTypeId = accountRT;
            if (f.Franchise_Code__c.left(1) == '9') f.Franchisee_Report_Email__c = 'test@dalecarnegie.com';  
            fList.add(f);
        }
        insert fList;

        List<Opportunity> oList = new List<Opportunity>(); 
        for (Account f : fList){
            Opportunity o1 = new Opportunity();
            o1.Name = 'TestOppOne';
            o1.Franchise__c = f.id;
            o1.CloseDate = Date.today().addDays(90);
            o1.stageName = 'Identified Need';
            o1.RecordTypeId = oppRT;
            oList.add(o1);
            
            Opportunity o2 = new Opportunity();
            o2.Name = 'TestOppTwo';
            o2.Franchise__c = f.id;
            o2.CloseDate = Date.today().addDays(14);
            o2.stageName = 'Negotiations';
            o2.RecordTypeId = oppRT;
            oList.add(o2);

            Opportunity o3 = new Opportunity();
            o3.Name = 'TestOppThree';
            o3.Franchise__c = f.id;
            o3.CloseDate = Date.today().addDays(-600);
            o3.stageName = 'Contracts Signed / Closed Won';
            o3.RecordTypeId = oppRT;
            oList.add(o3);
        }
        insert oList;
        
        List<Account> insertedFList = new List<Account>([Select id,Name FROM Account WHERE Franchise_Code__c = : FranchiseCodeToPostalCodeMap.keySet()]);
        System.Assert(insertedFList.size() == 5); // verify that 5 franchises were created
        List<Opportunity> insertedOList = new List<Opportunity>([Select id,Name FROM Opportunity WHERE Franchise__r.Franchise_Code__c = : FranchiseCodeToPostalCodeMap.keySet()]);
        System.Assert(insertedOList.size() == 15); // verify that 15 Opps were created
    }

    static testMethod void InvokeFranchiseReportBatch() {
        // Invoke Franchise Report & sanity check that:
        // only 4 franchises where included (because they were the ones with Franchisee_Report_Email__c defined)
        // and that only the 8 opps that had the appropriate close dates were returned

        Test_FranchiseReport.BuildFranchisesWithOpportunities();

        FranchiseReportBatch myBatch = new FranchiseReportBatch();
        ID bId = Database.executeBatch(myBatch,5);
         
        List<Account> fList = Database.Query(myBatch.Query);
        System.Assert(fList.size() == 4); // verify that only 4 franchises were included in the franchise report

        List<String> aFranchiseCodeList = new List<String>();
        for (Account f : fList){
            aFranchiseCodeList.add(f.Franchise_Code__c);
        }

        List<Opportunity> oList = myBatch.getFranchiseOpportunities(aFranchiseCodeList);
        System.Assert(oList.size() == 8); // verify that only 8 Opps were included in the franchise report
    }

    static testMethod void InvokeFranchiseReportSchedule() {
    }
}