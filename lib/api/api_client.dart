import 'dart:convert';
import 'dart:io';
import 'package:stackfood_multivendor_restaurant/api/api_checker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:stackfood_multivendor_restaurant/common/models/error_response.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static const String noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String? token;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);
    debugPrint('Token: $token');
    updateHeader(token, sharedPreferences.getString(AppConstants.languageCode));
  }

  void updateHeader(String? token, String? languageCode) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept' : 'application/json',
      AppConstants.localizationKey: languageCode ?? AppConstants.languages[0].languageCode!,
      'Authorization': 'Bearer $token'
    };
  }

  Future<Response> getData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers, bool handleError = true}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      http.Response response = await http.get(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri, handleError);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String>? headers, bool handleError = true}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $headers \nMain Header: $_mainHeaders');
      debugPrint('====> API Body: $body');
      http.Response response = await http.post(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri, handleError);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(String uri, Map<String, String> body, List<MultipartBody> multipartBody, List<MultipartDocument> otherFile, {Map<String, String>? headers, bool handleError = true}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body with ${multipartBody.length} and multipart ${otherFile.length}');
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(appBaseUrl+uri));
      request.headers.addAll(headers ?? _mainHeaders);
      for(MultipartBody multipart in multipartBody) {
        if(multipart.file != null) {
          if(foundation.kIsWeb) {
            Uint8List list = await multipart.file!.readAsBytes();
            http.MultipartFile part = http.MultipartFile(
              multipart.key, multipart.file!.readAsBytes().asStream(), list.length,
              filename: basename(multipart.file!.path), contentType: MediaType('image', 'jpg'),
            );
            request.files.add(part);
          }else {
            File file = File(multipart.file!.path);
            request.files.add(http.MultipartFile(
              multipart.key, file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last,
            ));
          }
        }
      }

      if(otherFile.isNotEmpty){
        for(MultipartDocument file in otherFile){
          File other = File(file.file!.files.single.path!);
          Uint8List list0 = await other.readAsBytes();
          var part = http.MultipartFile(file.key, other.readAsBytes().asStream(), list0.length, filename: basename(other.path));
          request.files.add(part);
        }
      }

      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(await request.send());
      return handleResponse(response, uri, handleError);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body, {Map<String, String>? headers, bool handleError = true}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      http.Response response = await http.put(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri, handleError);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri, {Map<String, String>? headers, bool handleError = true}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      http.Response response = await http.delete(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri, handleError);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(http.Response response, String uri, bool handleError) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    }catch(_) {}
    Response response0 = Response(
      body: body ?? response.body, bodyString: response.body.toString(),
      headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase,
    );
    if(response0.statusCode != 200 && response0.body != null && response0.body is !String) {
      if(response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: errorResponse.errors![0].message);
      }else if(response0.body.toString().startsWith('{message')) {
        response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: response0.body['message']);
      }else if(response0.body.toString().startsWith('{errors: {message:')){
        response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: response0.body['errors']['message']);
      }
    }else if(response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint('====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    if(handleError) {
      if(response0.statusCode == 200) {
        return response0;
      } else {
        ApiChecker.checkApi(response0);
        return const Response();
      }
    } else {
      return response0;
    }
  }

}


class MultipartBody {
  String key;
  XFile? file;

  MultipartBody(this.key, this.file);
}

class MultipartDocument {
  String key;
  FilePickerResult? file;
  MultipartDocument(this.key, this.file);
}