/******************************************************************************
 * A class representing a Lead object in the Dale Carnegie Client Builder
 * application
 *
 * @date 10/14/2013
 * @author Magnet 360
 */

public without sharing class 
ClientBuilderLead
{

                                                 // Define the CB Lead variables
    public List<ClientBuilderLeadDetail> lead_details { get; set; }
    public List<ClientBuilderLeadSource> lead_products { get; set; }

/******************************************************************************
 * Empty Constructor
 */
    public
    ClientBuilderLead()
    {
        System.debug( 'START: ClientBuilderLead.constructor()' );
        
        this.lead_details = new List<ClientBuilderLeadDetail>();
        this.lead_products = new List<ClientBuilderLeadSource>();
        
        System.debug( 'END: ClientBuilderLead.constructor()' );
    }

/******************************************************************************
 * Constructor from a Salesforce Contact record
 *
 * @param: List<Id> a_contact_ids : The list of Contact Ids that will be created
 *                                  as Leads in client builder
 *
 * @param: List<Id> a_opp_line_item_ids : The list of opportunity line items 
 *                                        (products) that will be assigned to 
 *                                        the lead in CB
 */
    public
    ClientBuilderLead( List<Id> a_contact_ids, List<Id> a_opp_line_item_ids )
    {
        System.debug( 'START: ClientBuilderLead.constructor()' );
        System.debug( 'Param: a_contact_ids = ' + a_contact_ids );
        System.debug( 'Param: a_opp_line_item_ids = ' + a_opp_line_item_ids );
        
        this.lead_details = new List<ClientBuilderLeadDetail>();
        this.lead_products = new List<ClientBuilderLeadSource>();

        List<Contact> l_contacts;
        List<OpportunityLineItem> l_opp_line_items;
        
                                                 // Query the information from
                                                 // the Contact record
        try
        {    
            l_contacts = [ SELECT Id,
                                  Salutation,
                                  FirstName,
                                  LastName,
                                  Nickname__c,
                                  Email,
                                  MailingStreet,
                                  Account.Name,
                                  Title,
                                  MailingCity,
                                  MailingState,
                                  MailingPostalCode,
                                  MailingCountry,
                                  Phone,
                                  MobilePhone,
                                  ReportsTo.Name,
                                  ReportsTo.Title,
                                  ReportsTo.Phone,
                                  ReportsTo.Email,
                                  Account.Industry,
                                  Franchise_ID__c,
                                  Lead_Type__c,
                                  RecordTypeId,
                                  Client_Builder_Lead_ID__c,
                                  ( SELECT Form_Name__c,
                                           Key_Code__c,
                                           Promo_Code__c
                                    FROM Contact_Source_Details__r
                                    ORDER BY Added_Date__c DESC )
                           FROM Contact
                           WHERE Id IN :a_contact_ids AND RecordTypeId !=: trac_Constants.dfgConRT ];
        }
        catch( Exception l_contact_exception )
        {
            System.debug( 'Error when retreiving the contact records' );
            System.debug( 'Exception: ' + l_contact_exception );
        }
                                                 // Query the information from
                                                 // the OpportunityLineItem records
        if( a_opp_line_item_ids != null
            && a_opp_line_item_ids.size() > 0 )
        {
            try
            {    
                l_opp_line_items = [ SELECT Id,
                                            ServiceDate,
                                            UnitPrice,
                                            Program_Code__c,
                                            PricebookEntry.Product2.Name,
                                            Opportunity.CloseDate
                                     FROM OpportunityLineItem
                                     WHERE Id IN :a_opp_line_item_ids ]; 
    
            }
            catch( Exception l_opportunity_exception )
            {
                System.debug( 'Error when retreiving the opportunity product records' );
                System.debug( 'Exception: ' + l_opportunity_exception );
            }
    
        }// /END if( a_opp_line_item_ids != null )
        
                                                 // Loop through the contacts
                                                 // to create CB lead records for
        for( Contact l_contact : l_contacts )
        {
            String l_key_code = '';
            String l_promo_code = '';
            
            if( l_contact.Contact_Source_Details__r.size() > 0 )
            {
                l_key_code = l_contact.Contact_Source_Details__r[ 0 ].Key_Code__c;
                l_promo_code = l_contact.Contact_Source_Details__r[ 0 ].Promo_Code__c;
            }
                                                 // Create the Lead Detail objects
            this.lead_details.add( new ClientBuilderLeadDetail( l_contact ) );
            
                                                 // Create the Lead Product
                                                 // records for the contact
            if( l_opp_line_items != null )
            {
                for( OpportunityLineItem l_line_item : l_opp_line_items )
                {
                    this.lead_products.add( new ClientBuilderLeadSource( l_line_item, 
                                                                         l_contact.Id,
                                                                         l_key_code,
                                                                         l_promo_code ) );
                }
            }
            else
            {
                                                 // We still need to create the 
                                                 // lead source objects for the
                                                 // xml structure, just with blank
                                                 // values for the products
                this.lead_products.add( new ClientBuilderLeadSource( l_contact.Id, l_key_code, l_promo_code ) );
                
            }// /END if( l_opp_line_items != null )
            
        }// /END if( Contact != null )

        System.debug( 'END: ClientBuilderLead.constructor()' );
    }

/******************************************************************************
 * Constructor from a Salesforce Lead record
 *
 * @param: List<Id> a_lead_ids : The list of Lead Ids that will have their 
 *                               corresponding lead record updated in Client Builder
 *                               
 */
    public
    ClientBuilderLead( List<Id> a_lead_ids )
    {
        System.debug( 'START: ClientBuilderLead.constructor()' );
        System.debug( 'Param: a_lead_ids = ' + a_lead_ids );
        
        this.lead_details = new List<ClientBuilderLeadDetail>();
        this.lead_products = new List<ClientBuilderLeadSource>();

        List<Lead> l_leads;
                                                 // Query the information from
                                                 // the Contact record
        try
        {    
            l_leads = [ SELECT Id,
                              Salutation,
                              FirstName,
                              LastName,
                              Nickname__c,
                              Email,
                              Street,
                              Company,
                              Industry,
                              Title,
                              City,
                              State,
                              PostalCode,
                              Country,
                              Phone,
                              MobilePhone,
                              Supervisor_Name__c,
                              Supervisor_Title__c,
                              Supervisor_Phone__c,
                              Supervisor_Email__c,
                              Franchise_ID__c,
                              Client_Builder_Lead_ID__c   
                       FROM Lead
                       WHERE Id IN :a_lead_ids AND RecordTypeId !=: trac_Constants.dfgLeadRT  ]; 

        }
        catch( Exception l_lead_exception )
        {
            System.debug( 'Error when retreiving the lead records' );
            System.debug( 'Exception: ' + l_lead_exception );
        }

                                                 // Loop through the Leads
                                                 // to create CB lead records for
        for( Lead l_lead : l_leads )
        {
                                                 // Create the Lead Detail objects
            this.lead_details.add( new ClientBuilderLeadDetail( l_lead ) );
            
                                                 // This has no Lead Source 
                                                 // objects
            
        }// /END for( Leads )

        System.debug( 'END: ClientBuilderLead.constructor()' );
    }

/******************************************************************************
 * Method to create the XML Lead string used in the Client Builder Web Service
 * calls. Built from the ClientBuilderLead object values
 *
 * @return String : The XML string representing the lead object
 *
 * Sample XML
  <NewDataSet>
     <LeadDetails>
        <SaleForceID>1</SaleForceID>
        <Prefix />
        <FirstName>Patti</FirstName>
        <MiddleInitial />
        <LastName>Core</LastName>
        <Nickname />
        <Email>pcore@prequelsolutions.com</Email>
        <Address>395 Valley Brook Road</Address>
        <Company>Prequel Solutions</Company >
        <Title />
        <City>McMurray</City>
        <State>PA</State>
        <Country>US</Country>
        <Zip>15317</Zip>
        <Telephone>7248201587</Telephone>
        <Cellphone />
        <SupervisorManagerName />
        <SupervisorTitle />
        <SupervisorTelephone />
        <SupervisorManagerEmail />
        <IndustryTypeKey />
        <IndustryTypeOtherDesc />
        <FranchiseCode>911070</FranchiseCode>
    **** This is only populated when the LEAD record in Client Builder is to UPDATED ****
        <LeadKey>1334</LeadKey>  
      </LeadDetails>
      <LeadSource>
        <SaleForceID>1</SaleForceID>
        <ProgramKey>13SS06</ProgramKey>
        <RegisteredDate>10/14/2013</RegisteredDate>
        <Price>1795.0000</Price>
        <EventDate>11/11/2013</EventDate>
        <FormName>Registration</FormName>
        <KeyCode></KeyCode>
        <PromoCode></PromoCode>
        <LeadType>S</LeadType>
        <EventName>Product Name</EventName>
      </LeadSource>
  </NewDataSet>
 */
    public
    String
    toXML()
    {
        System.debug( 'START: ClientBuilderLead.toXML()' );
        
        String l_xml = '<NewDataSet>';
                                                 // Loop over the CB Lead Detail
                                                 // Records and write their XML
        for( ClientBuilderLeadDetail l_lead_detail : this.lead_details )
        {
            l_xml += l_lead_detail.toLeadDetailXML();
                
        }// /END for( Lead Details )
        
                                                 // Loop over the CB Lead Source
                                                 // Records and write their XML
        for( ClientBuilderLeadSource l_lead_source : this.lead_products )
        {
            l_xml += l_lead_source.toLeadSourceXML();
                
        }// /END for( Lead Source )
        
                                                 // End NewDataSet
        l_xml += '</NewDataSet>';
        
        System.debug( 'Return: l_xml = ' + l_xml );
        System.debug( 'END: ClientBuilderLead.toXML()' );
        
        return l_xml;       
    }

/******************************************************************************
 * A helper class to hold the Client Builder Lead's Details information
 */
    public class
    ClientBuilderLeadDetail
    {
        public String salesforce_id                 { get; set; } // Contact.Id
        public String prefix                        { get; set; } // Salutation
        public String first_name                    { get; set; } // FirstName
        public String middle_initial                { get; set; } // ?
        public String last_name                     { get; set; } // Last Name
        public String nickname                      { get; set; } // Nickname__c
        public String email                         { get; set; } // Email
        public String address                       { get; set; } // MailingStreet
        public String company                       { get; set; } // Account.Name
        public String title                         { get; set; } // Title
        public String city                          { get; set; } // MailingCity
        public String state                         { get; set; } // MailingState
        public String country                       { get; set; } // MailingCountry
        public String zip                           { get; set; } // MailingPostalCode
        public String telephone                     { get; set; } // Phone
        public String cell_phone                    { get; set; } // MobilePhone
        public String supervisor_manager_name       { get; set; } // Supervisor_Name__c
        public String supervisor_title              { get; set; } // Supervisor_Title__c
        public String superviser_telephone          { get; set; } // Supervisor_Phone__c
        public String superviser_manager_email      { get; set; } // Supervisor_Email__c
        public String industry_type_key             { get; set; } // Account.Industry
        public String industry_type_other_desc      { get; set; } // ?
        public String franchise_code                { get; set; } // Franchise_ID__c
        public String lead_key                      { get; set; } // Lead.Client_Builder_Lead_ID__c

        /**********************************************************************
         * Constructor from a contact
         *
         * @param Contact a_contact : The contact record that is used as the
         *                            Client Builder Lead record
         */
        public
        ClientBuilderLeadDetail( Contact a_contact )
        {
            System.debug( 'START: ClientBuilderLead.ClientBuilderLeadDetail.constructor()' );
            
            // Set the CB Lead values 
            this.salesforce_id                  = a_contact.Id;
            this.prefix                         = a_contact.Salutation;
            this.first_name                     = a_contact.FirstName;
            this.last_name                      = a_contact.LastName;
            this.nickname                       = a_contact.Nickname__c;
            this.email                          = a_contact.Email;
            this.address                        = a_contact.MailingStreet;
            this.company                        = a_contact.Account.Name;
            this.title                          = a_contact.Title;
            this.city                           = a_contact.MailingCity;
            this.state                          = a_contact.MailingState;
            this.country                        = a_contact.MailingCountry;
            this.zip                            = a_contact.MailingPostalCode;
            this.telephone                      = a_contact.Phone;
            this.cell_phone                     = a_contact.MobilePhone;
            this.supervisor_manager_name        = a_contact.ReportsTo.Name;
            this.supervisor_title               = a_contact.ReportsTo.Title;
            this.superviser_telephone           = a_contact.ReportsTo.Phone;
            this.superviser_manager_email       = a_contact.ReportsTo.Email;
            this.lead_key                       = a_contact.Client_Builder_Lead_ID__c;
            
            // Industry type key has not been established yet
            // this.industry_type_key              = a_contact.Account.Industry;
            this.industry_type_other_desc       = a_contact.Account.Industry;
            this.franchise_code                 = a_contact.Franchise_ID__c;
            
            System.debug( 'END: ClientBuilderLead.ClientBuilderLeadDetail.constructor()' );
        }
        
        /**********************************************************************
         * Constructor from a Lead
         *
         * @param Lead a_lead : The Lead record that is used to update the 
         *                            Client Builder Lead record
         */
        public
        ClientBuilderLeadDetail( Lead a_lead )
        {
            System.debug( 'START: ClientBuilderLead.ClientBuilderLeadDetail.constructor()' );
            System.debug( 'Param: a_lead = ' + a_lead );
            
            // Set the CB Lead values 
            this.salesforce_id                  = a_lead.Id;
            this.prefix                         = a_lead.Salutation;
            this.first_name                     = a_lead.FirstName;
            this.last_name                      = a_lead.LastName;
            this.nickname                       = a_lead.Nickname__c;
            this.email                          = a_lead.Email;
            this.address                        = a_lead.Street;
            this.company                        = a_lead.Company;
            this.title                          = a_lead.Title;
            this.city                           = a_lead.City;
            this.state                          = a_lead.State;
            this.country                        = a_lead.Country;
            this.zip                            = a_lead.PostalCode;
            this.telephone                      = a_lead.Phone;
            this.cell_phone                     = a_lead.MobilePhone;
            this.supervisor_manager_name        = a_lead.Supervisor_Name__c;
            this.supervisor_title               = a_lead.Supervisor_Title__c;
            this.superviser_telephone           = a_lead.Supervisor_Phone__c;
            this.superviser_manager_email       = a_lead.Supervisor_Email__c;
            this.lead_key                       = a_lead.Client_Builder_Lead_ID__c;
            // Industry type key has not been established yet
            // this.industry_type_key              = a_lead.Account.Industry;
            this.industry_type_other_desc       = a_lead.Industry;
            this.franchise_code                 = a_lead.Franchise_ID__c;
            
            System.debug( 'END: ClientBuilderLead.ClientBuilderLeadDetail.constructor()' );
        }
        
        /**********************************************************************
         * Method to transorm the object into the proper XML string for use
         * in the web service callout
         *
         * EXAMPLE XML STRUCTURE
         * <LeadDetails>
         *   <SaleForceID>1</SaleForceID>
         *   <Prefix />
         *   <FirstName>Patti</FirstName>
         *   <MiddleInitial />
         *   <LastName>Core</LastName>
         *   <Nickname />
         *   <Email>pcore@prequelsolutions.com</Email>
         *   <Address>395 Valley Brook Road</Address>
         *   <Company>Prequel Solutions</Company >
         *   <Title />
         *   <City>McMurray</City>
         *   <State>PA</State>
         *   <Country>US</Country>
         *   <Zip>15317</Zip>
         *   <Telephone>7248201587</Telephone>
         *   <Cellphone />
         *   <SupervisorManagerName />
         *   <SupervisorTitle />
         *   <SupervisorTelephone />
         *   <SupervisorManagerEmail />
         *   <IndustryTypeKey />
         *   <IndustryTypeOtherDesc />
         *   <FranchiseCode>911070</FranchiseCode>
              **** This is only populated when the LEAD record in Client Builder is to be UPDATED ****
              <LeadKey>2342</LeadKey>
         * </LeadDetails>
         *       
         */
        public
        String
        toLeadDetailXML()
        {
            System.debug( 'START: ClientBuilderLead.ClientBuilderLeadDetail.toLeadDetailXML()' );
            
            String l_lead_detail_xml;
        
            XmlStreamWriter l_writer = new XmlStreamWriter();
            
                                                 // Start LeadDetails
            l_writer.writeStartElement( null, 'LeadDetails', null );
            
                                                 // Salesforce Id
            l_writer.writeStartElement( null, 'SalesForceID', null );
            l_writer.writeCharacters( this.salesforce_id == null ? '' : this.salesforce_id );
            l_writer.writeEndElement();
                                                 // Prefix
            l_writer.writeStartElement( null, 'Prefix', null );
            l_writer.writeCharacters( this.prefix == null ? '' : this.prefix );
            l_writer.writeEndElement();
                                                 // FirstName
            l_writer.writeStartElement( null, 'FirstName', null );
            l_writer.writeCharacters( this.first_name == null ? '' : this.first_name );
            l_writer.writeEndElement();
                                                 // MiddleInitial
            l_writer.writeStartElement( null, 'MiddleInitial', null );
            l_writer.writeCharacters( this.middle_initial == null ? '' : this.middle_initial );
            l_writer.writeEndElement();
                                                 // LastName
            l_writer.writeStartElement( null, 'LastName', null );
            l_writer.writeCharacters( this.last_name == null ? '' : this.last_name );
            l_writer.writeEndElement();
                                                 // Nickname
            l_writer.writeStartElement( null, 'Nickname', null );
            l_writer.writeCharacters( this.nickname == null ? '' : this.nickname );
            l_writer.writeEndElement();
                                                 // Email
            l_writer.writeStartElement( null, 'Email', null );
            l_writer.writeCharacters( this.email == null ? '' : this.email );
            l_writer.writeEndElement();
                                                 // Address
            l_writer.writeStartElement( null, 'Address', null );
            l_writer.writeCharacters( this.address == null ? '' : this.address );
            l_writer.writeEndElement();
                                                 // Company
            l_writer.writeStartElement( null, 'Company', null );
            l_writer.writeCharacters( this.company == null ? '' : this.company );
            l_writer.writeEndElement();
                                                 // Title
            l_writer.writeStartElement( null, 'Title', null );
            l_writer.writeCharacters( this.title == null ? '' : this.title );
            l_writer.writeEndElement();
                                                 // City
            l_writer.writeStartElement( null, 'City', null );
            l_writer.writeCharacters( this.city == null ? '' : this.city );
            l_writer.writeEndElement();
                                                 // State
            l_writer.writeStartElement( null, 'State', null );
            l_writer.writeCharacters( this.state == null ? '' : this.state );
            l_writer.writeEndElement();
                                                 // Country
            l_writer.writeStartElement( null, 'Country', null );
            l_writer.writeCharacters( this.country == null ? '' : this.country );
            l_writer.writeEndElement();
                                                 // Zip
            l_writer.writeStartElement( null, 'Zip', null );
            l_writer.writeCharacters( this.zip == null ? '' : this.zip );
            l_writer.writeEndElement();
                                                 // Telephone
            l_writer.writeStartElement( null, 'Telephone', null );
            l_writer.writeCharacters( this.telephone == null ? '' : this.telephone );
            l_writer.writeEndElement();
                                                 // CellPhone
            l_writer.writeStartElement( null, 'CellPhone', null );
            l_writer.writeCharacters( this.cell_phone == null ? '' : this.cell_phone );
            l_writer.writeEndElement();
                                                 // SupervisorManagerName
            l_writer.writeStartElement( null, 'SupervisorManagerName', null );
            l_writer.writeCharacters( this.supervisor_manager_name == null ? '' : this.supervisor_manager_name );
            l_writer.writeEndElement();
                                                 // SupervisorTitle
            l_writer.writeStartElement( null, 'SupervisorTitle', null );
            l_writer.writeCharacters( this.supervisor_title == null ? '' : this.supervisor_title );
            l_writer.writeEndElement();
                                                 // SupervisorTelephone
            l_writer.writeStartElement( null, 'SupervisorTelephone', null );
            l_writer.writeCharacters( this.superviser_telephone == null ? '' : this.superviser_telephone );
            l_writer.writeEndElement();
                                                 // SupervisorManagerEmail
            l_writer.writeStartElement( null, 'SupervisorManagerEmail', null );
            l_writer.writeCharacters( this.superviser_manager_email == null ? '' : this.superviser_manager_email );
            l_writer.writeEndElement();
                                                 // IndustryTypeKey
            l_writer.writeStartElement( null, 'IndustryTypeKey', null );
            l_writer.writeCharacters( this.industry_type_key == null ? '' : this.industry_type_key );
            l_writer.writeEndElement();
                                                 // IndustryTypeOtherDesc
            l_writer.writeStartElement( null, 'IndustryTypeOtherDesc', null );
            l_writer.writeCharacters( this.industry_type_other_desc == null ? '' : this.industry_type_other_desc );
            l_writer.writeEndElement();
                                                 // FranchiseCode
            l_writer.writeStartElement( null, 'FranchiseCode', null );
            l_writer.writeCharacters( this.franchise_code == null ? '' : this.franchise_code );
            l_writer.writeEndElement();
            
                                                 // LeadKey
            l_writer.writeStartElement( null, 'LeadKey', null );
            l_writer.writeCharacters( this.lead_key == null ? '' : this.lead_key );
            l_writer.writeEndElement();
            
                                                 // End LeadDetails
            l_writer.writeEndElement();
            
            l_lead_detail_xml = l_writer.getXmlString();
            
            l_writer.close();
            
            System.debug( 'Return: l_lead_detail_xml = ' + l_lead_detail_xml );
            System.debug( 'END: ClientBuilderLead.ClientBuilderLeadDetail.toLeadDetailXML()' );
            
            return l_lead_detail_xml;
        }
    }// /END Class ClientBuilderLeadSource
     
     
/******************************************************************************
 * A helper class to hold the Client Builder Lead's Product information
 */
    public class
    ClientBuilderLeadSource
    {
        public String salesforce_id    { get; set; } // Contact.Id
        public String program_key      { get; set; } // OpportunityLineItem.Program_Code__c
        public String registered_date  { get; set; } // Opportunity.CloseDate
        public String price            { get; set; } // OpportunityLineItem.UnitPrice
        public String event_name       { get; set; } // OpportunityLineItem.PricebookEntry.Product2.Name
        public String event_date       { get; set; } // OpportunityLineItem.ServiceDate
        public String lead_type        { get; set; } // Always 'S' on creation
        public String form_name        { get; set; } // Always 'Registration' on creation
        public String key_code         { get; set; } // Contact_Source_Detail__r.Key_Code__c
        public String promo_code       { get; set; } // Contact_Source_Detail__r.Promo_Code__c

        /**********************************************************************
         * Constructor for use with a Product and a Contact
         *
         * @param OpportunityLineItem a_product : The opportunity line item
         *                                        product that will be used with
         *                                        the Client Builder Lead record
         * @param Id a_contact_id : The Salesforce Id of the contact record
         *                          associated with the lead source.
         * @param String a_key_code : The Key Code value from the Contact Source Record
         * @param String a_promo_code : Promo Code value from the Contact Source Record
         *
         */
        public
        ClientBuilderLeadSource( OpportunityLineItem a_product, 
                                 Id a_contact_id, 
                                 String a_key_code, 
                                 String a_promo_code )
        {
            System.debug( 'START: ClientBuilderLead.ClientBuilderLeadSource.constructor()' );
            System.debug( 'Param: a_product = ' + a_product );
            System.debug( 'Param: a_contact_id = ' + a_contact_id );
            System.debug( 'Param: a_key_code = ' + a_key_code );
            System.debug( 'Param: a_promo_code = ' + a_promo_code );
            
            this.salesforce_id      = a_contact_id;
            this.program_key        = a_product.Program_Code__c;
            this.registered_date    = String.valueOf( a_product.Opportunity.CloseDate );
            this.price              = String.valueOf( a_product.UnitPrice );
            this.event_name         = String.valueOf( a_product.PricebookEntry.Product2.Name );
            this.event_date         = String.valueOf( a_product.ServiceDate );
            this.key_code           = String.valueOf( a_key_code );
            this.promo_code         = String.valueOf( a_promo_code );
            this.form_name          = Org_Settings__c.getInstance().Client_Builder_Lead_Source_Form_Name__c;
            this.lead_type          = Org_Settings__c.getInstance().Client_Builder_Lead_Source_Type__c;

            System.debug( 'END: ClientBuilderLead.ClientBuilderLeadSource.constructor()' );
        }
        
        /**********************************************************************
         * Constructor for use when the contact does not have a product
         * associated with it
         *
         * @param Id a_contact_id : The Salesforce Id of the contact record
         *                          associated with the lead source.
         * @param String a_key_code : The Key Code value from the Contact Source Record
         * @param String a_promo_code : Promo Code value from the Contact Source Record
         */
        public
        ClientBuilderLeadSource( Id a_contact_id, String a_key_code, String a_promo_code )
        {
            System.debug( 'START: ClientBuilderLead.ClientBuilderLeadSource.constructor()' );
            System.debug( 'Param: a_contact_id = ' + a_contact_id );
            System.debug( 'Param: a_key_code = ' + a_key_code );
            System.debug( 'Param: a_promo_code = ' + a_promo_code );
            
            this.salesforce_id      = a_contact_id;
            this.program_key        = '';
            this.registered_date    = '';
            this.price              = '';
            this.event_name         = '';
            this.event_date         = '';
            this.key_code           = String.valueOf( a_key_code );
            this.promo_code         = String.valueOf( a_promo_code );
            this.form_name          = Org_Settings__c.getInstance().Client_Builder_Lead_Source_Form_Name__c;
            this.lead_type          = Org_Settings__c.getInstance().Client_Builder_Lead_Source_Type__c;

            System.debug( 'END: ClientBuilderLead.ClientBuilderLeadSource.constructor()' );
        }
        
        /**********************************************************************
         * Method to transorm the object into the proper XML string for use
         * in the web service callout
         *
         * EXAMPLE XML STRUCTURE
         * <LeadSource>
         *   <SaleForceID>1</SaleForceID>
         *   <ProgramKey>13SS06</ProgramKey>
         *   <RegisteredDate>10/14/2013</RegisteredDate>
         *   <Price>1795.0000</Price>
         *   <EventName>Name</EventName>
         *   <EventDate>11/11/2013</EventDate>
         *   <FormName>Registration</FormName>
         *   <KeyCode></KeyCode>
         *   <PromoCode></PromoCode>
         *   <LeadType>S</LeadType>
         * </LeadSource>
         *        
         */
        public
        String
        toLeadSourceXML()
        {
            System.debug( 'START: ClientBuilderLead.ClientBuilderLeadSource.toLeadSourceXML()' );
            
            String l_lead_source_xml;
            
            XmlStreamWriter l_writer = new XmlStreamWriter();
                                                     // Start LeadSource
            l_writer.writeStartElement( null, 'LeadSource', null );

                                                 // SalesForceID
            l_writer.writeStartElement( null, 'SalesForceID', null );
            l_writer.writeCharacters( this.salesforce_id == null ? '' : this.salesforce_id );
            l_writer.writeEndElement();
                                                 // Program Key
            l_writer.writeStartElement( null, 'ProgramKey', null );
            l_writer.writeCharacters( this.program_key == null ? '' : this.program_key );
            l_writer.writeEndElement();
                                                 // RegisteredDate
            l_writer.writeStartElement( null, 'RegisteredDate', null );
            l_writer.writeCharacters( this.registered_date == null ? '' : this.registered_date );
            l_writer.writeEndElement();                                                 
                                                 // Price
            l_writer.writeStartElement( null, 'Price', null );
            l_writer.writeCharacters( this.price == null ? '' : this.price );
            l_writer.writeEndElement();
            
                                                 // EventName
            l_writer.writeStartElement( null, 'EventName', null );
            l_writer.writeCharacters( this.event_name == null ? '' : this.event_name );
            l_writer.writeEndElement();
            
                                                 // EventDate
            l_writer.writeStartElement( null, 'EventDate', null );
            l_writer.writeCharacters( this.event_date == null ? '' : this.event_date );
            l_writer.writeEndElement();
                                                 // FormName
            l_writer.writeStartElement( null, 'FormName', null );
            l_writer.writeCharacters( this.form_name == null ? '' : this.form_name );
            l_writer.writeEndElement();
                                                 // KeyCode
            l_writer.writeStartElement( null, 'KeyCode', null );
            l_writer.writeCharacters( this.key_code == null ? '' : this.key_code );
            l_writer.writeEndElement();
                                                 // PromoCode
            l_writer.writeStartElement( null, 'PromoCode', null );
            l_writer.writeCharacters( this.promo_code == null ? '' : this.promo_code );
            l_writer.writeEndElement();
                                                 // LeadType
            l_writer.writeStartElement( null, 'LeadType', null );
            l_writer.writeCharacters( this.lead_type == null ? '' : this.lead_type );
            l_writer.writeEndElement();
                                                 // /END LeadSource
            
            l_writer.writeEndElement();
            
            l_lead_source_xml = l_writer.getXmlString();
            
            l_writer.close();
            
            System.debug( 'Return: l_lead_source_xml = ' + l_lead_source_xml );
            System.debug( 'END: ClientBuilderLead.ClientBuilderLeadSource.toLeadSourceXML()' );
            
            return l_lead_source_xml;
        }
    }// /END Class ClientBuilderLeadSource     
    
}// /END Class