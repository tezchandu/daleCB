trigger ProgramCodeUniqueTrigger on Program__c (before insert, before update) {

  if (Trigger.isBefore && Trigger.isInsert)
    {
    Set<String> programCodes = new Set<String>();
    Set<String> programNames = new Set<String>();
    for (Program__c program : Trigger.new) {
        if (program.Name != null) {
           // programCodes.add(program.Name); 
        }
    }
    for (Program__c program : Trigger.new) {
        if (program.Franchise_Account__c != null) {
            programCodes.add(program.Franchise_Account__c); 
            //programNames.add(program.Name);
        }
    }
    system.debug(programCodes);
    // Query existing programs with matching program codes
    List<Program__c> existingPrograms = [SELECT Id, Name FROM Program__c WHERE Franchise_Account__c IN :programCodes];
    for(Program__c program :existingPrograms){
        programNames.add(program.name);
}
    // Throw an error if duplicates exist
    if (!existingPrograms.isEmpty()) {
        for (Program__c program : Trigger.new) {
            if (programNames.contains(program.Name)) {
                program.Name.addError('Duplicate program code found...');
            }
        }
    }
}

    // Process sharing rules 

if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
    	FranchiseSharingHandler.handleProgram(trigger.new);
    }     
    
}