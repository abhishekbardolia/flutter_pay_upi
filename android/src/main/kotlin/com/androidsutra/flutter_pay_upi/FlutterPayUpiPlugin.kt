package com.androidsutra.flutter_pay_upi

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import dev.shreyaspatil.easyupipayment.EasyUpiPayment
import dev.shreyaspatil.easyupipayment.listener.PaymentStatusListener
import dev.shreyaspatil.easyupipayment.model.Payment
import dev.shreyaspatil.easyupipayment.model.PaymentApp
import dev.shreyaspatil.easyupipayment.model.TransactionDetails
import dev.shreyaspatil.easyupipayment.model.TransactionStatus

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream

/** FlutterPayUpiPlugin */
class FlutterPayUpiPlugin: FlutterPlugin, MethodCallHandler, PaymentStatusListener, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  var _result: MethodChannel.Result? = null
  private var exception = false
  private lateinit var easyUpiPayment: EasyUpiPayment
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_pay_upi")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    _result = result

    if (call.method.equals("allUPIApps")) {
      val packages: List<Map<String, Any>>? = getAllUpiApps()
      result.success(packages)
    } else if (call.method.equals("initiateTransaction")) {


      val app: String?

      app =
        if (call.argument<Any?>("app") == null) "in.org.npci.upiapp" else call.argument(
          "app"
        )
      val pa = call.argument<String>("pa")
      val pn = call.argument<String>("pn")
      val mc = call.argument<String>("mc")
      val tr = call.argument<String>("tr")
      val trref = call.argument<String>("trref")
      val tn = call.argument<String>("tn")
      val am = call.argument<String>("am")
      val cu = call.argument<String>("cu")

      try {

        val paymentApp = when (app) {




          "in.amazon.mShop.android.shopping" -> PaymentApp.AMAZON_PAY//
          "in.org.npci.upiapp" -> PaymentApp.BHIM_UPI//
          "com.google.android.apps.nbu.paisa.user" -> PaymentApp.GOOGLE_PAY//
          "com.phonepe.app" -> PaymentApp.PHONE_PE//
          "net.one97.paytm" -> PaymentApp.PAYTM//
          "com.upi.axispay" -> PaymentApp.AXIS//
          "com.infrasofttech.centralbankupi" -> PaymentApp.CENT_BANK_UPI
          "com.infra.boiupi" -> PaymentApp.BOI_UPI
          "com.lcode.corpupi" -> PaymentApp.CORPORATION_BANK_UPI
          "com.lcode.csbupi" -> PaymentApp.CSB_BANK_UPI
          "com.dbs.in.digitalbank" -> PaymentApp.DIGIBANK
          "com.equitasbank.upi" -> PaymentApp.EQUITAS_UPI
          "com.freecharge.android" -> PaymentApp.FREECHARGE_UPI//
          "com.mgs.hsbcupi" -> PaymentApp.HSBC_UPI
          "com.csam.icici.bank.imobile" -> PaymentApp.ICICI_BANK
          "com.lcode.smartz" -> PaymentApp.KARNATAK_UPI
          "com.mgs.induspsp" -> PaymentApp.INDUS_PAY
          "com.msf.kbank.mobile" -> PaymentApp.KOTAK_BANK
          "com.hdfcbank.payzapp" -> PaymentApp.HDFC_BANK
          "com.Version1" -> PaymentApp.PNB_ONE
          "com.psb.omniretail" -> PaymentApp.PSB_BANK
          "com.rblbank.mobank" -> PaymentApp.RBL_BANK
          "com.sbi.upi" -> PaymentApp.SBI_BANK//
          "com.lcode.ucoupi" -> PaymentApp.UCO_BANK
          "com.ultracash.payment.customer" -> PaymentApp.ULTRA_CASH_CUSTOMER_UPI
          "com.YesBank" -> PaymentApp.YES_BANK
          "com.bankofbaroda.upi" -> PaymentApp.BOB
          "com.myairtelapp" -> PaymentApp.AIRTEL_UPI
          "com.dreamplug.androidapp" -> PaymentApp.CRED_UPI
          else -> throw IllegalStateException("Unexpected value: ")
        }



        exception = false

        easyUpiPayment = EasyUpiPayment(activity!!) {
          this.paymentApp = paymentApp
          this.payeeVpa = pa
          this.payeeName = pn
          this.transactionId = tr
          this.transactionRefId = trref
          this.payeeMerchantCode = mc
          this.description = tn
          this.currency=cu
          this.amount = am

        }


        // Register Listener for Events
        easyUpiPayment.setPaymentStatusListener(this)

        // Start payment / transaction
        easyUpiPayment.startPayment()

      } catch (ex: Exception) {
        var msg=ex.message
        result.success("${msg}");
        exception = true
      }

    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun getAllUpiApps(): List<Map<String, Any>>? {
    val packages: MutableList<Map<String, Any>> = ArrayList()
    val intent = Intent(Intent.ACTION_VIEW)
    val uriBuilder = Uri.Builder()
    uriBuilder.scheme("upi").authority("pay")
    uriBuilder.appendQueryParameter("pa", "test@ybl")
    uriBuilder.appendQueryParameter("pn", "Test")
    uriBuilder.appendQueryParameter("tn", "Get All Apps")
    uriBuilder.appendQueryParameter("am", "1.0")
    uriBuilder.appendQueryParameter("cr", "INR")
    val uri = uriBuilder.build()
    intent.data = uri
    val pm = activity!!.packageManager
    var resolveInfoList:List<ResolveInfo>
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      resolveInfoList = pm
        .queryIntentActivities(intent, PackageManager.ResolveInfoFlags.of(PackageManager.MATCH_DEFAULT_ONLY.toLong()))
    }else{
      resolveInfoList = pm
        .queryIntentActivities(intent, 0);
    }
    for (resolveInfo in resolveInfoList) {
      try {
        // Get Package name of the app.
        val packageName = resolveInfo.activityInfo.packageName

        // Get Actual name of the app to display
        var name: String
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
          name= pm.getApplicationLabel(
            pm.getApplicationInfo(
              packageName,
              PackageManager.ApplicationInfoFlags.of(PackageManager.GET_META_DATA.toLong())
            )
          ) as String
        }else{
          name = pm.getApplicationLabel(
            pm.getApplicationInfo(
              packageName,
              PackageManager.GET_META_DATA
            )

          ) as String
        }


        // Get app icon as Drawable
        val dIcon = pm.getApplicationIcon(packageName)

        // Convert the Drawable Icon as Bitmap.
        val bIcon = getBitmapFromDrawable(dIcon)

        // Convert the Bitmap icon to byte[] received as Uint8List by dart.
        val stream = ByteArrayOutputStream()
        bIcon!!.compress(Bitmap.CompressFormat.PNG, 100, stream)
        val icon = stream.toByteArray()

        // Put everything in a map
        val m: MutableMap<String, Any> = HashMap()
        m["packageName"] = packageName
        m["name"] = name
        m["icon"] = icon

        // Add this app info to the list.
        packages.add(m)
      } catch (e: Exception) {
        e.printStackTrace()
      }
    }
    return packages
  }

  // It converts the Drawable to Bitmap. There are other inbuilt methods too.
  fun getBitmapFromDrawable(drawable: Drawable): Bitmap? {
    val bmp = Bitmap.createBitmap(
      drawable.intrinsicWidth,
      drawable.intrinsicHeight,
      Bitmap.Config.ARGB_8888
    )
    val canvas = Canvas(bmp)
    drawable.setBounds(0, 0, canvas.width, canvas.height)
    drawable.draw(canvas)
    return bmp
  }

  override fun onTransactionCancelled() {
    if (!exception) _result!!.success("User Cancelled transaction")
  }
  override fun onTransactionCompleted(transactionDetails: TransactionDetails) {
    // Transaction Completed
    Log.d("TransactionDetails", transactionDetails.toString())
    val response="txnId=${transactionDetails.transactionId}" +
            "&responseCode=${transactionDetails.responseCode}" +
            "&Status=${transactionDetails.transactionStatus}" +
            "&txnRef=${transactionDetails.transactionRefId}"

    when (transactionDetails.transactionStatus) {
      TransactionStatus.SUCCESS -> if (!exception) _result!!.success(response)
      TransactionStatus.FAILURE -> if (!exception) _result!!.success(response)
      TransactionStatus.SUBMITTED -> if (!exception) _result!!.success(response)
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivity() {
    activity = null;
  }
}
