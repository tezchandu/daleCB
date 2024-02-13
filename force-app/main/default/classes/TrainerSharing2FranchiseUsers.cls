public class TrainerSharing2FranchiseUsers {
    
    public static void sharingTrainers(Trainer__c trainer){
        
        List<Trainer__c> trainers = new List<Trainer__c>();
        String accountId = trainer.Contracted_By__c;
        Account acc = [select id,Franchise_ID__c,OwnerId from Account where id = :accountId limit 1];
        List<User> users = [select id,name,email,Franchise_ID__c from User where Franchise_ID__c = :acc.Franchise_ID__c];
        system.debug('Acc - '+acc);
        system.debug('users with same franchise - '+users);
        List<Trainer__Share> tsList = new List<Trainer__Share>();
        List<Trainer_Certification__Share> tshareList = new List<Trainer_Certification__Share>();
        List<Trainer_Certification__c> trainerCerts = [select id from Trainer_Certification__c where Trainer__c =:trainer.Id ];
        if(trainer.Contracted_By__c == acc.Id){
            for(User usrs :users){
                 Trainer__Share ts = new Trainer__Share();
                    ts.ParentId = trainer.Id;
                    ts.AccessLevel = 'Edit';
                    ts.UserOrGroupId = usrs.Id;
                    ts.RowCause = 'Manual';
                tsList.add(ts);
            }
        }
        for(Trainer_Certification__c tcs :trainerCerts){
            for(User usrs :users){
                 	Trainer_Certification__Share ts = new Trainer_Certification__Share();
                    ts.ParentId = tcs.Id;
                    ts.AccessLevel = 'Edit';
                    ts.UserOrGroupId = usrs.Id;
                    ts.RowCause = 'Manual';
                tshareList.add(ts);
            }
        }
        system.debug('users going to share - '+tsList);
        system.debug('users going to share TCS - '+tshareList);
        Database.SaveResult[] sres = Database.insert(tsList,false);
        for (Database.SaveResult sr : sres) {
        if(sr.isSuccess()){
            system.debug('Sharing rule inserted succesfully');
        }
        else {
            Database.Error err = sr.getErrors()[0];
            
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
               err.getMessage().contains('AccessLevel')){
                   
               }
            else{
                
            }
        }
        }
        Database.SaveResult[] sresult = Database.insert(tshareList,false);
        for (Database.SaveResult sr : sresult) {
        if(sr.isSuccess()){
            system.debug('Sharing rule inserted succesfully');
        }
        else {
            Database.Error err = sr.getErrors()[0];
            
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
               err.getMessage().contains('AccessLevel')){
                   
               }
            else{
                
            }
        }
        }
    }
    
    public static void sharingTrainersCerts(Trainer_Certification__c trainerCert){
        system.debug('newtrainer - ' +trainerCert);
        List<Trainer_Certification__c> trainersCerts = new List<Trainer_Certification__c>();
        Trainer__c trainers = [select id,Contracted_By__c from Trainer__c where id =:trainerCert.Trainer__c limit 1];
        system.debug(trainers);
        String accountId = trainers.Contracted_By__c;
        system.debug(accountId);
        Account acc = [select id,Franchise_ID__c,OwnerId from Account where id = :accountId limit 1];
        List<User> users = [select id,name,email,Franchise_ID__c from User where Franchise_ID__c = :acc.Franchise_ID__c];
        List<Trainer_Certification__Share> tsList = new List<Trainer_Certification__Share>();
        
        if(trainers.Contracted_By__c == acc.Id){
            for(User usrs :users){
                 	Trainer_Certification__Share ts = new Trainer_Certification__Share();
                    ts.ParentId = trainerCert.Id;
                    ts.AccessLevel = 'Edit';
                    ts.UserOrGroupId = usrs.Id;
                    ts.RowCause = 'Manual';
                tsList.add(ts);
            }
        }
        system.debug('users going to share - '+tsList);
        Database.SaveResult[] sres = Database.insert(tsList,false);
        for (Database.SaveResult sr : sres) {
        if(sr.isSuccess()){
            system.debug('Sharing rule inserted succesfully');
        }
        else {
            Database.Error err = sr.getErrors()[0];
            
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
               err.getMessage().contains('AccessLevel')){
                   
               }
            else{
                
            }
        }
        }
    }
    
    public static void sharingAvailableFranchises(Available_Franchise__c availableFranchise){
        List<Trainer__c> trainers = new List<Trainer__c>();
        String trainerId = availableFranchise.Trainer__c;
        Trainer__c trainer = [select id ,Franchise_ID__c, Contracted_By__c from Trainer__c where id= :trainerId limit 1];
        String accountId = availableFranchise.Franchise__c;
        Account acc = [select id,Franchise_ID__c,OwnerId from Account where id = :accountId limit 1];
        List<User> users = [select id,name,email,Franchise_ID__c from User where Franchise_ID__c = :acc.Franchise_ID__c];
        List<Trainer__Share> tsList = new List<Trainer__Share>();
        List<Available_Franchise__Share> availFranList = new List<Available_Franchise__Share>();
        //if(trainer.Contracted_By__c == acc.Id){
            for(User usrs :users){
                 Trainer__Share ts = new Trainer__Share();
                    ts.ParentId = trainer.Id;
                    ts.AccessLevel = 'Edit';
                    ts.UserOrGroupId = usrs.Id;
                    ts.RowCause = 'Manual';
                tsList.add(ts);
            }
        //}
        if(accountId == acc.iD){
            for(User usrs :users){
                 Available_Franchise__Share avail = new Available_Franchise__Share();
                    avail.ParentId = availableFranchise.Id;
                    avail.AccessLevel = 'Edit';
                    avail.UserOrGroupId = usrs.Id;
                    avail.RowCause = 'Manual';
                availFranList.add(avail);
            }
        }
        List<Trainer_Certification__Share> tshareList = new List<Trainer_Certification__Share>();
        List<Trainer_Certification__c> trainerCerts = [select id from Trainer_Certification__c where Trainer__c =:trainer.Id ];
        
        for(Trainer_Certification__c tcs :trainerCerts){
            for(User usrs :users){
                 	Trainer_Certification__Share ts = new Trainer_Certification__Share();
                    ts.ParentId = tcs.Id;
                    ts.AccessLevel = 'Edit';
                    ts.UserOrGroupId = usrs.Id;
                    ts.RowCause = 'Manual';
                tshareList.add(ts);
            }
        }
        Database.SaveResult[] sres = Database.insert(tsList,false);
        for (Database.SaveResult sr : sres) {
        if(sr.isSuccess()){
            system.debug('Sharing rule inserted succesfully');
        }
        else {
            Database.Error err = sr.getErrors()[0];
            
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
               err.getMessage().contains('AccessLevel')){
                   
               }
            else{
                
            }
        }
        }
        Database.SaveResult[] sresAvail = Database.insert(availFranList,false);
        for (Database.SaveResult sr : sresAvail) {
        if(sr.isSuccess()){
            system.debug('Sharing rule inserted succesfully');
        }
        else {
            Database.Error err = sr.getErrors()[0];
            
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
               err.getMessage().contains('AccessLevel')){
                   
               }
            else{
                
            }
        }
        }
        Database.SaveResult[] sresult = Database.insert(tshareList,false);
        for (Database.SaveResult sr : sresult) {
        if(sr.isSuccess()){
            system.debug('Sharing rule inserted succesfully');
        }
        else {
            Database.Error err = sr.getErrors()[0];
            
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
               err.getMessage().contains('AccessLevel')){
                   
               }
            else{
                
            }
        }
        }
    }
     /*
    public static void deleteTrainerSharing(Trainer__c trainer){
        
        String accountId = trainer.Contracted_By__c;
        Account acc = [select id,Franchise_ID__c,OwnerId from Account where id = :accountId limit 1];
        List<User> users = [select id from User where Franchise_ID__c = :acc.Franchise_ID__c];
       	List<Trainer_Certification__c> trainerCerts = [select id from Trainer_Certification__c where Trainer__c =:trainer.Id ];
        List<Trainer_Certification__Share> tcshareRecs = [select id,ParentId, UserOrGroupId, AccessLevel, RowCause from Trainer_Certification__Share where ParentId IN :trainerCerts and RowCause= 'Manual' and UserOrGroupId IN :users];
        List<Trainer_Certification__Share> tcshareRecs2Update = new List<Trainer_Certification__Share>();
        for(Trainer_Certification__Share tcs:tcshareRecs){
            Trainer_Certification__Share tcs2Update = new Trainer_Certification__Share();
            tcs2Update.RowCause = 'Read'; 
            tcs2Update.Id = tcs.Id;
            tcshareRecs2Update.add(tcs);
        }
        system.debug('shrae recs to update -'+tcshareRecs2Update);
        database.update(tcshareRecs2Update,false);
        List<Trainer__Share> tshareRecs = [select id,ParentId, UserOrGroupId, AccessLevel, RowCause from Trainer__Share where ParentId =:trainer.Id and RowCause= 'Manual' and UserOrGroupId IN :users];
        system.debug('tshareRecs - '+tshareRecs);
        List<Trainer__Share> tshareRecs2Update = new List<Trainer__Share>();
        for(Trainer__Share tcs:tshareRecs){
            Trainer__Share tcs2Update = new Trainer__Share();
            tcs2Update.RowCause = 'Read'; 
            tcs2Update.Id = tcs.Id;
            tshareRecs2Update.add(tcs);
        }
        system.debug('trainer share recs to update -'+tshareRecs2Update);
        database.update(tshareRecs2Update,false);
        //delete(tshareRecs);
    }
    
    public static void deleteTrainerCertEventSharing(Trainer_Certification__c trainerCert){
        system.debug('oldtrainer - ' +trainerCert);
        system.debug(trainerCert.Trainer__c);
        system.debug('accccc' +trainerCert.Trainer__r.Contracted_By__c);
        String accountId = trainerCert.Trainer__r.Contracted_By__c;
        Account acc = [select id,Franchise_ID__c,OwnerId from Account where id = :accountId limit 1];
        List<User> users = [select id from User where Franchise_ID__c = :acc.Franchise_ID__c];
        List<Trainer_Certification__Share> tshareRecs = [select id,ParentId, UserOrGroupId, AccessLevel, RowCause from Trainer_Certification__Share where ParentId =:trainerCert.Id AND RowCause= 'Manual' and UserOrGroupId IN :users];
        system.debug('tshareRecs going to delete- '+tshareRecs);
        
        List<Trainer_Certification__Share> tcshareRecs2Update = new List<Trainer_Certification__Share>();
        for(Trainer_Certification__Share tcs:tshareRecs){
            Trainer_Certification__Share tcs2Update = new Trainer_Certification__Share();
            tcs2Update.RowCause = 'Read'; 
            tcs2Update.Id = tcs.Id;
            tcshareRecs2Update.add(tcs);
        }
        system.debug('shrae recs to update -'+tcshareRecs2Update);
        database.update(tcshareRecs2Update,false);
        //delete(tshareRecs);
    }
   
    public static void deleteAvailFranSharing(Available_Franchise__c availFran){
        String accountId = availFran.Franchise__c;
        Account acc = [select id,Franchise_ID__c,OwnerId from Account where id = :accountId limit 1];
        List<User> users = [select id from User where Franchise_ID__c = :acc.Franchise_ID__c];
        List<Available_Franchise__Share > afShareRecs = [select id,ParentId, UserOrGroupId, AccessLevel, RowCause from Available_Franchise__Share where ParentId =:availFran.Id AND RowCause= 'Manual' AND UserOrGroupId IN :users];
        system.debug('afShareRecs - '+afShareRecs);
        
        //delete(afShareRecs);
        List<Available_Franchise__Share> AFshareRecs2Update = new List<Available_Franchise__Share>();
        for(Available_Franchise__Share tcs:afShareRecs){
            Available_Franchise__Share tcs2Update = new Available_Franchise__Share();
            tcs2Update.RowCause = 'Read'; 
            tcs2Update.Id = tcs.Id;
            AFshareRecs2Update.add(tcs);
        }
        system.debug('Available Franchise shrae recs to update -'+AFshareRecs2Update);
        database.update(AFshareRecs2Update,false);
        String trainerId = availFran.Trainer__c;
        system.debug('uodated trainerId - '+trainerId);
        Trainer__c trainer = [select id ,Franchise_ID__c, Contracted_By__c from Trainer__c where id= :trainerId limit 1];
        List<Trainer__Share> tshareRecs = [select id,ParentId, UserOrGroupId, AccessLevel, RowCause from Trainer__Share where ParentId =:trainer.Id and RowCause= 'Manual' and UserOrGroupId IN :users];
        system.debug('tshareRecs - '+tshareRecs);
        List<Trainer__Share> tshareRecs2Update = new List<Trainer__Share>();
        for(Trainer__Share tcs:tshareRecs){
            Trainer__Share tcs2Update = new Trainer__Share();
            tcs2Update.RowCause = 'Read'; 
            tcs2Update.Id = tcs.Id;
            tshareRecs2Update.add(tcs);
        }
        system.debug('trainer share recs to update -'+tshareRecs2Update);
        database.update(tshareRecs2Update,false);
        List<Trainer_Certification__c> trainerCerts = [select id from Trainer_Certification__c where Trainer__c =:trainer.Id ];
        List<Trainer_Certification__Share> tcshareRecs = [select id,ParentId, UserOrGroupId, AccessLevel, RowCause from Trainer_Certification__Share where ParentId IN :trainerCerts and RowCause= 'Manual' and UserOrGroupId IN :users];
        List<Trainer_Certification__Share> tcshareRecs2Update = new List<Trainer_Certification__Share>();
        for(Trainer_Certification__Share tcs:tcshareRecs){
            Trainer_Certification__Share tcs2Update = new Trainer_Certification__Share();
            tcs2Update.RowCause = 'Read'; 
            tcs2Update.Id = tcs.Id;
            tcshareRecs2Update.add(tcs);
        }
        system.debug('shrae recs to update -'+tcshareRecs2Update);
        database.update(tcshareRecs2Update,false);
    }*/
    
}