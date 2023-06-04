import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configMaps.dart';

//hichembba97@gmail.com
Future<void> sendNotificationToDriver(String driverFCMToken) async {
  final String serverKey =
      'AAAAW8F1pXY:APA91bFNUaGTLCLTcCTQXFkSzAyTm8KhHl3fA--9seTbxtwQOchKg-YcBjmfKXOw33rbaWuIqWBfFGweDfZX-D3VgBGp27FcQfUq2E-P7OdCmBx6tDdMHSR8RdMKdYKZAUj7Ri88lYwQ'; // Replace with your FCM server key
  final String token = driverFCMToken; // FCM token of the driver

  final String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

  final Map<String, dynamic> notification = {
    'notification': {
      'title': 'New Ride Request',
      'body': 'A new ride request is available!',
    },
    'data': {
      // Add any additional data you want to send
      "driver_id": "waiting",
      "payment_method": "cash",
      "created_at": DateTime.now().toString(),
      "rider_name": userCurrentInfo?.username,
      "rider_phone": userCurrentInfo?.phone,
    },
    'to': token,
  };

  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final response = await http.post(
    Uri.parse(fcmEndpoint),
    headers: headers,
    body: jsonEncode(notification),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Error sending notification');
  }
}
