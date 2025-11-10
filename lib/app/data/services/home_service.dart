import 'package:get/get.dart';

import '../../ui/utils/logget.dart';
import 'base_service.dart';

class HomeService extends BaseService {
  Future<Response> getStory() async {
    try {
      final response = await get(
        '/photos/random',
        query: {'count': '10'},
      );

      return response;
    } catch (e) {
      Log.error('Error fetching story: ', e);
      return Response(
        statusCode: 500,
        statusText: 'Error fetching story',
        body: {'error': e.toString()},
      );
    }
  }

  Future<Response> getPosts(int page) async {
    try {
      final response = await get(
        '/search/photos',
        query: {
          'query': 'nature',
          'per_page': '20',
          'page': page.toString(),
        },
      );

      return response;
    } catch (e) {
      Log.error('Error fetching posts: ', e);
      return Response(
        statusCode: 500,
        statusText: 'Error fetching posts',
        body: {'error': e.toString()},
      );
    }
  }
}
