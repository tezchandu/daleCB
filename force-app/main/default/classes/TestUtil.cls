/*******************************************************************************
 * A utility class used to create data, objects, & records for use during test
 * methods
 * 
 * @date 10/1/2013
 * @author Magnet 360
 * 
 * @updates
 * 09/20/2016	Sophia Murphy (Magnet 360)
 * 				Updated getFranchiseObjectAccesses for ACCOUNTS - Opp/Case/Contact access
 * 06.20.2022	Sophia Murphy (demand Chain)
 * 				Changed default to Business Account, the NY Franchise RT has been removed
 */

@isTest ( SeeAllData=false )
public class 
TestUtil 
{

/*******************************************************************************
 * Method to create a list of User records. The records are not added to 
 * the database so that their information can be modified by the test method
 * before the insert occurs if necessary.
 * 
 * @param a_number : The number of User records to create
 * @param a_profile_name : The name of the profile to assign to the users
 *
 * @return List<User> : 
 */
    public
    List<User>
    getUsers( Integer a_number, String a_profile_name ) 
    {
        System.debug( 'START: TestUtil.getUsers()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_profile_name: ' + a_profile_name );
        
                                                 // If the profile name 
                                                 // param is null, get a 
                                                 // a default standard profile
        if( a_profile_name == null || a_profile_name == '' )
        {
            a_profile_name = 'Standard User';
        }

        List<User> l_users = new List<User>();
        
                                                 // Get the profile Id to 
                                                 // assign to the user
        List<Profile> l_profiles = [ SELECT Id,
                                            Name
                                     FROM Profile 
                                     WHERE Name = :a_profile_name ];
        
        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
                                                 // Get a random number to append
                                                 // to the username to prevent
                                                 // duplicates
            Integer l_rand = Crypto.getRandomInteger();
            
            User l_user = new User();
            l_user.FirstName = 'Test';
            l_user.LastName = 'User ' + l_count;
            l_user.Email = 'noemail' + String.valueOf( l_rand ) + '@dalecarnegie.com';
            l_user.Alias = String.valueOf( l_rand ).substring( 0, 5 );
            l_user.Username = l_user.Email;
            l_user.CommunityNickname = String.valueOf( l_rand );
            l_user.Franchise_ID__c = String.valueOf( l_rand ).substring( 0, 5 );
            l_user.TimeZoneSidKey = 'America/Chicago';
            l_user.LocaleSidKey = 'en_US';
            l_user.EmailEncodingKey = 'ISO-8859-1';
            l_user.LanguageLocaleKey = 'en_US';
            l_user.IsActive = true;
            l_user.DefaultCurrencyIsoCode = 'USD';
            
            if( l_profiles.size() > 0 )
            {
                l_user.ProfileId = l_profiles[ 0 ].Id;  
            }
            
            l_users.add( l_user );
        }
        
        System.debug( 'Return: l_users = ' + l_users );
        System.debug( 'END: TestUtil.getUsers()' );
        
        return l_users;
    }

/*******************************************************************************
 * Method to create Account records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of account records to create
 * @param a_record_type_name : The name of the record type to assign to the accounts
 *                        being created. If no record type is passed in, a
 *                        default one is assigned   
 * @param a_owner_id : The salesforce id of the Account owner. If no value is passed
 *                     in, a user record is created to use as the owner
 * @return List<Account> - a list of the account records
 */
    public
    List<Account>
    getAccounts( Integer a_number, String a_record_type_name, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getAccounts()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_record_type_name: ' + a_record_type_name );
        System.debug( 'Method Params: a_owner_id: ' + a_owner_id );
        
        String l_rand;
        String l_rand2;
        List<Account> l_accounts = new List<Account>();
        
                                                 // If no record type name
                                                 // is passed in, set a default
        if( a_record_type_name == null || a_record_type_name == '' )
        {
            //a_record_type_name = 'New York Franchise';
            //06.20.2022 - Sophia Murphy (demand Chain)
            //Changed default to Business Account, the NY Franchise RT has been removed
            a_record_type_name = 'Business Account';
        }
        
        Id l_record_type_id = [ SELECT Id
                                 FROM RecordType
                                 WHERE Name = :a_record_type_name 
                                  AND sObjectType = 'Account'
                                 LIMIT 1 ].Id;
        
                                                 // Create a user to assign as
        User l_owner;                                         // the Account owner
        if( a_owner_id == null || a_owner_id == '' ) 
        {
            l_owner = getUsers( 1, 'Franchise Sales Team' )[ 0 ];
            insert l_owner;
            a_owner_id = l_owner.Id;
        }
        
        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            //Addition of random integer to stop dup checker - using TWO random numbers
            l_rand = String.valueOf( Crypto.getRandomInteger() );
            l_rand2 = String.valueOf( Crypto.getRandomInteger() );
            
            Account l_account = new Account();
            l_account.Name                      = 'Test ' + l_rand + ' Account ' + l_rand2 + ' Name ';
            l_account.RecordTypeId              = l_record_type_id;
            l_account.OwnerId                   = (Id) a_owner_id;
            l_account.Account_Type__c           = 'Prospect';
            l_account.Franchise_Territory__c    = 'Test Territory';
            l_account.Organization_Location__c  = 'Unknown';
            l_account.Status__c                 = 'Active';
            //l_account.Process_Sharing__c        = true ; 

            l_accounts.add( l_account );
            
        }// /END for( Integer l_count)
        
        System.debug( 'Return: l_accounts = ' + l_accounts );
        System.debug( 'END: TestUtil.getAccounts()' );
        
        return l_accounts;
    }

