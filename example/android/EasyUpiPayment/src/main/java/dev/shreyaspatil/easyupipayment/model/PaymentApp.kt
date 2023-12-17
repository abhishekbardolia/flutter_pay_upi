package dev.shreyaspatil.easyupipayment.model

@Suppress("SpellCheckingInspection")
enum class PaymentApp(val packageName: String) {
	ALL(Package.ALL),
	AMAZON_PAY(Package.AMAZON_PAY),
	BHIM_UPI(Package.BHIM_UPI),
	GOOGLE_PAY(Package.GOOGLE_PAY),
	PAYTM(Package.PAYTM),
	PHONE_PE(Package.PHONE_PE),
	AXIS(Package.AXIS),
	BOI_UPI(Package.BHIM_BOI_UPI),
	CENT_BANK_UPI(Package.CENTRAL_BANK),
	CORPORATION_BANK_UPI(Package.CORPORATION_BANK),
	CSB_BANK_UPI(Package.CSB_BANK),
	DIGIBANK(Package.DIGI_BANK),
	EQUITAS_UPI(Package.EQUITAS_SMALL_FINANCE_BANK),
	FREECHARGE_UPI(Package.FREECHARGE_UPI),
	HSBC_UPI(Package.HSBC_UPI),
	ICICI_BANK(Package.ICICI_BANK),
	INDUS_PAY(Package.INDUS_PAY),
	KARNATAK_UPI(Package.KARNATAK_UPI),
	KOTAK_BANK(Package.KOTAK_UPI),
	HDFC_BANK(Package.PAYZAPP),
	PNB_ONE(Package.PNB_ONE),
	PSB_BANK(Package.PSB_BANK),
	RBL_BANK(Package.RBL_BANK),
	SBI_BANK(Package.SBI_BANK),
	UCO_BANK(Package.UCO_BANK),
	ULTRA_CASH_CUSTOMER_UPI(Package.ULTRA_CASH_CUSTOMER),
	YES_BANK(Package.YES_BANK),
	BOB(Package.BOB),
	AIRTEL_UPI(Package.AIRTEL_UPI),
	CRED_UPI(Package.CRED_UPI);


	private object Package {
		const val ALL = "ALL"
		const val AMAZON_PAY = "in.amazon.mShop.android.shopping"
		const val BHIM_UPI = "in.org.npci.upiapp"
		const val GOOGLE_PAY = "com.google.android.apps.nbu.paisa.user"
		const val PHONE_PE = "com.phonepe.app"
		const val PAYTM = "net.one97.paytm"
		const val AXIS = "com.upi.axispay"
		const val BOB = "com.bankofbaroda.upi"
		const val BHIM_BOI_UPI = "com.infra.boiupi"
//		const val CANARA_UPI = "com.canarabank.mobility"
		const val CENTRAL_BANK = "com.infrasofttech.centralbankupi"
		const val CORPORATION_BANK = "com.lcode.corpupi"
		const val CSB_BANK = "com.lcode.csbupi"
		const val DIGI_BANK = "com.dbs.in.digitalbank"
		const val EQUITAS_SMALL_FINANCE_BANK = "com.equitasbank.upi"
		const val FREECHARGE_UPI = "com.freecharge.android"
		const val HSBC_UPI = "com.mgs.hsbcupi"
		const val ICICI_BANK = "com.csam.icici.bank.imobile"
		const val INDUS_PAY = "com.mgs.induspsp"
		const val KARNATAK_UPI = "com.lcode.smartz"
		const val KOTAK_UPI = "com.msf.kbank.mobile"
		const val PAYZAPP = "com.hdfcbank.payzapp"
		const val PNB_ONE = "com.Version1"
		const val PSB_BANK = "com.psb.omniretail"
		const val RBL_BANK = "com.rblbank.mobank"
		const val SBI_BANK = "com.sbi.upi"
		const val UCO_BANK = "com.lcode.ucoupi"
		const val ULTRA_CASH_CUSTOMER = "com.ultracash.payment.customer"
		const val YES_BANK = "com.YesBank"
		const val AIRTEL_UPI = "com.myairtelapp"
		const val CRED_UPI = "com.dreamplug.androidapp"
	}
}