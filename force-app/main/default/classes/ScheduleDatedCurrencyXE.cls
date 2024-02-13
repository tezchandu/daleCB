global class ScheduleDatedCurrencyXE implements Schedulable {
    global  void execute(SchedulableContext sc){
        DatedCurrencyXE dce = new DatedCurrencyXE();
        DatedCurrencyXE.getAccessToken();
    }		
}