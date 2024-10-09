import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/article_controller.dart';
import 'webview_page.dart';

class ArticleView extends StatelessWidget {
  final ArticleController controller = Get.put(ArticleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black45,
        actions: [
          IconButton(
            icon: const Icon(Icons.web, color: Colors.white),
            onPressed: () {
              Get.to(() => WebViewPage(url: 'https://www.arknights.global/'));
            },
          ),
        ],
      ),
      backgroundColor: Colors.black45,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (controller.articles.value == null) {
          return const Center(child: Text('Artikel tidak ditemukan', style: TextStyle(color: Colors.white)));
        }

        return ListView.builder(
          itemCount: controller.articles.value!.articles.length,
          itemBuilder: (context, index) {
            final article = controller.articles.value!.articles[index];
            return Card(
              color: Colors.grey[900],
              margin: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Get.to(() => WebViewPage(url: article.url));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.urlToImage.isNotEmpty)
                      Image.network(
                        article.urlToImage,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 300,
                            child: Center(
                              child: Icon(Icons.error, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White text for dark mode
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            article.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'By ${article.author}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white60,
                                ),
                              ),
                              Text(
                                article.publishedAt.toString().split(' ')[0],
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[850],
        onPressed: controller.fetchArticles,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