/*******************************************************************************
 * Method to create Franchise Team records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of FrachiseTeam records to create
 * @param a_owner_id : The salesforce id of the FranchiseTeam owner. If no value is passed
 *                     in, a user record is created to use as the owner
 * @return List<Frachise_Team__c> - a list of the FranchiseTeam records
 */
    public
    List<Franchise_Team__c>
    getFranchiseTeams( Integer a_number, String ftName, Id accountId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getFranchiseTeams()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_owner_id: ' + a_owner_id );
        
        List<Franchise_Team__c> frachiseTeamList = new List<Franchise_Team__c>();
        
        // Create a user to assign as FranchiseTeam
        User l_owner;
        if( a_owner_id == null || a_owner_id == '' ) 
        {
            l_owner = getUsers( 1, 'Franchise Sales Team' )[ 0 ];
            insert l_owner;
            a_owner_id = l_owner.Id;
        }
        
        for( Integer i = 0; i < a_number; i++ )
        {
            Franchise_Team__c ft = new Franchise_Team__c();
            ft.Name =  ftName ; 
            ft.Franchise_Account__c = accountId ;
            ft.Process_Sharing__c = true;
            frachiseTeamList.add( ft );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: Franchise Team List = ' + frachiseTeamList );
        System.debug( 'END: TestUtil.getFranchiseTeam()' );
        
        return frachiseTeamList ;
    }

/*******************************************************************************
 * Method to create Franchise Team Member records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of FrachiseTeamMembers records to create
 * @param FranchiseTeamId : The salesforce id of the FranchiseTeam owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Franchise_Team_Member__c>
    getFranchiseTeamMembers( Integer a_number, Id franchiseTeamId , Id userId, String access ) 
    {
        System.debug( 'START: TestUtil.getFranchiseTeamMembers()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: franchiseTeamId: ' + franchiseTeamId );
        System.debug( 'Method Params: userId: ' + userId );
        System.debug( 'Method Params: access: ' + access );

        List<Franchise_Team_Member__c> frachiseTeamMembersList = new List<Franchise_Team_Member__c>();
        
        for( Integer i = 0; i < a_number; i++ )
        {
            Franchise_Team_Member__c ftm = new Franchise_Team_Member__c();
            ftm.Franchise_ID__c = franchiseTeamId ;
            ftm.User__c = userId ;
            ftm.Access__c = access ;
            frachiseTeamMembersList.add( ftm );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: Franchise Team Member List = ' + frachiseTeamMembersList );
        System.debug( 'END: TestUtil.getFranchiseTeamMembers()' );
        
        return frachiseTeamMembersList ;
    }

/*******************************************************************************
 * Method to create Franchise Object Access records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of FrachiseTeamMembers records to create
 * @param FranchiseTeamId : The salesforce id of the FranchiseTeam owner. 
 * @param adminAccess : Access type for admin Read,Write,Edit,None or Read/Write 
 * @param mamangerAccess : Access type for Manager Read,Write,Edit,None or Read/Write 
 * @param salesAccess : Access type for Sales Read,Write,Edit,None or Read/Write 
 * @param objectName:  String object name on which security rules will apply
 * @return List<Franchise_Object_Access__c> - a list of the FranchiseObjectAccess records
 */
    public
    List<Franchise_Object_Access__c>
    getFranchiseObjectAccesses( Integer a_number, Id franchiseTeamId , String adminAccess , String managerAccess, String salesAccess, String objName ) 
    {
        System.debug( 'START: TestUtil.getFranchiseObjectAccesses()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: franchiseTeamId: ' + franchiseTeamId );
        System.debug( 'Method Params: adminAccess: ' + adminAccess );
        System.debug( 'Method Params: managerAccess: ' + managerAccess );
        System.debug( 'Method Params: salesAccess: ' + salesAccess );
        
        List<Franchise_Object_Access__c> foaList = new List<Franchise_Object_Access__c>();
        
        for( Integer i = 0; i < a_number; i++ )
        {
            Franchise_Object_Access__c foa = new Franchise_Object_Access__c();
            foa.Franchise_ID__c = franchiseTeamId ;
            foa.Admin_Access__c = adminAccess ;
            foa.Manager_Access__c = managerAccess ;
            foa.Sales_Access__c = salesAccess ;
            foa.Object_Name__c = objName ;

            //If this is an account - we need to add in the contact/opp/case access too.
            if(objName == FranchiseSharingUtil.STR_ACCOUNT)
            {
                foa.Case_Admin_Access__c = adminAccess ;
                foa.Case_Manager_Access__c = managerAccess ;
                foa.Case_Sales_Access__c = salesAccess ;
                foa.Contact_Admin_Access__c = adminAccess ;
                foa.Contact_Manager_Access__c = managerAccess ;
                foa.Contact_Sales_Access__c = salesAccess ;
                foa.Opp_Admin_Access__c = adminAccess ;
                foa.Opp_Manager_Access__c = managerAccess ;
                foa.Opp_Sales_Access__c = salesAccess ;

            }


            foaList.add( foa );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: Franchise Object Access List = ' + foaList );
        System.debug( 'END: TestUtil.getFranchiseObjectAccesses()' );
        
        return foaList ;
    }

/*******************************************************************************
 * Method to create ProgramHistory records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of ProgramHistory records to create
 * @param FranchiseTeamId : The salesforce id of the ProgramHistory owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Program_History__c>
    getProgramHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Program_History__c> phList = new List<Program_History__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Program_History__c ph = new Program_History__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            if( accountId != null ) ph.Account__c = accountId ;
            if( contactId != null ) ph.Contact__c = contactId ; 

            phList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + phList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return phList ;
    }
    
    /*******************************************************************************
 * Method to create AreaLocation records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of AreaLocation records to create
 * @param FranchiseTeamId : The salesforce id of the AreaLocation owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Area_Location__c>
    getareaHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Area_Location__c> areaList = new List<Area_Location__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Area_Location__c ph = new Area_Location__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
    /*******************************************************************************
 * Method to create Alternate Revenue Type records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Alternate Revenue Type records to create
 * @param FranchiseTeamId : The salesforce id of the Alternate Revenue Type owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Alternate_Revenue_Type__c>
    getarvHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Alternate_Revenue_Type__c> areaList = new List<Alternate_Revenue_Type__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Alternate_Revenue_Type__c ph = new Alternate_Revenue_Type__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
    /*******************************************************************************
 * Method to create AreaLocation records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of AreaLocation records to create
 * @param FranchiseTeamId : The salesforce id of the AreaLocation owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Award__c>
    getawardHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Award__c> areaList = new List<Award__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Award__c ph = new Award__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
    /*******************************************************************************
 * Method to create AreaLocation records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of AreaLocation records to create
 * @param FranchiseTeamId : The salesforce id of the AreaLocation owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Attendance__c>
    getattHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Attendance__c> areaList = new List<Attendance__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Attendance__c ph = new Attendance__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
     /*******************************************************************************
 * Method to create Program_Coaching_Assistant__c records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Program_Coaching_Assistant__c records to create
 * @param FranchiseTeamId : The salesforce id of the Program_Coaching_Assistant__c owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Program_Coaching_Assistant__c>
    getPCHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Program_Coaching_Assistant__c> areaList = new List<Program_Coaching_Assistant__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Program_Coaching_Assistant__c ph = new Program_Coaching_Assistant__c();
            //ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
     /*******************************************************************************
 * Method to create AreaLocation records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of AreaLocation records to create
 * @param FranchiseTeamId : The salesforce id of the AreaLocation owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Employee__c>
    getempHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Employee__c> areaList = new List<Employee__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Employee__c ph = new Employee__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
     /*******************************************************************************
 * Method to create AreaLocation records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of AreaLocation records to create
 * @param FranchiseTeamId : The salesforce id of the AreaLocation owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Employment_Date__c>
    getempDateHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Employment_Date__c> areaList = new List<Employment_Date__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Employment_Date__c ph = new Employment_Date__c();
            //ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
     /*******************************************************************************
 * Method to create Fee_Payment__c records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Fee_Payment__c records to create
 * @param FranchiseTeamId : The salesforce id of the Fee_Payment__c owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Fee_Payment__c>
    getfpHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Fee_Payment__c> areaList = new List<Fee_Payment__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Fee_Payment__c ph = new Fee_Payment__c();
           // ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
     /*******************************************************************************
 * Method to create AreaLocation records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of AreaLocation records to create
 * @param FranchiseTeamId : The salesforce id of the AreaLocation owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Coaching_Assistant__c>
    getcaHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Coaching_Assistant__c> areaList = new List<Coaching_Assistant__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Coaching_Assistant__c ph = new Coaching_Assistant__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
    /*******************************************************************************
 * Method to create Session__c records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Session__c records to create
 * @param FranchiseTeamId : The salesforce id of the Session__c owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Session__c>
    getsessionHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Session__c> areaList = new List<Session__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Session__c ph = new Session__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
    /*******************************************************************************
 * Method to create Trainer__c records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Trainer__c records to create
 * @param FranchiseTeamId : The salesforce id of the Trainer__c owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Trainer__c>
    gettrainerHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Trainer__c> areaList = new List<Trainer__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Trainer__c ph = new Trainer__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
    /*******************************************************************************
 * Method to create Trainer_Certification_Event__c records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Trainer_Certification_Event__c records to create
 * @param FranchiseTeamId : The salesforce id of the Trainer_Certification_Event__c owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Trainer_Certification_Event__c>
    gettcHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Trainer_Certification_Event__c> areaList = new List<Trainer_Certification_Event__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Trainer_Certification_Event__c ph = new Trainer_Certification_Event__c();
            ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
    /*******************************************************************************
 * Method to create Program_Trainer__c records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Program_Trainer__c records to create
 * @param FranchiseTeamId : The salesforce id of the Program_Trainer__c owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Program_Trainer__c>
    getptHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Program_Trainer__c> areaList = new List<Program_Trainer__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Program_Trainer__c ph = new Program_Trainer__c();
           // ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
     /*******************************************************************************
 * Method to create Sales_Person__c records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Sales_Person__c records to create
 * @param FranchiseTeamId : The salesforce id of the Sales_Person__c owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Sales_Person__c>
    getsalesPHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Sales_Person__c> areaList = new List<Sales_Person__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Sales_Person__c ph = new Sales_Person__c();
           // ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
     /*******************************************************************************
 * Method to create Registration__c records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Registration__c records to create
 * @param FranchiseTeamId : The salesforce id of the Registration__c owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Registration__c>
    getregHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Registration__c> areaList = new List<Registration__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Registration__c ph = new Registration__c();
           // ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }
    
     /*******************************************************************************
 * Method to create Program_Trainer__c records. Does not insert the records so that they can
 * be manipulated first by the calling class.
 * 
 * @param a_number : The number of Program_Trainer__c records to create
 * @param FranchiseTeamId : The salesforce id of the Program_Trainer__c owner. 
 * @param userId : The salesfore Id of user to assign 
 * @param access:  String access type e.g sales, admin
 * @return List<Franchise_Team_Member__c> - a list of the FranchiseTeamMember records
 */
    public
    List<Program_Location__c>
    getplocHistories( Integer a_number, Id accountId , Id contactId, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getProgramHistories()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: accountId: ' + accountId );
        System.debug( 'Method Params: contactId: ' + contactId );

        String l_rand ; 
        List<Program_Location__c> areaList = new List<Program_Location__c>();
        l_rand = String.valueOf( Crypto.getRandomInteger() );

        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }

        for( Integer i = 0; i < a_number; i++ )
        {
            Program_Location__c ph = new Program_Location__c();
           // ph.Name = 'Test ' + l_rand ; 
            ph.OwnerId = a_owner_id ; 
            //ph.Process_Sharing__c = true ; 
            //if( accountId != null ) ph.Franchise__c = accountId ;
           // if( contactId != null ) ph.Contact__c = contactId ; 

            areaList.add( ph );
            
        }// /END for( Integer i)
        
        System.debug( 'Return: ProgramHistory List = ' + areaList );
        System.debug( 'END: TestUtil.getProgramHistories()' );
        
        return areaList ;
    }


/*******************************************************************************
 * Method to create Contact records, and assign them to an account. The Contact
 * records are not inserted to the database so they can be manipulated first 
 * by the calling class.
 * 
 * @param a_number : The number of contact records to create 
 * @param a_account_id : The salesforce Id of the Account record to assign the
 *                       Contact records to
 *
 * @return List<Contact> - The list of created Contact records
 */
    public
    List<Contact>
    getContacts( Integer a_number, String a_account_id ) 
    {
        System.debug( 'START: TestUtil.getContacts()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_account_id: ' + a_account_id );
        
                                                 // If no Account is passed
                                                 // in, get one
        if( a_account_id == null || a_account_id == '' )
        {
            Account l_account = getAccounts( 1, '', '' )[ 0 ];
            insert l_account;
            
            a_account_id = l_account.Id;
        }
        
        List<Contact> l_contacts = new List<Contact>();
        
        String l_rand;
        
        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            l_rand = String.valueOf( Crypto.getRandomInteger() );
            
            Contact l_contact = new Contact();
            
            l_contact.FirstName         = 'FirstName ' + l_count;
            l_contact.LastName          = 'LastName ' + l_count;
            l_contact.Email             = 'email.test.' + l_rand + '@m360CommunityEmail.com';
            l_contact.AccountId         = a_account_id;
            //l_contact.Process_Sharing__c= true ; 

            l_contacts.add( l_contact );
        }// /END for( Integer l_count)
        
        System.debug( 'Return: l_contacts = ' + l_contacts );
        System.debug( 'END: TestUtil.getContacts()' );
        
        return l_contacts;
        
    }

