import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/utils/custom_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentFine extends StatefulWidget {
  final String? message;
  final String url;
  final String? reason;
  final void Function()? onSuccess;

  const PaymentFine({
    Key? key,
    required this.url,
    this.onSuccess,
    this.message,
    this.reason,
  }) : super(key: key);

  @override
  State<PaymentFine> createState() => _PaymentFineState();
}

class _PaymentFineState extends State<PaymentFine> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasShownError = false; // Prevent duplicate error messages

  // Use the actual URL from your backend/Stripe success redirect
  // final String successUrlPattern = 'https://chasethecashsa.com/status=success';
  final String successUrlPattern = "waysirenthub.it";
  final String cancelUrlPattern = "cancel";
  // Professional SnackBar helper methods
  void _showSuccessSnackBar() {
    AppSnackbar.show(
      context,
      title: "",
      message: "Payment Successful!\nYour payment has been sucessfully.",
      type: SnackType.success,
    );
  }

  void _showCancelledSnackBar() {
    AppSnackbar.show(
      title: "",
      message: 'Payment Cancelled\nYou can try again anytime',
      context,
      type: SnackType.error,
    );
  }

  @override
  void initState() {
    super.initState();
    print(widget.url);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                isLoading = true;
                hasShownError = false;
              });
            }
          },
          onPageFinished: (url) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onWebResourceError: (error) {
            print("WebView error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            print("Navigation: ${request.url}");

            // ✅ Detect PayFast success
            if (request.url.contains(successUrlPattern)) {
              _showSuccessSnackBar();
              widget.onSuccess?.call();
              Navigator.of(context).pop(true);
              context.go(AppRoute.homeCustomer);
              return NavigationDecision.prevent;
            }

            // ✅ Detect PayFast cancel
            if (request.url.contains(cancelUrlPattern)) {
              _showCancelledSnackBar();
              Navigator.of(context).pop(false);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.green),
            SizedBox(width: 12),
            Text(
              'Secure Payment',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black54),
          onPressed: () {
            // Don't show cancellation message if user just closes without starting payment
            if (!isLoading) {
              _showCancelledSnackBar();
            }
            Navigator.of(context).pop(false);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black54),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isLoading)
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Loading Payment Gateway...',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please wait while we connect securely',
                        style: TextStyle(color: Colors.black38, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
