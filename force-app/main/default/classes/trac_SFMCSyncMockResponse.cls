/**
 * trac_SFMCSyncMockResponse
 * @description
 *
 * @author Zi Zhang, Traction on Demand
 * @date 6/28/2019
 */

@IsTest
global class  trac_SFMCSyncMockResponse implements HttpCalloutMock{
    public Boolean isAuth;
    public Boolean isError;
    public Boolean doException;

    public trac_SFMCSyncMockResponse(Boolean isAuth, Boolean isError, Boolean doException) {
        this.isAuth = isAuth;
        this.isError = isError;
        this.doException = doException;
    }

    global HttpResponse respond(HttpRequest req) {
        String endpoint = req.getEndpoint();
        Integer statusCode = 200;
        String respBody = '{success}';
        HttpResponse res = new HttpResponse();

        if(endpoint.contains('SFMC_Auth')) {
            respBody = '{"access_token": "123"}';
        }

        if(isAuth && isError && endpoint.contains('SFMC_Auth')) {
            statusCode = 400;
            respBody = '';
        } else if(isAuth && !isError && endpoint.contains('SFMC_Auth')) {
            respBody = '{"access_token": "123"}';
        } else if(isAuth && doException && endpoint.contains('SFMC_Auth')) {
            throw new MockException('Test Mock Auth Exception');
        }else if(doException) {
            throw new MockException('Test Mock Sync Exception');
        }


        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(statusCode);
        res.setBody(respBody);


        return res;
    }

    public class MockException extends Exception {}
}