/*******************************************************************************
 * Method to create cases and assign them a user. Does not insert the records so 
 * that they can be manipulated first by the calling class.
 * 
 * @param a_number : The number of Case records to create
 * @param a_account_id : The salesforce Id of the Account record to assign the
 *                       Case records to
 * @param a_owner_id : The salesforce Id of the user to assign the Cases to
 *
 * @return List<Case> : 
 */
    public
    List<Case>
    getCases( Integer a_number, String a_account_id, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getCases()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_account_id: ' + a_account_id );
        System.debug( 'Method Params: a_owner_id: ' + a_owner_id );
        
        List<Case> l_cases = new List<Case>();
        
                                                 // If no Owner is passed
                                                 // in, get one
        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }
        
                                                 // If no Account is passed
                                                 // in, get one
        if( a_account_id == null || a_account_id == '' )
        {
            Account l_account = getAccounts( 1, '', '' )[ 0 ];
            insert l_account;
            
            a_account_id = l_account.Id;
        }
        
        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            
            Case l_case = new Case();
            l_case.AccountId        = a_account_id;
            l_case.OwnerId          = a_owner_id;
            l_case.Type             = 'Test Type';
            l_case.Reason           = 'Test Reason';
            l_case.Status           = 'New';
            l_case.Origin           = 'Email';
            
            l_cases.add( l_case );
        }
        
        System.debug( 'Return: l_cases = ' + l_cases );
        System.debug( 'END: TestUtil.getCases()' );
        
        return l_cases;
    }


