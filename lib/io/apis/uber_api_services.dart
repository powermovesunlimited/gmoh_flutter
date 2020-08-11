import 'package:gmoh_app/util/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {
  final String _baseUrl ='https://sandbox-api.uber.com';





  Future<dynamic> get(String url, headers) async {
    var responseJson;

    var headers = {
      'Authorization': 'Bearer <JA.VUNmGAAAAAAAEgASAAAABwAIAAwAAAAAAAAAEgAAAAAAAAH4AAAAFAAAAAAADgAQAAQAAAAIAAwAAAAOAAAAzAAAABwAAAAEAAAAEAAAACxNBuKGLMyvfHJJu3bA5o-nAAAAewFwfb4--RQfP3m6UWZmbueFVXAFH-c5r5AFDeemSUBzoG3zcClHE7plz9fz6MohZm0Erlx0j6h_MZFJRgteNFgMuMe1b7a7SjDJn0B_CDyFlJVds6XvXpYHaCIr2-Wc47H2VjyIBtDNTsVwlMrwT59XAofZ6SoSBXNiyjudNt5RHSTSI_PXubmAPO2Y3Dhs52xSmODE7PrR131zn2I9QifXmYK0YP4ADAAAAF8TwLvYUvpykEPrdCQAAABiMGQ4NTgwMy0zOGEwLTQyYjMtODA2ZS03YTRjZjhlMTk2ZWU>',
      'Accept-Language': 'en_US',
      'Content-Type': 'application/json'
    };



    try {
      final response = await http.get(_baseUrl + url, headers: headers);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }tr

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}