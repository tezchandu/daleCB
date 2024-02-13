global class FranchiseReportSchedule implements Schedulable {
	global void execute(SchedulableContext SC) {
		FranchiseReportBatch myBatch = new FranchiseReportBatch();
		ID bId = Database.executeBatch(myBatch,5);
	}
}