global class WebServiceMockImpl implements WebServiceMock {
    
    global String contactId;
    global Integer n;
    
    global WebServiceMockImpl(String contactId) {
        this.contactId = contactId;
    }    
    
    global WebServiceMockImpl(Integer leads) {
        this.n = leads;
    }
    
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS, 
        String responseName,
        String responseType) {
            
            System.debug('The requestName is: ' + requestName);
            
            if(requestName=='AddUpdateLead') {
                
                DCTLeadService.AddUpdateLeadResponse_element response_x = new DCTLeadService.AddUpdateLeadResponse_element();
                response_x.AddUpdateLeadResult = '<NewDataSet><ForeignKey><SalesForceID>' + this.contactId + '</SalesForceID><LeadKey>56123</LeadKey><ErrMsg></ErrMsg></ForeignKey></NewDataSet>';
                response.put('response_x', response_x); 
            } else if(requestName=='UpdateParticipant') {
                                
                DCTParticipantService.UpdateParticipantResponse_element response_x = new DCTParticipantService.UpdateParticipantResponse_element();
                response_x.UpdateParticipantResult = '<NewDataSet><ForeignKey><SalesForceID>' + this.contactId + '</SalesForceID><LeadKey>56123</LeadKey><ErrMsg></ErrMsg></ForeignKey></NewDataSet>';
                response.put('response_x', response_x); 
            }  else {
                System.debug('None of the conditions were met!!');
            }
            
        }
}