/******************************************************************************
 * A class representing a Participant object in the Dale Carnegie Client Builder
 * application
 *
 * @date 10/29/2013
 * @author Magnet 360
 */

public without sharing class 
ClientBuilderParticipant 
{

    public String participant_key       { get; set; } // Client_Builder_ID__c
    public String first_name            { get; set; } // FirstName
    public String middle_name           { get; set; } // ?
    public String last_name             { get; set; } // Last Name
    public String title                 { get; set; } // Title
    public String salutation            { get; set; } // Salutation
    public String nickname              { get; set; } // Nickname__c
    public String org_name              { get; set; } // Account.Name
    public String org_key               { get; set; } // Account.Name
    public String address               { get; set; } // MailingStreet
    public String city                  { get; set; } // MailingCity
    public String state                 { get; set; } // MailingState
    public String zip                   { get; set; } // MailingPostalCode
    public String country               { get; set; } // MailingCountry
    public String telephone             { get; set; } // Phone
    public String fax                   { get; set; } // Fax
    public String cell_phone            { get; set; } // MobilePhone
    public String email                 { get; set; } // Email
    public String phone_extension       { get; set; } // Phone_Extension__c
    public String franchisee_code       { get; set; } // Franchise_ID__c
    public String job_function          { get; set; } // Job_Function__c
    public String supervisor_name       { get; set; } // Supervisor_Name__c 
    public String supervisor_email      { get; set; } // Supervisor_Email__c
    public String supervisor_title      { get; set; } // Supervisor_Title__c
    public String supervisor_phone      { get; set; } // Supervisor_Phone__c
    
/******************************************************************************
 * Empty Constructor
 */
    public
    ClientBuilderParticipant()
    {
        System.debug( 'START: ClientBuilderLead.constructor()' );
        
        System.debug( 'END: ClientBuilderParticipant.constructor()' );
    }
    
/******************************************************************************
 * Constructor from a single Salesforce Contact record
 *
 * @param: Id a_contact_id : The salesforce id of the Contact that will be 
 *                           updated in client builder
 */
    public
    ClientBuilderParticipant( Id a_contact_id )
    {
        System.debug( 'START: ClientBuilderParticipant.constructor()' );
        System.debug( 'Param: a_contact_id = ' + a_contact_id );

        Contact l_contact;
        
                                                 // Query the information from
                                                 // the Contact record
        try
        {    
            l_contact = [ SELECT Client_Builder_ID__c,
                                  FirstName,
                                  LastName,
                                  Nickname__c,
                                  Email,
                                  Account.Name,
                                  Title,
                                  MailingStreet,
                                  MailingCity,
                                  MailingState,
                                  MailingPostalCode,
                                  MailingCountry,
                                  HomePhone,
                                  Phone,
                                  MobilePhone,
                                  Fax,
                                  Phone_Extension__c,
                                  Franchise_ID__c,
                                  Job_Function__c,
                                  ReportsTo.Name,
                                  ReportsTo.Title,
                                  ReportsTo.Phone,
                                  ReportsTo.Email,
                                  RecordTypeId,
                                  Salutation
                           FROM Contact
                           WHERE Id = :a_contact_id AND RecordTypeId !=: trac_Constants.dfgConRT
                           LIMIT 1 ]; 

        }
        catch( Exception l_contact_exception )
        {
            System.debug( 'Error when retreiving the contact record' );
            System.debug( 'Exception: ' + l_contact_exception );
        }
        
                                                 
        if( l_contact != null )
        {
                                                 // Set the Participant
                                                 // values for the XML
                                                 // structure
            this.participant_key        = l_contact.Client_Builder_ID__c;
            this.first_name             = l_contact.FirstName;
            this.last_name              = l_contact.LastName;
            this.title                  = l_contact.Title;
            this.salutation             = l_contact.Salutation;
            this.nickname               = l_contact.Nickname__c;
            this.email                  = l_contact.Email;
            this.org_name               = l_contact.Account.Name;
            this.org_key                = '';
            this.address                = l_contact.MailingStreet;
            this.city                   = l_contact.MailingCity;
            this.state                  = l_contact.MailingState;
            this.zip                    = l_contact.MailingPostalCode;
            this.country                = l_contact.MailingCountry;
            this.telephone              = l_contact.Phone;
            this.fax                    = l_contact.Fax;
            this.cell_phone             = l_contact.MobilePhone;
            this.phone_extension        = l_contact.Phone_Extension__c;
            this.franchisee_code        = l_contact.Franchise_ID__c;
            this.job_function           = l_contact.Job_Function__c;
            this.supervisor_email       = l_contact.ReportsTo.Email;
            this.supervisor_name        = l_contact.ReportsTo.Name;
            this.supervisor_phone       = l_contact.ReportsTo.Phone;
            this.supervisor_title       = l_contact.ReportsTo.Title;
        }

        System.debug( 'END: ClientBuilderParticipant.constructor()' );
    }    

/******************************************************************************
 * Method to create the XML Participant string used in the Client Builder 
 * Web Service calls. Built from the ClientBuilderParticipant object values
 *
 * @return String : The XML string representing the Participant object
 *
 * Sample XML
<NewDataSet>
  <ParticipantKey>1582390</ParticipantKey> 
  <FName>Patti</FName> 
  <MName /> 
  <LName>Core</LName> 
  <Title></Title>
  <Salutation></Salutation> 
  <NickName></NickName> 
  <OrgName>Prequel Solutions</OrgName> *not required if contact does not have an account
  <OrgKey>12345</OrgKey> *not required if contact does not an have an account
  <Addr>395 Valley Brook Road</Addr> 
  <City>McMurray</City> 
  <State>PA</State> 
  <Zip>15317</Zip> 
  <Country>US</Country> 
  <Phone>7248201575</Phone> 
  <Fax /> 
  <Cell /> 
  <Email>pcore@prequelsolutions.com</Email> 
  <Ext />
  <FranchiseeCode>345</FranchiseeCode>
  <JobFunction>Function</JobFunction>
</NewDataSet>
*/
    public
    String
    toXML()
    {
        System.debug( 'START: ClientBuilderParticipant.toXML()' );
        
        String l_participant_xml;
                
        XmlStreamWriter l_writer = new XmlStreamWriter();
                                                 // Start NewDataSet
        l_writer.writeStartElement( null, 'NewDataSet', null );

                                                 // ParticipantKey
        l_writer.writeStartElement( null, 'ParticipantKey', null );
        l_writer.writeCharacters( this.participant_key == null ? '' : this.participant_key );
        l_writer.writeEndElement();
                                                 // First Name
        l_writer.writeStartElement( null, 'FName', null );
        l_writer.writeCharacters( this.first_name == null ? '' : this.first_name );
        l_writer.writeEndElement();
                                                 // Middle Name
        l_writer.writeStartElement( null, 'MName', null );
        l_writer.writeCharacters( this.middle_name == null ? '' : this.middle_name );
        l_writer.writeEndElement();                                                 
                                                 // Last Name
        l_writer.writeStartElement( null, 'LName', null );
        l_writer.writeCharacters( this.last_name == null ? '' : this.last_name );
        l_writer.writeEndElement();
                                                 // Title
        l_writer.writeStartElement( null, 'Title', null );
        l_writer.writeCharacters( this.title == null ? '' : this.title );
        l_writer.writeEndElement();
                                                 // Salutation
        l_writer.writeStartElement( null, 'Salutation', null );
        l_writer.writeCharacters( this.salutation == null ? '' : this.salutation );
        l_writer.writeEndElement();
                                                 // NickName
        l_writer.writeStartElement( null, 'NickName', null );
        l_writer.writeCharacters( this.nickname == null ? '' : this.nickname );
        l_writer.writeEndElement();
                                                 // OrgName
        l_writer.writeStartElement( null, 'OrgName', null );
        l_writer.writeCharacters( this.org_name == null ? '' : this.org_name );
        l_writer.writeEndElement();
                                                 // OrgKey
        l_writer.writeStartElement( null, 'OrgKey', null );
        l_writer.writeCharacters( this.org_key == null ? '' : this.org_key );
        l_writer.writeEndElement();
                                                 // Address
        l_writer.writeStartElement( null, 'Addr', null );
        l_writer.writeCharacters( this.address == null ? '' : this.address );
        l_writer.writeEndElement();
        
                                                 // City
        l_writer.writeStartElement( null, 'City', null );
        l_writer.writeCharacters( this.city == null ? '' : this.city );
        l_writer.writeEndElement();
        
                                                 // State
        l_writer.writeStartElement( null, 'State', null );
        l_writer.writeCharacters( this.state == null ? '' : this.state );
        l_writer.writeEndElement();
        
                                                 // Zip
        l_writer.writeStartElement( null, 'Zip', null );
        l_writer.writeCharacters( this.zip == null ? '' : this.zip );
        l_writer.writeEndElement();
        
                                                 // Country
        l_writer.writeStartElement( null, 'Country', null );
        l_writer.writeCharacters( this.country == null ? '' : this.country );
        l_writer.writeEndElement();
        
                                                 // Phone
        l_writer.writeStartElement( null, 'Phone', null );
        l_writer.writeCharacters( this.telephone == null ? '' : this.telephone );
        l_writer.writeEndElement();
        
                                                 // Fax
        l_writer.writeStartElement( null, 'Fax', null );
        l_writer.writeCharacters( this.fax == null ? '' : this.fax );
        l_writer.writeEndElement();
        
                                                 // Cell
        l_writer.writeStartElement( null, 'Cell', null );
        l_writer.writeCharacters( this.cell_phone == null ? '' : this.cell_phone );
        l_writer.writeEndElement();
        
                                                 // Email
        l_writer.writeStartElement( null, 'Email', null );
        l_writer.writeCharacters( this.email == null ? '' : this.email );
        l_writer.writeEndElement();
        
                                                 // Phone Extension
        l_writer.writeStartElement( null, 'Ext', null );
        l_writer.writeCharacters( this.phone_extension == null ? '' : this.phone_extension );
        l_writer.writeEndElement();
        
                                                 // Franchisee Code
        l_writer.writeStartElement( null, 'FranchiseeCode', null );
        l_writer.writeCharacters( this.franchisee_code == null ? '' : this.franchisee_code );
        l_writer.writeEndElement();
        
                                                 // Franchisee Code
        l_writer.writeStartElement( null, 'JobFunction', null );
        l_writer.writeCharacters( this.job_function == null ? '' : this.job_function );
        l_writer.writeEndElement();
        
                                                 // Supervisor/Manager Name
        l_writer.writeStartElement( null, 'SupervisorManagerName', null );
        l_writer.writeCharacters( this.supervisor_name == null ? '' : this.supervisor_name );
        l_writer.writeEndElement();
        
                                                 // Supervisor Title
        l_writer.writeStartElement( null, 'SupervisorTitle', null );
        l_writer.writeCharacters( this.supervisor_title == null ? '' : this.supervisor_title );
        l_writer.writeEndElement();
        
                                                 // Supervisor Telephone
        l_writer.writeStartElement( null, 'SupervisorTelephone', null );
        l_writer.writeCharacters( this.supervisor_phone == null ? '' : this.supervisor_phone);
        l_writer.writeEndElement();
        
                                                 // Supervisor/Manager Email
        l_writer.writeStartElement( null, 'SupervisorManagerEmail', null );
        l_writer.writeCharacters( this.supervisor_email == null ? '' : this.supervisor_email );
        l_writer.writeEndElement();
        
        
                                                 // /END NewDataSet
        l_writer.writeEndElement();
                
        l_participant_xml = l_writer.getXmlString();
        
        l_writer.close();
        
        System.debug( 'Return: l_participant_xml = ' + l_participant_xml );
        System.debug( 'END: ClientBuilderParticipant.toXML()' );
        
        return l_participant_xml;
    }    
}// /END Class