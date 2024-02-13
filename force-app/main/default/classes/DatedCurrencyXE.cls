public class DatedCurrencyXE {
    @future(callout=true)
    public static void getAccessToken(){
       
        String authorizationHeader = 'Bearer ZGFsZWNhcm5lZ2llJmFzc29jaWF0ZXMsaW5jLjQwNjI0MDM5OnBobjR1NmdiM3Z1N25iYW81M29kZ2NhZDE1' ;
            
            HttpRequest req1 = new HttpRequest();
            req1.setEndpoint('callout:XE_Currency_Data_API/');
            req1.setMethod('GET'); 
            req1.setTimeout(120000);             
           // req1.setHeader('Authorization', authorizationHeader);
            Http http1 = new Http();
            HTTPResponse res1 = http1.send(req1);
            System.debug('====res1==='+res1.getBody());
       		String jsonResponse = JSON.serialize(res1.getBody());
            String jsonResponse1 = res1.getBody();
         System.debug(jsonResponse);
        System.debug(jsonResponse1);
       		 insertDatedCurrencyExchange(jsonResponse1);
            System.debug(jsonResponse1);
      
    }
    public static void insertDatedCurrencyExchange(string jsonString){
        system.debug(jsonString);
        Map<String, Object> responseData = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
      	List<Object> results = (List<Object>)responseData.get('to'); 
        system.debug(results);
        system.debug(responseData);
        List<DatedConversionRate> dcrList = new List<DatedConversionRate>();    
                if(results.size() > 0){
                     for(Integer j=results.size();j>0;j--){  
                        System.debug('====jIndex====='+j);
                        Map<String, Object> attribute = (Map<String, Object>)results[j-1];
                         DatedConversionRate dcr = new DatedConversionRate();
                         dcr.IsoCode = String.Valueof(attribute.get('quotecurrency'));
                         dcr.ConversionRate = Decimal.valueOf(string.Valueof(attribute.get('mid')));
                         
                         dcr.StartDate = system.today();
                         dcrList.add(dcr);
               			 }
    			}
        system.debug(dcrList);
        DatedConversionRateCollection collection = new DatedConversionRateCollection();
         Map<String,CurrencyType> dcaCurriencies = new Map<String,CurrencyType>();
            List<CurrencyType> currTypeList = [select Id, IsoCode, ConversionRate, DecimalPlaces, IsActive, IsCorporate from CurrencyType where IsCorporate = false and isActive=true];
           for(CurrencyType cu : currTypeList){
                dcaCurriencies.put(cu.IsoCode,cu);
            }
        double randomText = Math.rint(Math.random() * 1000);
       system.debug(randomText);
            for(Integer j=results.size();j>0;j--){  
                	 Map<String, Object> attribute = (Map<String, Object>)results[j-1];
                if(dcaCurriencies.containsKey(String.Valueof(attribute.get('quotecurrency')))){
                    collection.addRecord('DatedConversionRate',  String.Valueof(attribute.get('quotecurrency')),'uniqueRefId'+String.Valueof(attribute.get('quotecurrency')), decimal.valueOf(String.Valueof(attribute.get('mid'))), Date.today());
                    //'uniqueRefId'+String.Valueof(attribute.get('quotecurrency')),
                }}
        
            if(collection != null){
                System.debug('Calls the callout');
                 
                updateCurrienciesData(collection);
                 
            }
       
    }
    Public Static void updateCurrienciesData(DatedConversionRateCollection updateList){
        System.debug('Inside Callout');
        system.debug('json - '+updateList);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(60000);
        req.setEndpoint(URL.getOrgDomainURL().toExternalForm() + '/services/data/v59.0/composite/tree/DatedConversionRate');
        req.setMethod('POST');
        req.setBody(JSON.serialize(updateList));
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        HttpResponse res = h.send(req);
        System.debug(res.getStatusCode());
        if(res.getStatusCode() != 201){
                    system.debug(res.getBody());
					//deleteAppointment();
                 }
    }
    
    
}