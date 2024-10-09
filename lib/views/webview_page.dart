import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import '../controllers/WebViewLoadingController.dart';

class WebViewPage extends StatelessWidget {
  final String url;
  WebViewPage({Key? key, required this.url}) : super(key: key);

  final loadingController = Get.put(WebViewLoadingController());

  @override
  Widget build(BuildContext context) {
    final webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            loadingController.setLoading(true);
          },
          onPageFinished: (String url) {
            loadingController.setLoading(false);
          },
          onWebResourceError: (WebResourceError error) {
            Get.snackbar(
              'Error',
              'Failed to load page: ${error.description}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Artikel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              webViewController.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: webViewController,
          ),
          Obx(
            () => loadingController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
