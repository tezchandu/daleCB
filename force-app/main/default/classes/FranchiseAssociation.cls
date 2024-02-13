public with sharing class FranchiseAssociation {

    public static void AssociateToFranchise(sObject[] newSObjectList){
        // This method aims to associate a Lead or Opp to their corresponding franchise.  
        // It will do so by comparing the PostalCode in the lead/opp with a list of postal codes stored in the Postal_Code__c object 
        // if it finds a match, it will associate the appropriate franchise to the Lead/Opp. (Franchises are Accounts with Type "Franchisee")

        Set<sObject> sObjectsToProcess = new Set<sObject>();
        Set<String> PostalCodesSet = new Set<String>();
        String accountRT = Schema.SObjectType.Account.RecordTypeInfosByName.get('DFG Account').RecordTypeId; // Added as a part of Org Merge
        String leadRT = Schema.SObjectType.Lead.RecordTypeInfosByName.get('DFG Lead').RecordTypeId; // Added as a part of Org merge
        String oppRT = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('DFG Opportunity').RecordTypeId; // Added as a part of Org merge
        
        for (sObject sObj : newSObjectList){
            if(String.valueOf(sObj.get('RecordTypeId')) == accountRT || String.valueOf(sObj.get('RecordTypeId')) == leadRT || String.valueOf(sObj.get('RecordTypeId')) == oppRT){
            
                // Validation: only allow Lead/Oppss with valid PostalCodes & blank franchises
                if (null == sObj.get('Franchise__c')){
                    // The PostalCodes from the Lead/Opp will be user entered, so this method aims to normalize them
                    // as much as possible to help them better match up with the clean list of Postal Codes in the Postal_Code__c object
                    String normalizedPostalCode = getNormalizedPostalCode(sObj);
                    if (null != normalizedPostalCode){
                        // Build a Set of PostalCodes that passed validation to help us filter Postal_Code__c query later
                        PostalCodesSet.add(normalizedPostalCode);
                        // Build a Set of the passed objects that pass validation so that we can iterate through them later
                        sObjectsToProcess.add(sObj);
                    }           
                }
            }
        }   

        // Build a map of Postal_Code_c objects, filtered by the PostalCodes of the passed leads/opps that passed validation (using PostalCodesSet)
        // The map will be indexed by the PostalCode itself.  We will use this index later to associate Postal_Code__c to leads/opps
        Map<String,sObject> PostalCodesMap = new Map<String,sObject>();
        for (sObject pc : [SELECT Name,Franchise__c,Franchise__r.id FROM Postal_Code__c WHERE Name = :PostalCodesSet]){
            PostalCodesMap.put(String.valueOf(pc.get('Name')).toLowerCase(),pc); // making lower case to make search case insensitive
        }

        // Iterate should each passed lead/opp that passed validation so that we can try matching them with their corresponding Postal_Code__c object
        for (sObject sObj : sObjectsToProcess){
            String normalizedPostalCode = getNormalizedPostalCode(sObj);
            // Use the normalized postal code as a key into the PostalCodesMap (to see if there is a Postal_Code__c object that matches the Postal Code in the passsed Lead/Opp)
            sObject pc = PostalCodesMap.get(normalizedPostalCode);
            // pc can be null if the PostalCode has the right syntax, but there is no corresponding record for it in Postal_Code__c (say 00000)
            if (null != pc){
                // Associate the passed Lead/Opp to the Franchise in the Postal_Code__c record
                 sObj.put('Franchise__c',pc.get('Franchise__c'));
            }
        }        
    }

    public static string getNormalizedPostalCode(sObject sObj){

        String postalCode;
        if (sObj.getSObjectType() == Lead.getSObjectType()){
            postalCode = String.valueOf(sObj.get('PostalCode'));    
        } else if (sObj.getSObjectType() == Opportunity.getSObjectType()){
            postalCode = String.valueOf(sObj.get('Organization_Postal_Code__c'));   
        }

        if (null != postalCode){
            postalCode = postalCode.normalizeSpace();
            // US Postal Codes begin with 5 digits
            if (postalCode.length() >= 5 && postalCode.substring(0,5).isNumeric()){
                postalCode = postalCode.substring(0,5);
            // CA FSAs have a specific format (Alpha/Numeric/Alpha)
            } else if (postalCode.length() >= 3 && postalCode.substring(0,1).isAlpha() 
                        && postalCode.substring(1,2).isNumeric()
                        && postalCode.substring(2,3).isAlpha() ){
                postalCode = postalCode.substring(0,3).toLowerCase(); // converting to lower case to make search case insensitive  
            }
        }
        return postalCode;
    }
}