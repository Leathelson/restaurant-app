import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/app_data.dart';
import 'receipt_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Color luxeGold = const Color(0xFFB8860B);
  final Color darkSlate = const Color(0xFF34495E);
  final Color maroonTitle = const Color(0xFF63210B);

  String selectedMethod = "Visa";

  @override
  Widget build(BuildContext context) {
    // Calculate totals using the AppData cart structure
    double subtotal = AppData.cart
        .fold(0.0, (sum, item) => sum + (item.unitPrice * item.quantity));
    double total = subtotal * 1.10;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(AppData.trans("CHECKOUT"), // Translated Title
            style: TextStyle(
                color: maroonTitle,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 16)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 20),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _sectionLabel("ORDER SUMMARY"), // Translated Label
                    _buildSummaryBox(subtotal, total),
                    const SizedBox(height: 15),
                    _sectionLabel("PAYMENT METHOD"), // Translated Label
                    _buildMethodSection(),
                    const SizedBox(height: 15),
                    _sectionLabel("CARD DETAILS"), // Translated Label
                    _buildCardForm(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 45),
              child: _buildPayButton(total),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton(double totalAmount) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: luxeGold,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiptScreen(
                items: List.from(AppData.cart),
                total: totalAmount,
              ),
            ),
          );
        },
        child: Text(
            // Translated button text
            "${AppData.trans("CONFIRM PAYMENT")}  |  Rs ${totalAmount.toInt()}",
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15)),
      ),
    );
  }

  Widget _sectionLabel(String text) => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(AppData.trans(text), // Calling trans()
            style: TextStyle(
                color: luxeGold,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2)),
      );

  Widget _buildSummaryBox(double sub, double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          color: const Color(0xFF34495E),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _rowText(AppData.trans("Subtotal"), "Rs ${sub.toInt()}"),
          const SizedBox(height: 6),
          // Translated Tax label
          _rowText(AppData.trans("Tax (10%)"), "Rs ${(total - sub).toInt()}"),
          const Divider(color: Colors.white24, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppData.trans("TOTAL"), // Translated Total label
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15)),
              Text("Rs ${total.toInt()}",
                  style: TextStyle(
                      color: luxeGold,
                      fontWeight: FontWeight.w900,
                      fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _methodTile("Visa", "assets/images/visa.jpg"),
        _methodTile("Master", "assets/images/mastercard.jpg"),
        _methodTile("PayPal", "assets/images/paypal.jpg"),
      ],
    );
  }

  Widget _methodTile(String id, String path) {
    bool active = selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = id),
      child: Column(
        children: [
          Container(
            height: 55,
            width: 85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: active ? luxeGold : Colors.white, width: 2.5),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6)
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(path,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.credit_card, color: Colors.grey)),
          ),
          const SizedBox(height: 6),
          Text(id,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: active ? luxeGold : Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
          color: const Color(0xFF34495E),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _inputField("CARD NUMBER", "1234 5678 9012 3456", formatters: [
            CardNumberFormatter(),
            LengthLimitingTextInputFormatter(19)
          ]),
          const Divider(color: Colors.white24, height: 30),
          Row(
            children: [
              Expanded(
                  child: _inputField("EXPIRY", "MM/YY", formatters: [
                ExpiryDateFormatter(),
                LengthLimitingTextInputFormatter(5)
              ])),
              const SizedBox(width: 25),
              Expanded(child: _inputField("CVV", "•••", limit: 3)),
            ],
          ),
          const Divider(color: Colors.white24, height: 30),
          _inputField("CARD HOLDER", "FULL NAME"),
        ],
      ),
    );
  }

  Widget _inputField(String label, String hint,
      {int? limit, List<TextInputFormatter>? formatters}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The label is passed to AppData.trans()
        Text(AppData.trans(label),
            style: TextStyle(
                color: luxeGold, fontSize: 10, fontWeight: FontWeight.w900)),
        TextField(
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          inputFormatters: formatters ??
              (limit != null ? [LengthLimitingTextInputFormatter(limit)] : []),
          keyboardType: label == "CARD HOLDER"
              ? TextInputType.name
              : TextInputType.number,
          decoration: InputDecoration(
            // Optional: You can translate hints too
            hintText: AppData.trans(hint),
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ],
    );
  }

  

  Widget _rowText(String l, String v) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          Text(v,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15)),
        ],
      );
}

// Formatters remain unchanged
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (oldValue.text.length >= newText.length) return newValue;
    var dateText = newText.replaceAll('/', '');
    if (dateText.isEmpty) return newValue;
    if (int.parse(dateText[0]) > 1) return oldValue;
    if (dateText.length > 1 && int.parse(dateText.substring(0, 2)) > 12) {
      return oldValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < dateText.length; i++) {
      buffer.write(dateText[i]);
      if (i == 1 && dateText.length > 2) buffer.write('/');
    }
    return newValue.copyWith(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && (i + 1) != text.length) buffer.write(' ');
    }
    return newValue.copyWith(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}
