global class ParticipantWebServiceMockImpl implements WebServiceMock {
	global String contactId;
	global ParticipantWebServiceMockImpl(String contactId) {
		this.contactId = contactId;
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

		DCTParticipantService.UpdateParticipantResponse_element response_x = new DCTParticipantService.UpdateParticipantResponse_element();
		response_x.UpdateParticipantResult = '<NewDataSet><ForeignKey><SalesForceID>' + this.contactId + '</SalesForceID><ContactKey>56123</ContactKey><ErrMsg></ErrMsg></ForeignKey></NewDataSet>';
        response.put('response_x', response_x); 
   }
}