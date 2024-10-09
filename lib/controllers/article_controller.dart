import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/article_model.dart';

class ArticleController extends GetxController {
  final Dio _dio = Dio();
  final String apiUrl = 'https://my-json-server.typicode.com/Fallid/codelab-api/db';
  var isLoading = false.obs;
  var articles = Rx<Welcome?>(null); // Use the Welcome model

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        articles.value = Welcome.fromJson(response.data); // Parse the JSON response into Welcome object
      } else {
        // Handle any other status codes (e.g., 404, 500)
        Get.snackbar(
          'Error',
          'Failed to fetch articles: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch articles: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
