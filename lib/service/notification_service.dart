import 'dart:io';

import 'package:chegg_no_question_notifier/exceptions/service_exceptions.dart';
import 'package:chegg_no_question_notifier/model/availability_status.dart';
import 'package:chegg_no_question_notifier/model/chegg_profile.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationService {
  final String username;
  final String password;

  const NotificationService({required this.username, required this.password});

  AvailabilityStatus parseAvailabilityStatus(String responseBody) {
    final parseJsonMap = jsonDecode(responseBody);
    return AvailabilityStatus.fromJson(parseJsonMap);
  }

  Future<AvailabilityStatus> fetchQuestionStatus() async {
    // constructing the CheggProfile object
    final profile = CheggProfile(username: username, password: password);

    final response = await http.post(
        Uri.parse('https://chegg-notifier.serveo.net/api/status'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin": "*"
        },
        body: jsonEncode(profile.toJson()));

    print(response.statusCode);

    if (response.statusCode == 200) {
      return parseAvailabilityStatus(response.body);
    } else if (response.statusCode == 500 || response.statusCode == 502) {
      throw const ServerException('Internal Server Error');
    } else if (response.statusCode == 400) {
      throw const BadRequestException('User Forbidden');
    } else if (response.statusCode == 404) {
      throw const ClientException('Not connected to internet');
    } else {
      throw const HttpException('Unknown exception found');
    }
  }
}
