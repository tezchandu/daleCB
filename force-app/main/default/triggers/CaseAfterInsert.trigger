trigger CaseAfterInsert on Case (after insert) {
  System.debug('CaseAfterInsert');
  CaseAfterTriggerHandler.handleTrigger(trigger.newMap);
}