/*******************************************************************************
 * Method to create lead records for testing. Does not insert the records so 
 * that they can be manipulated first by the calling class.
 * 
 * @param a_number : The number of Lead records to create
 * @param a_lead_type : The type of lead to create: S, D, or W
 * @param a_owner_id : The owner to assign the lead to. Also determines the 
 *                     Franchise that lead is assigned to. If no owner is 
 *                     passed in, one is automatically created and assigned 
 *                     the leads 
 *
 * @return List<Lead> : 
 */
    public
    List<Lead>
    getLeads( Integer a_number, String a_lead_type, String a_owner_id ) 
    {
        String l_rand = String.valueOf( Crypto.getRandomInteger() );
        
        System.debug( 'START: TestUtil.getLeads()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_lead_type: ' + a_lead_type );
        System.debug( 'Method Params: a_owner_id: ' + a_owner_id );
        
        List<Lead> l_leads = new List<Lead>();
        
                                                 // If no Owner is passed
                                                 // in, get one
        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }
        
        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            
            Lead l_lead = new Lead();
            l_lead.OwnerId          = a_owner_id;
            l_lead.Company          = 'Test Company' + l_count + l_rand.left( 5 );
            l_lead.FirstName        = 'First Name ' + l_count;
            l_lead.LastName         = 'Last Name ' + l_count;
            l_lead.Email            = 'testemail' + l_count + '@emailtest.com';
            l_lead.Lead_Type__c     = a_lead_type;
            l_lead.Status           = 'Open';
            l_lead.LeadSource       = 'Other';
            //l_lead.Process_Sharing__c = true ;

            l_leads.add( l_lead );
        }
        
        System.debug( 'Return: l_leads = ' + l_leads );
        System.debug( 'END: TestUtil.getLeads()' );
        
        return l_leads;
    }

