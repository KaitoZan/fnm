import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../config/environment.dart';

class BaseService extends GetConnect {
  @override
  void onInit() {
    allowAutoSignedCert = true;
    httpClient.baseUrl = Environment.apiUrl;
    httpClient.timeout = const Duration(seconds: 30);

    httpClient.addRequestModifier<void>((request) {
      request.headers['Authorization'] = 'Client-ID ${Environment.accessKey}';

      return request;
    });

    httpClient.addResponseModifier((request, response) {
      //   debugPrint('Response Status: ${response.statusCode}');
      //   debugPrint('Response Body: ${response.body}');
      return response;
    });

    super.onInit();
  }
}
