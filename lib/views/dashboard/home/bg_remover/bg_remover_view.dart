import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneytracker/utilis/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../../../widget/custom_appber.dart';

class BgRemoverView extends StatefulWidget {
  const BgRemoverView({super.key});

  @override
  State<BgRemoverView> createState() => _BgRemoverViewState();
}

class _BgRemoverViewState extends State<BgRemoverView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
     final PlatformWebViewControllerCreationParams params = const PlatformWebViewControllerCreationParams();

     final WebViewController controller =
      WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              setState(() => _isLoading = true);
            },
            onPageFinished: (url) {
              setState(() => _isLoading = false);
            },
            onWebResourceError: (error) {
              debugPrint('WebView error: ${error.description}');
            },
          ),
        )
       ..loadRequest(
          Uri.parse('https://www.remove.bg/upload'),
      );

      // 🔹 Android-specific: handle <input type="file">
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);

      final AndroidWebViewController androidController =
          controller.platform as AndroidWebViewController;

      androidController.setOnShowFileSelector(
        (FileSelectorParams params) async {
          // You can use camera/gallery; here simple image picker
          final ImagePicker picker = ImagePicker();

          XFile? picked;
          if (params.acceptTypes.any((t) => t.contains('image'))) {
            picked = await picker.pickImage(source: ImageSource.gallery);
          } else {
            picked = await picker.pickImage(source: ImageSource.gallery);
          }

          if (picked == null) {
            // user cancelled
            return <String>[];
          }

          return <String>[picked.path];
        },
      );
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: ProjectColor.whiteColor,
       restorationId: "Bg_22",
       appBar: CustomAppBer(title: "Remove Image Background",),
       body: SafeArea(
        child:  Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      ),
    );
  }
}
