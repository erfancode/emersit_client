
import 'package:http/http.dart' as http;

class Network {

    static const String BASE_URL = "https://emersit.herokuapp.com/api/";
    static const String TOKEN_KEY = 'token';
    static const String USER_KEY = 'user';
    static const String AGENT_KEY = 'agent';

    static Future<http.Response> login(String username, String password) async {

        return await http.post(BASE_URL + "user/login",
                body: {"password": password, "username": username});
    }

    static Future<http.Response> logout(String token) async {

        return await http.get(BASE_URL + "user/logout",
            headers: {TOKEN_KEY: token},);
    }

    static Future<http.Response> getForms(String token) async {

        return await http.get(BASE_URL + "form/getForms",
            headers: {TOKEN_KEY: token},
        );
    }

    static Future<http.Response> submitForm(String token, String submittedForm) async {
        
        return await http.post(BASE_URL + "submit/submitForm",
                headers: {TOKEN_KEY: token, 'Content-Type' : 'application/json'},
                body: submittedForm);
    }

    static Future<http.Response> getSubmittedForms(String username, String token) async {
      return await http.get(BASE_URL + "submit/getSubmittedFormByUsername?username=$username",
          headers: {TOKEN_KEY: token},
      );
    }

    static Future<http.Response> getFormReport(String formId, String token) async{

        return await http.get(BASE_URL + "submit/getSubmittedFormByFormId?formId=$formId",
            headers: {TOKEN_KEY: token},
        );
    }

    static Future<http.Response> getLocations(String token) async{

        return await http.get(BASE_URL + "location/getLocations",
            headers: {TOKEN_KEY: token},
        );
    }
}