/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : JSONKeyExtractor
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

public with sharing class JSONKeyExtractor {

    public class ExtractRequest {
        @InvocableVariable(required=true)
        public String jsonString;

        @InvocableVariable(required=true)
        public String key;
    }

    public class ExtractResponse {
        @InvocableVariable
        public String value;
    }

    @InvocableMethod(label='Extract Key from JSON' description='Extracts the value associated with a key from a JSON string, supporting nested structures')
    public static List<ExtractResponse> extractKey(List<ExtractRequest> requests) {
        List<ExtractResponse> responses = new List<ExtractResponse>();

        for (ExtractRequest req : requests) {
            ExtractResponse res = new ExtractResponse();
            try {
                res.value = extractValue(req.jsonString, req.key);
            } catch (Exception e) {
                res.value = null;
            }
            responses.add(res);
        }

        return responses;
    }

    private static String extractValue(String jsonString, String key) {
        Object jsonObj = (Object) JSON.deserializeUntyped(jsonString);
        return findKey(jsonObj, key);
    }

    private static String findKey(Object node, String key) {
        if (node instanceof Map<String, Object>) {
            Map<String, Object> mapNode = (Map<String, Object>) node;
            if (mapNode.containsKey(key)) {
                Object value = mapNode.get(key);
                return value != null ? String.valueOf(value) : null;
            }
            for (Object child : mapNode.values()) {
                String result = findKey(child, key);
                if (result != null) {
                    return result;
                }
            }
        } else if (node instanceof List<Object>) {
            List<Object> listNode = (List<Object>) node;
            for (Object child : listNode) {
                String result = findKey(child, key);
                if (result != null) {
                    return result;
                }
            }
        }
        return null;
    }
}