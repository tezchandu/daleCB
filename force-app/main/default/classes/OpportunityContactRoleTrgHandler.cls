//As opportunity contact roles come; we want to count them and put the number on the opp.
public class OpportunityContactRoleTrgHandler {

    //called from after insert, after update and after delete
    //after delete sends in the old list; others send in the new list
    public static void setOppCounts(List<OpportunityContactRole> ocrList) {
        
        String PRIMARY_STR = 'IsPrimary';
        String OTHER_STR = 'NotPrimary';
        
        //for each opp contact role that comes through - recalc the counts
        //we want the number of primary contact roles per opp, and number of total.
        //of_Contact_Roles__c, of_Primary_Contact_Roles__c 
        Set<Id> oppIds_Pre = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> oppsToReset = new Set<Id>();
        //Format of the Opp Map will be... 
        // OppId - 'IsPrimary', 2
        // OppId - 'NotPrimary', 2
        // Each opp will have one matching map, and that map will have an "IsPrimary" and "NotPrimary" value
        Map<Id, Map<String, Integer>> oppMap = new Map<Id, Map<String, Integer>>();
        for(OpportunityContactRole ocr : ocrList) {
            oppIds_Pre.add(ocr.OpportunityId);
            //ensure every opp is in the map, so even if there are NO OCRs - we still set the counts
            //oppMap.put(ocr.OpportunityId, new Map<String, Integer>());
        }
        
        for(Opportunity opp : [SELECT Id, IsClosed FROM Opportunity WHERE Id IN :oppIds_Pre AND IsClosed = false]) {
            oppIds.add(opp.Id);
            oppMap.put(opp.Id, new Map<String, Integer>());
        }
        
        //for each oppId - query for total #
        AggregateResult[] groupedResults  = [SELECT COUNT(Id) cnt, IsPrimary, OpportunityId FROM OpportunityContactRole
				WHERE OpportunityId IN :oppIds
                //WHERE OpportunityId IN ('006f000000MJvnbAAD', '006f000000MvncTAAR')
				GROUP BY OpportunityId, IsPrimary];

      	for (AggregateResult ar : groupedResults)  {
            
            Id oppId = (Id) ar.get('OpportunityId');
            Integer cnt = (Integer) ar.get('cnt');
            Boolean isP = (Boolean) ar.get('IsPrimary');
            
            Map<String, Integer> tmpMap = oppMap.get(oppId);
            //tmpMap will never be null, because we instantiated it above
            //if(tmpMap == null) {
            //    tmpMap = new Map<String, Integer>();
            //}
            if(isP) {
                tmpMap.put(PRIMARY_STR, cnt);
            } else {
                tmpMap.put(OTHER_STR, cnt);
            }
            oppMap.put(oppId, tmpMap);
		}
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(Id oppId : oppMap.keySet()) {
            Integer primaryCnt = 0;
            Integer otherCnt = 0;
            Opportunity tmpOpp = new Opportunity(Id = oppId);
            
            Map<String, Integer> tmpMap = oppMap.get(oppId);
            if(tmpMap != null) {
                primaryCnt = tmpMap.get(PRIMARY_STR);
                if(primaryCnt == null) {
                    primaryCnt = 0;
                }
                
                otherCnt = tmpMap.get(OTHER_STR);
                if(otherCnt == null) {
                    otherCnt = 0;
                }
                //but actually - other count is ALL OTHER - so add primary to it
                otherCnt = primaryCnt + otherCnt;
            }
            tmpOpp.of_Contact_Roles__c = otherCnt;
            tmpOpp.of_Primary_Contact_Roles__c = primaryCnt;
            
            //if there is no primary contact, and only ONE "other" contact
            //then we want that single contact to become the primary
            if(primaryCnt == 0 && otherCnt == 1) {
                oppsToReset.add(oppId);
            }
            oppsToUpdate.add(tmpOpp);
        }
        
        if(oppsToUpdate.size() > 0) {
            update oppsToUpdate;
        }
        
        if(oppsToReset.size() > 0) {
            setOppPrimary(oppsToReset);
        }
	
    }
    
    //@future
    public static void setOppPrimary(Set<Id> oppSet) {
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        for(OpportunityContactRole ocr : [SELECT Id, IsPrimary FROM OpportunityContactRole WHERE OpportunityId IN :oppSet 
                                          AND IsPrimary = false
                                          //If the opportunity is closed, we won't continue...
                                         AND Opportunity.IsClosed = false]) {
            ocr.IsPrimary = true;
            ocrList.add(ocr);
        }
        if(ocrList.size() > 0) {
            update ocrList;
        }
    }
    
}