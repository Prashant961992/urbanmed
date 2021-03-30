import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentGateway extends GetxController {
  Razorpay razorpay;

  @override
  void onInit() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handleSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handleError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    super.onInit();
  }

  void handleError(PaymentFailureResponse paymentFailureResponse) {
    Get.snackbar('Error Occured', paymentFailureResponse.message);
  }

  void handleSuccess(PaymentSuccessResponse paymentSuccessResponse) {
    Get.snackbar('Error Occured', paymentSuccessResponse.orderId);
  }

  void handleExternalWallet(ExternalWalletResponse externalWalletResponse) {
    Get.snackbar('Error Occured', externalWalletResponse.walletName);
  }

  void dispatchPayment(double amount, String name, int contact, String email,
      String wallet) {
    var options = {
      'key': 'rzp_test_9vrOaXUeelOwn1',
      'amount': amount,
      'name': name,
      'description': 'Payment',
      'prefil': {'contact': contact, 'email': email},
      'external':
      {
        'wallet': [wallet]
      }
    };
    try {
      razorpay.open(options);
    }
    catch (e) {
      print(e.toString());
    }
  }
}