/**
 * @description       : REST API for getting the toy's details
 * @author            : chhavi.arya@orix.com.au
 * @group             : 
 * @last modified on  : 08-13-2020
 * @last modified by  : chhavi.arya@orix.com.au
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   08-12-2020   chhavi2684@gmail.com   Initial Version
**/
@RestResource(urlMapping = '/ToyDetail/')
global class ClassToyDetailREST {
    /* Response Inner Class */
    global class ResponseWrapper {
       public List<ToyDetail> toyDetailResponse;
       public Integer statusCode;
    }
	/* Details of the toy to be returned */
    global class ToyDetail{
        String status;
        String toyName;
        String toyDescription;
        Decimal toyPrice;
        Boolean isAvailable;
    }
    /* Request Inner Class */
    public class RequestWrapper {
       public List<String> toyNames;
    }
	/* POST function to get the details of toys */
    @HttpPost
    global static ResponseWrapper getToyDetails() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        ResponseWrapper restResponse = new ResponseWrapper();
        restResponse.toyDetailResponse = new List<ToyDetail>();
        Map<String, Toys__c> toyNameDetailMap = new Map<String, Toys__c>();// stores the mapping of toy name and toy details
        try{
        	//Deserialize the request body : get the toy names for which details are to be returned
        	RequestWrapper requestObj = (RequestWrapper) System.JSON.deserialize(requestString, RequestWrapper.class);
        	List<Toys__c> toysFound = [SELECT Id, Name, Description__c, Is_Available__c, Price__c FROM Toys__c WHERE Name IN :requestObj.toyNames];
            // If no toys are found for the request body return 400
            if(toysFound == null || toysFound.size() == 0){
                restResponse.statusCode = 400;
                return restResponse;
            }else{
                restResponse.statusCode = 200;
                for(Toys__c toyDetail : toysFound){
                    toyNameDetailMap.put(toyDetail.Name, toyDetail);
                }
            }
            for(String toyName : requestObj.toyNames){
                Toys__c toyDetail = toyNameDetailMap.get(toyName);
                if(toyDetail != null){
                    ToyDetail newToyDetailResponse = new ToyDetail();
                    newToyDetailResponse.status = 'Match found';
                    newToyDetailResponse.toyName = toyDetail.Name;
                    newToyDetailResponse.toyDescription = toyDetail.Description__c;
                    newToyDetailResponse.toyPrice = toyDetail.Price__c;
                    newToyDetailResponse.isAvailable = toyDetail.Is_Available__c;
                    restResponse.toyDetailResponse.add(newToyDetailResponse);
                }else{
                    ToyDetail newToyDetailResponse = new ToyDetail();
                    newToyDetailResponse.status = 'No Toy Match found';
                    restResponse.toyDetailResponse.add(newToyDetailResponse);
                }
            }
            return restResponse;
        }Catch(Exception ex){ // catch exception and return 400
            ResponseWrapper restErrorResponse = new ResponseWrapper();
            restErrorResponse.statusCode = 400;
            return restErrorResponse;
        }
    }
}