/*******************************************************************************
 * Method to create Lead Source records for testing. Does not insert the records  
 * so that they can be manipulated first by the calling class.
 * 
 * @param a_number : The number of Lead Source records to create
 * @param a_lead_id : Lead to set the Lead Source records on
 *
 * @return List<Lead_Source_Detail__c> : 
 */
    public
    List<Lead_Source_Detail__c>
    getLeadSources( Integer a_number, String a_lead_id ) 
    {
        System.debug( 'START: TestUtil.getLeadSources()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_lead_id: ' + a_lead_id );
        
        List<Lead_Source_Detail__c> l_lead_sources = new List<Lead_Source_Detail__c>();
        
        Id l_owner_id;
                                                 // If no Lead is passed
                                                 // in, get one
        if( a_lead_id == null || a_lead_id == '' )
        {
            Lead l_lead = getLeads( 1, 'S', '' )[ 0 ];
            insert l_lead;
            
            a_lead_id = l_lead.Id;
            l_owner_id = l_lead.OwnerId;
        }
        else
        {
                                                 // Get the Owner Id from
                                                 // the Lead owner
            l_owner_id = [ SELECT OwnerId
                           FROM Lead
                           WHERE Id = :a_lead_id
                           LIMIT 1 ].OwnerId; 
        }
        
        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            String l_rand = String.valueOf( Crypto.getRandomInteger() );
            
            Lead_Source_Detail__c l_lead_source = new Lead_Source_Detail__c();
            l_lead_source.Name          = 'Lead Source ' + l_rand.left( 5 );
            l_lead_source.OwnerId       = l_owner_id;
            l_lead_source.Key_Code__c   = l_rand.left( 5 );
            l_lead_source.Lead__c       = a_lead_id;
            //l_lead_source.Process_Sharing__c = true ; 

            l_lead_sources.add( l_lead_source );
        }
        
        System.debug( 'Return: l_lead_sources = ' + l_lead_sources );
        System.debug( 'END: TestUtil.getLeadSources()' );
        
        return l_lead_sources;
    }

