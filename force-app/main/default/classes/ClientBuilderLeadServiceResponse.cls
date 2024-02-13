/****************************************************************************** 
 * Class used to parse and hold the Client Builder web service response when
 * a Lead is created or updated
 *
 * @date 10/17/2013
 * @author Magnet 360
 * 
 * 11.02.2023	Sophia Murphy (Demand Chain)
 *				Removed email to myself
 */
public with sharing class 
ClientBuilderLeadServiceResponse 
{

    public Map<String, CBLeadResponse> response_map { get; set; }

/******************************************************************************
 * Constructor
 *
 * @param String a_xml_response : The xml response from the Client Builder
 *                                web service
 * 
 * EXPECTED XML FORMAT
 *  <NewDataSet>
 *	  <ForeignKey>
 *	    <SalesForceID>1</SaleForceID>
 *	    <LeadKey>56123</LeadKey>
 *	    <ErrMsg></ErrMsg>
 *	  </ForeignKey>
 *	  <ForeignKey>
 *	    <SalesForceID>2</SaleForceID>
 *	    <LeadKey>56124</LeadKey>
 *	    <ErrMsg></ErrMsg>   
 *	  </ForeignKey>
 *	  <ForeignKey>
 *	    <SalesForceID>3</SaleForceID>
 *	    <LeadKey>56125</LeadKey>
 *	    <ErrMsg></ErrMsg>
 *	  </ForeignKey>
 *	</NewDataSet>
 * 
 */
    public
    ClientBuilderLeadServiceResponse( String a_xml_response )
    {
    	System.debug( 'START: ClientBuilderLeadServiceResponse.constructor()' );
    	System.debug( 'Param: a_xml_response = ' + a_xml_response );
        
        //Just for temporary debugging... the full XML response is sent to Sophia
		/**	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {'sophiam@demandchain.com'};
			mail.setToAddresses(toAddresses);
			mail.setReplyTo('sophiam@demandchain.com');  
			mail.setSenderDisplayName('DCT ClientBuilder XML');
			mail.setSubject('DCT ClientBuilder XML');
			mail.setPlainTextBody(a_xml_response);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
    	
    	this.response_map = new Map<String, CBLeadResponse>();
    	
    	XmlStreamReader l_reader = new XmlStreamReader( a_xml_response );
    	
    	                                         // Loop over the XML elements
    	while( l_reader.hasNext() )
    	{
    		                                     // Check to see if the element
    		                                     // is an opening ForeignKey tag
    		if( l_reader.getEventType() == XmlTag.START_ELEMENT )
    		{	
    			if( l_reader.getLocalName() == 'ForeignKey' )
    			{
    				                             // Parse the ForeignKey
    				                             // tag to create a new
    				                             // CBLeadResponse Object
                    CBLeadResponse l_response = parseForeignKey( l_reader );
                    
                                                 // Add the CBLeadResponse
                                                 // object to the map
                    this.response_map.put( l_response.salesforce_record_id, l_response );
                    
    			}// END if( ForeignKey tag )
    		}// /END if( START ELEMENT )
    		
    		l_reader.next();
    		
    	}// /END while( XML Reader hasNext() )
    	
    	System.debug( 'Response Map = ' + this.response_map );
    	System.debug( 'END: ClientBuilderLeadServiceResponse.constructor()' );
    }

/******************************************************************************
 * Helper method used to parse the ForeignKey tag and children from the XML
 * response
 *
 * @param String a_foreign_key_xml : The xml response of the foreign key tag
 *
 * @return CBLeadResponse : A new CBLeadResponse ojbect with the values
 *                          populated from the ForeignKey XML tag
 */
    private
    CBLeadResponse
    parseForeignKey( XmlStreamReader l_reader )
    {
    	System.debug( 'START: ClientBuilderLeadServiceResponse.parseForeignKey()' );
    	System.debug( 'Param a_foreign_key_xml = ' + l_reader );
    	
    	CBLeadResponse l_cb_lead_response = new CBLeadResponse(); 
    	
    	// XmlStreamReader l_reader = new XmlStreamReader( a_foreign_key_xml );
    	
    	while( l_reader.hasNext() )
    	{
    		                                     // If this the END ForeignKey
    		                                     // element, break out of the
    		                                     // loop since we only want to 
    		                                     // process one ForeignKey
    		                                     // at a time
            
    		if( l_reader.getEventType() == XmlTag.END_ELEMENT
    		    && l_reader.getLocalName() == 'ForeignKey' )
    		{
    			break;
    		}
    		
            if( l_reader.getEventType() == XmlTag.START_ELEMENT )
            {
            	
                if( l_reader.getLocalName() == 'SalesForceID' )
                {
                	l_reader.next(); 
                	if( l_reader.hasText() )
                    {
                    	l_cb_lead_response.salesforce_record_id = l_reader.getText() ;
                    }
                }
                if( l_reader.getLocalName() == 'LeadKey' )
                {
                    l_reader.next();
                    if( l_reader.hasText() )
                    {
                    	l_cb_lead_response.client_builder_lead_id = l_reader.getText();
                    }
                }
                if( l_reader.getLocalName() == 'ErrMsg' )
                {
                    l_reader.next();
                	if( l_reader.hasText() )
                	{
                        l_cb_lead_response.error_message = l_reader.getText();
                	}
                }	
            }// /END if( START ELEMENT )
            
            l_reader.next();
            
    	}// /END while( XML hasNext() )

    	System.debug( 'Return: l_cb_lead_response = ' + l_cb_lead_response );
    	System.debug( 'END: ClientBuilderLeadServiceResponse.parseForeignKey()' );
    	
    	return l_cb_lead_response;
    }

/******************************************************************************
 * Helper class used to contain a single instance of the Client Builder Lead
 * create/update resonse
 *
 * @param String a_xml_response : The xml response from the Client Builder
 *                                web service
 */
    public class
    CBLeadResponse
    {
    	public String salesforce_record_id { get; set; }
    	public String client_builder_lead_id { get; set; }
    	public String error_message { get; set; }
        
        /**********************************************************************
         * Constructor
         */
        public
        CBLeadResponse()
        {}
        
    }// /END Class CBLeadResponse

}// /END Class