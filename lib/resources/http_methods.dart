import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpMethods {
  static Future<void> sendFCMMessage(
      String receiverToken, String title, String body) async {
    http.post(
        Uri.parse(
            "https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer AAAA8N_Rcdo:APA91bE7LV5vOH8rEYn7V257bkbrN95GVSMMeUIxSQmg0d69BH5ytjqHpkHSbMWevxF9PlGcxQO0k2hB6U0r2TRdao40WCpa5l2Td4Y3imeW9LjKEvLX38VTB73L0z5dvluE1dVFlsFH'
        },
        body: jsonEncode(<String, dynamic>{
          "to": receiverToken,
          "data": {},
          "notification": {"title": title, "body": body}
        })).then((value) {
          print(value.body);
        });
  }
}