/*******************************************************************************
 * Method to create Contact Source records for testing. Does not insert the records  
 * so that they can be manipulated first by the calling class.
 * 
 * @param a_number : The number of Contact Source records to create
 * @param a_contact_id : Contact to set the Contac Source records on
 *
 * @return List<Lead_Source_Detail__c> : 
 */
    public
    List<Contact_Source_Detail__c>
    getContactSources( Integer a_number, String a_contact_id ) 
    {
        System.debug( 'START: TestUtil.getContactSources()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_contact_id: ' + a_contact_id );
        
        List<Contact_Source_Detail__c> l_contact_sources = new List<Contact_Source_Detail__c>();
        
        Id l_owner_id;
                                                 // If no Contact is passed
                                                 // in, get one
        if( a_contact_id == null || a_contact_id == '' )
        {
            Contact l_contact = getContacts( 1, '' )[ 0 ];
            insert l_contact;
            
            a_contact_id = l_contact.Id;
            l_owner_id = l_contact.OwnerId;
        }
        else
        {
                                                 // Get the Owner Id from
                                                 // the Contact owner
            l_owner_id = [ SELECT OwnerId
                           FROM Contact
                           WHERE Id = :a_contact_id
                           LIMIT 1 ].OwnerId; 
        }
        
        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            String l_rand = String.valueOf( Crypto.getRandomInteger() );
            
            Contact_Source_Detail__c l_contact_source = new Contact_Source_Detail__c();
            l_contact_source.Name          = 'Lead Source ' + l_rand.left( 5 );
            l_contact_source.OwnerId       = l_owner_id;
            l_contact_source.Key_Code__c   = l_rand.left( 5 );
            l_contact_source.Contact__c    = a_contact_id;
            l_contact_source.Form_Name__c  = 'Form Name ' + l_count;
            l_contact_source.Added_Date__c = Date.today();
            //l_contact_source.Process_Sharing__c = true ; 

            l_contact_sources.add( l_contact_source );
        }
        
        System.debug( 'Return: l_contact_sources = ' + l_contact_sources );
        System.debug( 'END: TestUtil.getContactSources()' );
        
        return l_contact_sources;
    }

