public class CaseContactInfo {
    public String FirstName;
    public String LastName;
    public String EmailAddress;

    public CaseContactInfo(String fullName, String emailAddress) {
        String fromName = fullName.trim();
        Integer spaceIndex = fullName.indexOf(' ');
        Boolean hasSpace = spaceIndex > 0;
        this.LastName = hasSpace ? fromName.substring(spaceIndex + 1) : fromName;
        this.FirstName =  hasSpace ? fromName.substring(0, spaceIndex) : '';
        this.EmailAddress = emailAddress;
    }
}