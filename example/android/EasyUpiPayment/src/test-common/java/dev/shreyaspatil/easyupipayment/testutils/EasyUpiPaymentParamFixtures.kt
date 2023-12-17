package dev.shreyaspatil.easyupipayment.testutils

import dev.shreyaspatil.easyupipayment.EasyUpiPayment
import dev.shreyaspatil.easyupipayment.listener.PaymentStatusListener
import dev.shreyaspatil.easyupipayment.model.Payment
import dev.shreyaspatil.easyupipayment.model.PaymentApp
import dev.shreyaspatil.easyupipayment.model.TransactionDetails

const val validVpa = "example@vpa"
const val invalidVpa = "emample"

const val validName = "John Doe"
const val invalidName = " "

const val validTransactionId = "dh829h38ry84y248yt98498"
const val invalidTransactionId = " "

const val validAmount = "11000.50"
const val invalidAmount1 = "-10000"
const val invalidAmount2 = "10000"
const val invalidAmount3 = ".1000"

const val validDescription = "Lorem"
const val invalidDescription = " "

fun validEasyUpiPaymentBuilderFixture(builder: EasyUpiPayment.Builder) {
	builder.setPayeeVpa(validVpa)
		.setPayeeName(validName)
		.setTransactionId(validTransactionId)
		.setTransactionRefId(validTransactionId)
		.setDescription(validDescription)
		.setAmount(validAmount)
}

fun paymentStatusListener() = object : PaymentStatusListener {
	override fun onTransactionCompleted(transactionDetails: TransactionDetails) {}
	override fun onTransactionCancelled() {}
}

fun paymentWith(paymentApp: PaymentApp? = null) = Payment(
	"INT",
	validVpa,
	validName,
	"",
	validTransactionId,
	validTransactionId,
	validDescription,
	validAmount,
	paymentApp?.packageName
)
