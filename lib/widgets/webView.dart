
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:partypeopleindividual/widgets/payment_response_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../individual_subscription/controller/subscription_controller.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  WebViewContainer( {required this.url});
  @override
  createState() => _WebViewContainerState();
}
class _WebViewContainerState extends State<WebViewContainer> {
  final subController = Get.find<SubscriptionController>();
  late final WebViewController _controller;
 // var _url;
 // final _key = UniqueKey();


 // _WebViewContainerState(this._url);

  @override
  void initState() {
    super.initState();
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');



            String finUrl =url;
           // https://app.partypeople.in/easebuzz/response.php?payment_status=0&order_id=PPT120923122610&amount=10.0
           if(finUrl.contains('https://app.partypeople.in/easebuzz/response.php')) {
             var param = finUrl.split('=');
             String paymentStatus = '';
             String orderId = '';
             if (param[1].contains('1')) {
               paymentStatus = '1';
             }
             else {
               paymentStatus = '0';
             }

             var splitOrder = param[2].split('&');
             orderId = splitOrder[0];

               await subController.updateSubsPaymentStatus(subsId: orderId, paymentStatus: paymentStatus,);
               Get.to(  PaymentResponseView(isSuccess: paymentStatus,orderId: orderId,amount: param[3] ,));
           }

          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('upi://pay')) {
              UrlLauncher.launchUrl(Uri.parse(request.url));
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');},
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url),
      );

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: WebViewWidget(controller: _controller, ),),
          ],
        ));
  }
}