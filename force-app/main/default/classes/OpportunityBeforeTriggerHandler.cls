// 06.14.2019   Sophia Murphy (Demand Chain)
//              update to set UTM fields on Opportunity from Contact Source Detail
public with sharing class OpportunityBeforeTriggerHandler {
    
    public static void setCurrencyIsoCode (List<Opportunity> opps) {
        Set<Id> userIds = new Set<Id>();
        for (Opportunity opp : opps) {
            if (!opp.HasOpportunityLineItem) {
                userIds.add(opp.OwnerId);
            }
        }
        Map<Id, User> userMap = new Map<Id, User>([Select u.DefaultCurrencyIsoCode From User u Where u.Id IN :userIds]);
        for (Opportunity opp : opps) {
            if (!opp.HasOpportunityLineItem) {
                opp.CurrencyIsoCode = userMap.get(opp.OwnerId).DefaultCurrencyIsoCode ;
            }
        } 
    }

    /**
    * Called from ContactSourceDetail query - does similar logic to populateContactSourceDetailOnOpp;
    * populating the UTM info.
    */
    public static void populateContactSourceDetailOnOpp_FromCSD(List<Contact_Source_Detail__c> csdLists) {
        system.debug('DC: inside populateContactSourceDetailOnOpp_FromCSD');
        List<Opportunity> oppList = new List<Opportunity>();

        //Find all Contacts and Contact Roles related to these CSDs.
        Map<Id, Contact_Source_Detail__c> contactIdToCSD = new Map<Id, Contact_Source_Detail__c>();
        for(Contact_Source_Detail__c csd : csdLists) {
            Boolean doAdd = false;
            if(csd.UTM_Campaign__c != '') {
                doAdd = true;
            }
            if(csd.UTM_Content__c != '') {
                doAdd = true;
            }
            if(csd.UTM_Medium__c != '') {
                doAdd = true;
            }
            if(csd.UTM_Source__c != '') {
                doAdd = true;
            }
            if(csd.UTM_Term__c != '') {
                doAdd = true;
            }
            contactIdToCSD.put(csd.Contact__c, csd);
        }

        system.debug('DC: contactIdToCSD ' + contactIdToCSD);

        Map<Id, Id> oppIdToContactId = new Map<Id, Id>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for(OpportunityContactRole ocr : [SELECT Id, OpportunityId 
                                                , ContactId, CreatedDate
                                                , Opportunity.UTM_Campaign__c
                                                , Opportunity.UTM_Content__c
                                                , Opportunity.UTM_Medium__c
                                                , Opportunity.UTM_Source__c
                                                , Opportunity.UTM_Term__c
                                            FROM OpportunityContactRole
                                            WHERE ContactId IN :contactIdToCSD.keySet()
                                            ORDER BY IsPrimary DESC, CreatedDate]) {

            Id tmpId = oppIdToContactId.get(ocr.OpportunityId);
            if(tmpId == null) {
                oppIdToContactId.put(ocr.OpportunityId, ocr.ContactId);

                Opportunity tmpOpp = new Opportunity(Id = ocr.OpportunityId);
                tmpOpp.UTM_Campaign__c = ocr.Opportunity.UTM_Campaign__c;
                tmpOpp.UTM_Content__c = ocr.Opportunity.UTM_Content__c;
                tmpOpp.UTM_Medium__c = ocr.Opportunity.UTM_Medium__c;
                tmpOpp.UTM_Source__c = ocr.Opportunity.UTM_Source__c;
                tmpOpp.UTM_Term__c = ocr.Opportunity.UTM_Term__c;
                oppMap.put(ocr.OpportunityId, tmpOpp);
            }
        } 
        system.debug('DC: oppIdToContactId ' + oppIdToContactId);
        system.debug('DC: oppMap ' + oppMap);

        for(Id oppId : oppIdToContactId.keySet()) {
            Id contactId = oppIdToContactId.get(oppId);
            Contact_Source_Detail__c csd = contactIdToCSD.get(contactId);
            Opportunity opp = oppMap.get(oppId);

            Boolean doAdd = false;
            if(opp.UTM_Campaign__c == '' || opp.UTM_Campaign__c == null) {
                opp.UTM_Campaign__c = csd.UTM_Campaign__c;
                doAdd = true;
            }
            if(opp.UTM_Content__c == '' || opp.UTM_Content__c == null) {
                opp.UTM_Content__c = csd.UTM_Content__c;
                doAdd = true;
            }
            if(opp.UTM_Medium__c == '' || opp.UTM_Medium__c == null) {
                opp.UTM_Medium__c = csd.UTM_Medium__c;
                doAdd = true;
            }
            if(opp.UTM_Source__c == '' || opp.UTM_Source__c == null) {
                opp.UTM_Source__c = csd.UTM_Source__c;
                doAdd = true;
            }
            if(opp.UTM_Term__c == '' || opp.UTM_Term__c == null) {
                opp.UTM_Term__c = csd.UTM_Term__c;
                doAdd = true;
            }

            if(doAdd) {
                oppList.add(opp);
            }

        }

        if(oppList.size() > 0) {
            update oppList;
        }

    }

    /**
    * Method to populate ContactSourceDetail record from first OpportunityContactRole contact on Insert/Update
    * 
    * @param List<Opportunity> : List of Opp which are inserted or Update 
    * @Author : Usman Ali (Magnet 360)
    * @Date :   08/16/16
    * @Jira :   MSP-1072
    * @Updates:
    * @return  : NO return value  
    */

    public static void populateContactSourceDetailOnOpp(List<Opportunity> opps )
    {
        //List<Opportunity> oppsToProcess = new List<Opportunity>();
        Map<Id, Id> oppIdToContactRoleId = new Map<Id,Id>();
        //This will just store the FIRST CSD
        Map<Id, Contact_Source_Detail__c> contactIdToCSDetail = new Map<Id, Contact_Source_Detail__c>();
        //This will store ALL CSDs under a contact
        Map<Id, List<Contact_Source_Detail__c>> contactIdToCSList = new Map<Id, List<Contact_Source_Detail__c>>();

        // Get Opps related OpportunityContactRoles records
        for( OpportunityContactRole ocr : [ SELECT Id, OpportunityId, ContactId, IsPrimary 
                                            FROM OpportunityContactRole WHERE OpportunityId IN :opps  
                                            ORDER BY IsPrimary DESC, CreatedDate ])
        {
            if( !oppIdToContactRoleId.containsKey(ocr.OpportunityId )) oppIdToContactRoleId.put(ocr.OpportunityId, ocr.ContactId);
        }
        System.debug('UAC: oppIdToContactRoleId ' + oppIdToContactRoleId );
        if(oppIdToContactRoleId.size() == 0 ) return ; 

        // Get OpportunityContactRoles related ContactSourceDetail records 
        for( Contact_Source_Detail__c csd : [   SELECT Id, Contact__c, CreatedDate
                                                , UTM_Campaign__c
                                                , UTM_Content__c
                                                , UTM_Medium__c
                                                , UTM_Source__c
                                                , UTM_Term__c
                                                FROM Contact_Source_Detail__c 
                                                WHERE Contact__c IN :oppIdToContactRoleId.values()
                                                ORDER BY LastModifiedDate DESC ])
        {
            //Add to the single CSD map
            if( !contactIdToCSDetail.containsKey(csd.Contact__c)) contactIdToCSDetail.put(csd.Contact__c, csd );
            //Add to the list CSD map
            List<Contact_Source_Detail__c> tmpList = contactIdToCSList.get(csd.Contact__c);
            if(tmpList == null) {
                tmpList = new List<Contact_Source_Detail__c>();
            }
            tmpList.add(csd);
            contactIdToCSList.put(csd.Contact__c, tmpList);
        }
        System.debug('UAC: contactIdToCSDetail ' + contactIdToCSDetail );

        // Iterate over opps and populate ContactSourceDetail 
        for( Opportunity opp : opps )
        {   
            // If contactSource detail found then populate it
            if( oppIdToContactRoleId.containsKey(opp.Id) && contactIdToCSDetail.containsKey(oppIdToContactRoleId.get(opp.Id)) ) 
            {
                Contact_Source_Detail__c csd = contactIdToCSDetail.get(oppIdToContactRoleId.get(opp.Id));
                opp.First_Contact_Source_Detail__c = csd.Id ;
                opp.Original_Touch_Date__c = csd.CreatedDate.date() ;

                List<Contact_Source_Detail__c> csdList = contactIdToCSList.get(oppIdToContactRoleId.get(opp.Id));
                for(Contact_Source_Detail__c csdItem : csdList) {
                    //06.14.2019 - Added UTM info.
                    if(opp.UTM_Campaign__c == '' || opp.UTM_Campaign__c == null) {
                        opp.UTM_Campaign__c = csdItem.UTM_Campaign__c;
                    }
                    if(opp.UTM_Content__c == '' || opp.UTM_Content__c == null) {
                        opp.UTM_Content__c = csdItem.UTM_Content__c;
                    }
                    if(opp.UTM_Medium__c == '' || opp.UTM_Medium__c == null) {
                        opp.UTM_Medium__c = csdItem.UTM_Medium__c;
                    }
                    if(opp.UTM_Source__c == '' || opp.UTM_Source__c == null) {
                        opp.UTM_Source__c = csdItem.UTM_Source__c;
                    }
                    if(opp.UTM_Term__c == '' || opp.UTM_Term__c == null) {
                        opp.UTM_Term__c = csdItem.UTM_Term__c;
                    }
               } //END: for(Contact_Source_Detail__c csdItem : csdList)
            }
        }
    }
}