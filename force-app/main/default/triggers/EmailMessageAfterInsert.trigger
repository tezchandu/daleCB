trigger EmailMessageAfterInsert on EmailMessage (after insert) {
  CaseContactHandler.handleEmailTrigger(trigger.newMap);
}