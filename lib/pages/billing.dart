import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whose_doc/functions/api_manager.dart';
import 'package:whose_doc/functions/error_handles.dart';
import 'package:whose_doc/variables/routes.dart';

//import 'dart:io';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => new _PaymentState();
}

class _PaymentState extends State<Payment> {
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WebView(
        initialUrl: initialURL,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) =>
            _webViewController = webViewController,
        onPageFinished: (String url) {
          if (url == initialURL) {
            redirectToStripe(_webViewController);
          }
        },
        navigationDelegate: (NavigationRequest request) async {
          if (request.url.startsWith(webTemp + '/successful?session_id=')) {
            await getSuccessPayment(context);
            Future.delayed(Duration(seconds: 4), () {
              Navigator.of(context).pop();
              Navigator.of(context).popAndPushNamed('/cartPage');
            });
          } else {
            errorDialog(context, 'Payment not successful');
            Navigator.of(context).pop('cancel');
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  String get initialURL =>
      'data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHtmlPage))}';
}

const kStripeHtmlPage = '''
<!DOCTYPE html>
<html>
<script src="https://js.stripe.com/v3/"></script>
<head><title>Stripe checkout</title></head>
<body>
</body>
</html>
''';
