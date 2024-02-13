global class FranchiseReportBatch implements Database.Batchable<sObject>{

    global final String Query;
    global OrgWideEmailAddress OrgWideEmail = [SELECT id FROM OrgWideEmailAddress WHERE Address = 'michael.pryce@dalecarnegie.com' LIMIT 1];
    global String accountRT = Schema.SObjectType.Account.RecordTypeInfosByName.get('DFG Account').RecordTypeId; // Added as a part of Org Merge
    global String oppRT = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('DFG Opportunity').RecordTypeId; // Added as a part of Org merge
   
    global FranchiseReportBatch(){
        Query = 'SELECT id,Name,Franchise_Code__c,Franchisee_Report_Email__c FROM Account WHERE Type =\'Franchisee\' AND RecordTypeId =:accountRT AND Franchisee_Report_Email__c != \'\'';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<String> aFranchiseCodeList = new List<String>();
        for (sObject a : scope){
            aFranchiseCodeList.add(String.ValueOf(a.get('Franchise_Code__c')));
        }

        // Build a map of Opportunities for the Franchise Adcounts that were passed via scope
        List<Opportunity> oList = getFranchiseOpportunities(aFranchiseCodeList);
        Map<Id,List<Opportunity>> FraOppMap = new Map<Id,List<Opportunity>>();
        for (Opportunity o : oList){
            if (!FraOppMap.containsKey(o.Franchise__r.id)){
                List<Opportunity> moList = new List<Opportunity>();
                moList.add(o);
                FraOppMap.put(o.Franchise__r.id,moList);    
            } else {
                FraOppMap.get(o.Franchise__r.id).add(o);
            }
        }

        List<Messaging.SingleEmailMessage> mList = new List<Messaging.SingleEmailMessage>();
        for (sObject f : scope){
            if (FraOppMap.containsKey(f.id)){ // only proceed if opps where found for the given account
                Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage() ;

                if (null != OrgWideEmail) m.setOrgWideEmailAddressId(OrgWideEmail.id);

                Franchise_Report_Settings__c frs = Franchise_Report_Settings__c.getValues('Franchise Report Settings');
                if (null != frs && null != frs.Franchise_Report_Email__c) m.setBccAddresses(new List<String>{frs.Franchise_Report_Email__c});

                // Emails are only sent to franchises when debug mode is off or if custom setting is missing altogether
                if (null == frs || !frs.Debug_Mode__c) m.setToAddresses(new List<String>{String.ValueOf(f.get('Franchisee_Report_Email__c'))});
                
                String mSubject; String mBody;
                mSubject = f.get('Name') + ' Digital Opportunities'; 
                if (null != frs && frs.Debug_Mode__c) mSubject = 'Debug Mode: ' + mSubject;
                m.setSubject(mSubject); 

                mBody = '<HTML><BODY>\n';
                mBody += '<TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0">\n';
                mBody += '<TR BGCOLOR="#AAAAFF"><TH>Franchise Name</TH><TH>Opportunity Name</TH><TH>Close Date</TH><TH>Stage</TH><TH>Probability</TH><TH>Amount</TH><TH>Next Step</TH><TH>City</TH><TH>State</TH><TH>Sales Rep</TH></TR>\n';

                for (Opportunity o : FraOppMap.get(f.id)){
                    mBody += '<TR>\n';
                    mBody += '<TD>' + o.Franchise__r.Name + '</TD>\n';
                    mBody += '<TD>' + o.Name + '</TD>\n';
                    mBody += '<TD ALIGN="right">' + o.CloseDate.format() + '</TD>\n';
                    mBody += '<TD>' + o.StageName + '</TD>\n';
                    mBody += '<TD ALIGN="right">' + o.Probability + '%</TD>\n';
                    mBody += '<TD ALIGN="right">' + o.Amount + '</TD>\n';
                    mBody += '<TD>' + o.NextStep + '</TD>\n';
                    mBody += '<TD>' + o.Account.BillingCity + '</TD>\n';
                    mBody += '<TD>' + o.Account.BillingState + '</TD>\n';
                    mBody += '<TD>' + o.Owner.Name + '</TD>\n';
                    mBody += '</TR>\n';
                }
                mBody += '</TABLE>\n';
                mBody += '</BODY></HTML>';
                m.setHTMLBody(mBody);
                
                m.saveAsActivity = false;
                if (!oList.isEmpty()) mList.add(m);  // only send if it has opps
            }
        }

        Messaging.sendEmail(mList);


    }

   global void finish(Database.BatchableContext BC){
   
   }

   global List<Opportunity> getFranchiseOpportunities(List<String> aFranchiseCodeList){
        return [SELECT id,Name,CloseDate,StageName,Probability,Amount,NextStep,Franchise__c,Franchise__r.id,Franchise__r.Name,
                    Account.BillingCity,Account.BillingState,Owner.Name   
                    FROM Opportunity WHERE Franchise__r.Franchise_Code__c = :aFranchiseCodeList 
                    AND CloseDate > :Date.today().addMonths(-1) AND CloseDate < :Date.today().addMonths(18)
                    AND Probability >= 20
                    AND RecordTypeId =: oppRT
                    ORDER BY CloseDate];
   }

}