/*******************************************************************************
 * Method to create Campaign records for testing. Does not insert the records so 
 * that they can be manipulated first by the calling class.
 * 
 * @param a_number : The number of Campaigns records to create
 * @param a_owner_id : The owner to assign the Campaign to. Also determines the 
 *                     Franchise that Campaign is assigned to. If no owner is 
 *                     passed in, one is automatically created and assigned 
 *                     the leads 
 *
 * @return List<Campaign> : 
 */
    public
    List<Campaign>
    getCampaigns( Integer a_number, String a_owner_id ) 
    {
        String l_rand = String.valueOf( Crypto.getRandomInteger() );
        
        System.debug( 'START: TestUtil.getCampaigns()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_owner_id: ' + a_owner_id );
        
        List<Campaign> campaignList = new List<Campaign>();
        
                                                 // If no Owner is passed
                                                 // in, get one
        if( a_owner_id == null || a_owner_id == '' )
        {
            User l_user = getUsers( 1, '' )[ 0 ];
            insert l_user;
            
            a_owner_id = l_user.Id;
        }
        
        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            
            Campaign cam = new Campaign();
            cam.Name = 'Campaign ' + l_rand.left( 5 );
            cam.IsActive = true; 
            cam.OwnerId = a_owner_id ;
            campaignList.add( cam );
        }
        
        System.debug( 'Return: campaignList = ' + campaignList );
        System.debug( 'END: TestUtil.getCampaigns()' );
        
        return campaignList;
    }

/*******************************************************************************
 * Method to create Opportunity records for testing. Does not insert the records  
 * so that they can be manipulated first by the calling class.
 * 
 * @param a_number : The number of Lead Source records to create
 * @param a_account_id : The Salesforce Account Id to assign the Opportunity 
 *                       records to. If no value is passed in, a default Account 
 *                       is created
 * @param a_owner_id : The Salesforce User Id to assign to the opportunities as
 *                     the owner. If no value is passed in, the Account Owner is used
 *
 * @return List<Opportunity> : 
 */
    public
    List<Opportunity>
    getOpportunities( Integer a_number, String a_account_id, String a_owner_id ) 
    {
        System.debug( 'START: TestUtil.getOpportunities()' );
        System.debug( 'Method Params: a_number: ' + a_number );
        System.debug( 'Method Params: a_account_id: ' + a_account_id );
        System.debug( 'Method Params: a_owner_id: ' + a_owner_id );
        
        List<Opportunity> l_opportunities = new List<Opportunity>();

                                                 // If no Account is passed
                                                 // in, get one
        if( a_account_id == null || a_account_id == '' )
        {
            Account l_account = getAccounts( 1, '', '' )[ 0 ];
            insert l_account;
            
            a_account_id = l_account.Id;
            
            if( a_owner_id == null || a_owner_id == '' )
            {
                a_owner_id = l_account.OwnerId;
            }
            
        }// /END if( a_account == null )
        
                                                 // If no owner is passed in,
                                                 // and it wasn't already set
                                                 // from the account owner,
                                                 // get the account owner
                                                 // to use to the set Opportunity
                                                 // owner
        if( a_account_id != '' 
            && ( a_owner_id == null || a_owner_id == '' ) )
        {
            a_owner_id = [ SELECT OwnerId
                           FROM Account
                           WHERE Id = :a_account_id
                           LIMIT 1 ].OwnerId;
                           
        }// /END if( a_account_id != null && a_owner_id == null )

        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            String l_rand = String.valueOf( Crypto.getRandomInteger() );
            
            Opportunity l_opp = new Opportunity();
            l_opp.Name                      = 'Test Opp ' + l_rand.left( 5 ) + l_count;
            l_opp.AccountId                 = a_account_id;
            l_opp.OwnerId                   = a_owner_id;
            l_opp.Franchise_Territory__c    = 'Test Territory';
            l_opp.StageName                 = 'Qualification' ;
            l_opp.CloseDate                 = Date.today().addDays( 7 );
            l_opp.CurrencyIsoCode = 'USD';

            l_opportunities.add( l_opp );
        }
        
        System.debug( 'Return: l_opportunities = ' + l_opportunities );
        System.debug( 'END: TestUtil.getOpportunities()' );
        
        return l_opportunities;
    }
    
