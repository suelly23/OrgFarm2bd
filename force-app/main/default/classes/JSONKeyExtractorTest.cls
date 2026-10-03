/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : JSONKeyExtractorTest
 * Author          : <YourName>
 * Created Date    : Apr 10, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Apr 10, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Apr 10, 2026  │ <YourName>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

@isTest
private class JSONKeyExtractorTest {

    @isTest
    static void testExtractSimpleKey() {
        JSONKeyExtractor.ExtractRequest req = new JSONKeyExtractor.ExtractRequest();
        req.jsonString = '{ "name": "Nick", "age": 37 }';
        req.key = 'name';

        List<JSONKeyExtractor.ExtractResponse> result =
            JSONKeyExtractor.extractKey(new List<JSONKeyExtractor.ExtractRequest>{ req });

        System.assertEquals(1, result.size());
        System.assertEquals('Nick', result[0].value);
    }

    @isTest
    static void testExtractNestedKey() {
        JSONKeyExtractor.ExtractRequest req = new JSONKeyExtractor.ExtractRequest();
        req.jsonString = '{ "user": { "profile": { "email": "test@example.com" } } }';
        req.key = 'email';

        List<JSONKeyExtractor.ExtractResponse> result =
            JSONKeyExtractor.extractKey(new List<JSONKeyExtractor.ExtractRequest>{ req });

        System.assertEquals('test@example.com', result[0].value);
    }

    @isTest
    static void testKeyNotFound() {
        JSONKeyExtractor.ExtractRequest req = new JSONKeyExtractor.ExtractRequest();
        req.jsonString = '{ "foo": "bar" }';
        req.key = 'missing';

        List<JSONKeyExtractor.ExtractResponse> result =
            JSONKeyExtractor.extractKey(new List<JSONKeyExtractor.ExtractRequest>{ req });

        System.assertEquals(null, result[0].value);
    }

    @isTest
    static void testInvalidJson() {
        JSONKeyExtractor.ExtractRequest req = new JSONKeyExtractor.ExtractRequest();
        req.jsonString = '{ invalid json }';
        req.key = 'anything';

        List<JSONKeyExtractor.ExtractResponse> result =
            JSONKeyExtractor.extractKey(new List<JSONKeyExtractor.ExtractRequest>{ req });

        System.assertEquals(null, result[0].value);
    }
}