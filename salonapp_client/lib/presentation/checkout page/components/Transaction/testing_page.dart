import 'package:flutter/material.dart';
//import 'package:flutter_paystack/flutter_paystack.dart';

class TestingPage extends StatefulWidget {
  final double amount;
  final String ref;
  final String currency;
  final String email;
  const TestingPage(
      {super.key,
      required this.amount,
      required this.ref,
      required this.currency,
      required this.email});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  final double _amount = 250;
  final String _currency = 'GHS';
  final String _email = 'kofiktechgh@gmail.com';

  //final plugin = PaystackPlugin();
  String message = '';

  // @override
  // void initState() {
  //   plugin.initialize(publicKey: ApiKeys.publicKey);
  //   super.initState();
  // }

  // void makePayment() async {
  //   int price = widget.amount.toInt() * 100;
  //   Charge charge = Charge()
  //     ..amount = price
  //     ..reference = 'ref: ${DateTime.now()}'
  //     ..email = _email
  //     ..currency = _currency;

  //   CheckoutResponse response = await plugin.checkout(
  //     context,
  //     charge: charge,
  //     method: CheckoutMethod.card,
  //   );
  //   if (response.status == true) {
  //     message = 'Payment Sucessfully made with ${response.reference}';
  //     // Get.to(() => SucessPage(message: message));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.deepOrange,
                onPressed: () {},
                child: Text("Pay"),
              ),
              /*
            FutureBuilder(
              future: initializeTransaction(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  final url = snapshot.data;
                  return WebViewWidget(
                    controller: WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..setBackgroundColor(const Color(0x00000000))
                      ..setNavigationDelegate(
                        NavigationDelegate(
                          onProgress: (int progress) {
                            // Update loading bar.
                          },
                          onPageStarted: (String url) {},
                          onPageFinished: (String url) {},
                          onWebResourceError: (WebResourceError error) {},
                          onNavigationRequest: (NavigationRequest request) {
                            if (request.url
                                .startsWith('https://www.youtube.com/')) {
                              return NavigationDecision.prevent;
                            }
                            return NavigationDecision.navigate;
                          },
                        ),
                      )
                      ..loadRequest(
                        Uri.parse(url!),
                      ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          */
            ],
          ),
        ),
      ),
      /* Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'all fields are required';
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _referenceController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'all fields are required';
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Reference',
                  hintText: 'Enter reference',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'all fields are required';
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ButtonStyle(),
                onPressed: () {},
                child: const Text("Proceed to make payment"),
              ),
            ],
          ),
        ),
      ),*/
    );
  }

  initializeTransaction() {}
}
