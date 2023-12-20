
# flutter_pay_upi (iOS version coming soon)

<p align="center">
  <a href="https://twitter.com/abhibardolia94">
    <img src="https://img.shields.io/badge/twitter-@abhibardolia94-blue.svg?style=flat" alt="Twitter">
  </a>
    <a href="https://www.linkedin.com/in/abhishek-bardolia-202233104/">
    <img src="https://img.shields.io/badge/linkedin-@abhibardolia94-blue.svg?style=flat" alt="Twitter">
  </a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

This plugin helps you add UPI (Unified Payments Interface) options to your Android and iOS apps. With this plugin, you can enable transactions to any business UPI ID within your app.

To see exactly how to use this plugin, check out the example in the "Example" section or visit the plugin's [Github](https://github.com/abhishekbardolia/flutter_pay_upi.git) repository.

[Check the Supported apps here.](#supported-apps)

# Screenshots
<img src="https://github.com/abhishekbardolia/flutter_pay_upi/assets/21007272/1f444519-6aa1-4b85-b835-05cc1bb61ac4" width="200" />

<img src="https://github.com/abhishekbardolia/flutter_pay_upi/assets/21007272/bc0be994-9c65-46d5-9e67-16e122c6be61" width="200" />

<img src="https://github.com/abhishekbardolia/flutter_pay_upi/assets/21007272/6629a046-c8ab-448a-b2bd-e57302a9e20d" width="200" />

# Important Note

Apps like Google Pay, PhonePe, and Paytm might not be able to complete your transaction right now. They could show errors like "Maximum limit exceeded" or "Risk threshold exceeded." This could happen if you're trying to send money to someone's personal UPI (Unified Payments Interface) account. Another reason could be that you've reached the maximum number of transactions allowed for the day. In this case, you may need to wait until tomorrow to try the same transaction again.

*Note:* Remember to use only business UPI accounts. You can't send money to personal UPI accounts. Stick to business accounts for your transactions.

# System requirements
* sdk: '>=3.1.5 <4.0.0'
* flutter: >=3.3.0
* Android: min sdk 19

# Getting started

Add the plugin package to the `pubspec.yaml` file in your project:

```yaml
dependencies:
  flutter_pay_upi: ^0.1.1 // Just add this dependency and see the magic
```
Install the new dependency:

```sh
flutter pub get
```
# Android

To get all the Upi apps:

```getupi
    List<UpiApp> androidUpiList = await FlutterPayUpiManager.getListOfAllUpiApps();
```

# Start Payment

```dart
    FlutterPayUpiManager.startPayment(paymentApp: upiApp.app!,
      payeeVpa: payeeVpa!,
      payeeName: payeeName!,
      transactionId: transactionId!,
      payeeMerchantCode: payeeMerchantCode!,
      description: description!,
      amount: amount!,
      response: (UpiResponse response){
        // TODO: add your success logic here
      },
      error: (e){
        // TODO: add your exception logic here
      });

```

# Understanding code

enum used here is for UpiExceptionType you don't need to worry Just add `e.toString()` in error. This will print errors.

```
enum UpiExceptionType {
  /// when transaction is cancelled by the user.
  cancelledException,

  /// when transaction failed
  failedException,

  /// Transaction is in PENDING state. Money might get deducted from user’s account but not yet deposited in payee’s account.
  submittedException,

  /// Transaction is in PENDING state. Money might get deducted from user’s account but not yet deposited in payee’s account.
  appNotFoundException,

  /// when unknown exception occurs
  unknownException,
}

```

Note: If you want inbuilt gridview. just add this code:
```dart
UPIAppList(onClick: (upiApp) async {
    
   FlutterPayUpiManager.startPayment(
    paymentApp: upiApp.app!,
    payeeVpa: payeeVpa!,
    payeeName: payeeName!,
    transactionId: transactionId!,
    payeeMerchantCode: payeeMerchantCode!,
    description: description!,
    amount: amount!,
    response: (UpiResponse response) {
      // TODO: add your success logic here
    },
    error: (e) {
      // TODO: add your exception logic here
      print(e.toString());
    });
                    
}),
```

# Behaviour, Limitations & Measures

Android

Flow

* On Android, UPI Deep Linking and Proximity Integration is achieved using Intents.
* When initiating a transaction, an Intent call is made with transaction details, specifying the UPI app to use.
* After processing the UPI transaction in the chosen app, it sends back a response following the specification format.
* The Android plugin layer of the package handles this response.
* The plugin layer parses the response to create a UpiResponse object.
* This object clearly indicates the status of the UPI payment—whether it was successful, failed, or is still being processed.
* The UpiResponse object is then returned to your calling code for further handling.

Measure

It's recommended to add an extra layer of security by setting up a server-side payment check. This helps protect against potential issues or hacks in the UPI transaction process on the user's phone.


## Supported Apps
* Amazon Pay
* BHIM
* Google Pay
* Paytm
* PhonePe


# Reference

Reference took from [EasyUpiPayment-Android](https://github.com/PatilShreyas/EasyUpiPayment-Android) by shreyas Patil.

# This code was helpful to you

<a href="https://www.buymeacoffee.com/dev.abhibardolia" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>


# License

    MIT License

    Copyright (c) 2023 Abhishek Bardolia

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.