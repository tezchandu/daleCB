public class DatedConversionRateCollection {
    
    public List<Record> records;

    public DatedConversionRateCollection() {
        records = new List<Record>();
    }

    public void addRecord(String type,  String isoCode, string referenceId,  Decimal conversionRate, Date startDate) {
        Record newRecord = new Record();
        newRecord.attributes = new Attributes(type, referenceId);
        newRecord.IsoCode = isoCode;
        newRecord.ConversionRate = conversionRate;
        newRecord.StartDate = startDate;
        
        records.add(newRecord);
    }

    public class Record {
        public Attributes attributes;
        public String IsoCode;
        public Decimal ConversionRate;
        public Date StartDate;
    }

    public class Attributes {
        public String type;
        public String referenceId;

        public Attributes(String type, String referenceId) {
            this.type = type;
            this.referenceId = referenceId;
        }
    }}