/*******************************************************************************
 *
 */
    public 
    List<OpportunityContactRole> 
    getOpportunityContactRoles( Integer a_number, 
                                String opportunityId, 
                                String contactId, 
                                String role) 
    {
        List<OpportunityContactRole> roles = new List<OpportunityContactRole>();
        
        for( integer i = 0; i < a_number; i ++ ) 
        {
            roles.add(new OpportunityContactRole(Role = role, 
                                                 ContactId = contactId, 
                                                 OpportunityId = opportunityId ) );   
        }
        
        return roles;
    }

    /*******************************************************************************
    * Method to create OpportunityLineItem records for testing. Does not insert the records  
    * so that they can be manipulated first by the calling class.
    * 
    * @param a_number : The number of OpportunityLineItem records to create
    * @OppId : OpportunityId under which pricebook entries need to create
    *@priceBookId : PricebookEntry Id for OLI
    * @return List<OpportunityLineItem> : 
    */
    public List<OpportunityLineItem> getOpportunityLineItems( Integer a_number, Id oppId, Id priceBookId ) 
    {
        System.debug( 'START: TestUtil.getOpportunityLineItems()' );
        System.debug( 'Method Params: a_number: ' + a_number );
       
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        
        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            String l_rand = String.valueOf( Crypto.getRandomInteger() );
            
            OpportunityLineItem li = new OpportunityLineItem();
            li.Pricebookentryid= priceBookId ;
            li.TotalPrice=2000 ;
            li.Quantity = 2 ;
            li.OpportunityID = oppId ;
            items.add( li );
        }
        
        System.debug( 'Return: items = ' + items );
        System.debug( 'END: TestUtil.getOpportunityLineItems()' );
        
        return items;
    }


    /*******************************************************************************
    * Method to create Product2 records for testing. Does not insert the records  
    * so that they can be manipulated first by the calling class.
    * 
    * @param a_number : The number of Product2 records to create
    *
    * @return List<Product2> : 
    */
    public List<Product2> getProducts( Integer a_number ) 
    {
        System.debug( 'START: TestUtil.getProducts()' );
        System.debug( 'Method Params: a_number: ' + a_number );
       
        List<Product2> products = new List<Product2>();

        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            String l_rand = String.valueOf( Crypto.getRandomInteger() );
            
            Product2 prd = new Product2();
            prd.Name = 'Test'; 
            prd.Family = 'Hardware'; 
            prd.CurrencyIsoCode = 'USD';

            products.add( prd );
        }
        
        System.debug( 'Return: products = ' + products );
        System.debug( 'END: TestUtil.getProducts()' );
        
        return products;
    }
    
    
    /*******************************************************************************
    * Method to create PriceBookEntry records for testing. Does not insert the records  
    * so that they can be manipulated first by the calling class.
    * 
    * @param a_number : The number of PriceBookEntry records to create
    * @ProductId : Product Id in which under pricebook entries need to create
    *
    * @return List<PriceBookEntry> : 
    */
    public List<PriceBookEntry> getPriceBookEntries( Integer a_number, Id productId ) 
    {
        System.debug( 'START: TestUtil.getPriceBookEntries()' );
        System.debug( 'Method Params: a_number: ' + a_number );
       
        List<PriceBookEntry> pbEntries = new List<PriceBookEntry>();
        Id priceBookId = Test.getStandardPricebookId(); 

        for( Integer l_count = 0; l_count < a_number; l_count++ )
        {
            String l_rand = String.valueOf( Crypto.getRandomInteger() );
            
            PriceBookEntry pbe = new PriceBookEntry();
            pbe.CurrencyIsoCode = 'USD' ; 
            pbe.UnitPrice = 300; 
            pbe.PriceBook2Id = priceBookId ; 
            pbe.Product2Id = productId; 
            pbe.IsActive = true;
            pbEntries.add( pbe );
        }
        
        System.debug( 'Return: pbEntries = ' + pbEntries );
        System.debug( 'END: TestUtil.getPriceBookEntries()' );
        
        return pbEntries;
    }
    
}// /END Class