public with sharing class OpportunityPDFGenerator {

    @InvocableMethod(label='Generate Opportunity PDF' description='Creates a PDF from an Opportunity custom field and attaches it to the Opportunity record')
    public static List<String> generatePDF(List<PDFRequest> requests) {

        List<String> results = new List<String>();

        for (PDFRequest req : requests) {

            // Query Opportunity including your custom field
            Opportunity opp = [
                SELECT Id, Name, Opportunity_Preview__c
                FROM Opportunity
                WHERE Id = :req.opportunityId
                LIMIT 1
            ];

            // Build the HTML for PDF (using custom field content)
            String htmlBody = opp.Opportunity_Preview__c != null ? opp.Opportunity_Preview__c : '<html><body>No PDF content available</body></html>';
            Blob pdfBlob = Blob.toPdf(htmlBody);

            // Create the PDF file
            ContentVersion cv = new ContentVersion();
            cv.Title = opp.Name + ' Gift Summary';      // Friendly title
            cv.PathOnClient = opp.Name + '_GiftSummary.pdf';
            cv.VersionData = pdfBlob;
            cv.IsMajorVersion = true;
            cv.FirstPublishLocationId = req.accountId;  // Required but won't be the final location

            insert cv;

            // Now link the file to the Opportunity record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
            cdl.LinkedEntityId = req.opportunityId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';

            insert cdl;

            results.add('PDF attached to Opportunity: ' + opp.Id);
        }

        return results;
    }

    // Invocable wrapper class
    public class PDFRequest {
        @InvocableVariable(required=true label='Account ID')
        public Id accountId;

        @InvocableVariable(required=true label='Opportunity ID')
        public Id opportunityId;
    }
}