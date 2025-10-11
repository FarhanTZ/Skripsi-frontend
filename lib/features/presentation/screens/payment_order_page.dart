import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/presentation/screens/order_tracking_page.dart';
import 'package:intl/intl.dart';

class PaymentOrderPage extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final double totalPrice;

  const PaymentOrderPage({
    super.key,
    required this.orderItems,
    required this.totalPrice,
  });

  @override
  State<PaymentOrderPage> createState() => _PaymentOrderPageState();
}

class _PaymentOrderPageState extends State<PaymentOrderPage> {
  String? _selectedPaymentMethod = 'Credit Card'; // Metode pembayaran default
  double _discountAmount = 0.0;
  String _appliedDiscountCode = '';

  // Data dummy untuk pilihan diskon
  final List<Map<String, dynamic>> _availableDiscounts = [
    {
      'code': 'HEMAT10',
      'title': 'Diskon 10%',
      'description': 'Dapatkan potongan 10% untuk semua item.',
      'value': 0.10,
      'type': 'percentage',
    },
    {
      'code': 'POTONGAN5K',
      'title': 'Potongan Rp 5.000',
      'description': 'Dapatkan potongan harga langsung sebesar Rp 5.000.',
      'value': 5000.0,
      'type': 'fixed',
    },
  ];


  // Formatter untuk mata uang
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  double get _finalTotal => widget.totalPrice - _discountAmount;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Payment Order',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Shipping Address'),
            const SizedBox(height: 8),
            _buildAddressCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Order Summary'),
            const SizedBox(height: 8),
            _buildOrderSummaryCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Payment Method'),
            const SizedBox(height: 8),
            _buildPaymentMethodCard(),
            const SizedBox(height: 24),
            _buildDiscountSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildPayNowBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildAddressCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: AppTheme.inputLabelColor, size: 32),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Jl. Telekomunikasi No. 1, Bandung, Jawa Barat',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: widget.orderItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('${item['name']} (x${item['quantity']})')),
                  Text(currencyFormatter.format(item['price'] * item['quantity'])),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _applyDiscount(Map<String, dynamic> discount) {
    setState(() {
      final type = discount['type'];
      if (type == 'percentage') {
        _discountAmount = widget.totalPrice * (discount['value'] as double);
      } else if (type == 'fixed') {
        _discountAmount = discount['value'] as double;
      }
      _appliedDiscountCode = discount['code'] as String;
    });

    // Tutup bottom sheet dulu, baru tampilkan dialog
    Navigator.of(context).pop();
    _showModernDialog(
        context: context,
        message: 'Diskon "${discount['title']}" berhasil diterapkan!',
        type: SnackBarType.success);
  }

  void _removeDiscount() {
    setState(() {
      _discountAmount = 0.0;
      _appliedDiscountCode = '';
    });
    // Tutup bottom sheet dulu, baru tampilkan dialog
    Navigator.of(context).pop();
    _showModernDialog(
        context: context,
        message: 'Diskon berhasil dihapus.',
        type: SnackBarType.warning);
  }

  Future<void> _showDiscountSelectionSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pilih Diskon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              ..._availableDiscounts.map((discount) {
                bool isSelected = _appliedDiscountCode == discount['code'];
                return Card(
                  elevation: 1,
                  color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                    ),
                  ),
                  child: ListTile(
                    title: Text(discount['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(discount['description'] as String),
                    onTap: () => _applyDiscount(discount),
                    trailing: isSelected ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null,
                  ),
                );
              }).toList(),
              if (_appliedDiscountCode.isNotEmpty) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _removeDiscount,
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text('Hapus Diskon', style: TextStyle(color: Colors.red)),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiscountSection() {
    return InkWell(
      onTap: _showDiscountSelectionSheet,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.local_offer_outlined, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _appliedDiscountCode.isEmpty ? 'Pilih Diskon' : 'Diskon Diterapkan: $_appliedDiscountCode',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _appliedDiscountCode.isEmpty ? Colors.black87 : Colors.green),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedPaymentMethod,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            items: <String>['Credit Card', 'Bank Transfer', 'E-Wallet']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedPaymentMethod = newValue;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPayNowBar() {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 24,
        right: 24,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_discountAmount > 0) ...[
            _buildPriceRow('Subtotal', currencyFormatter.format(widget.totalPrice)),
            const SizedBox(height: 8),
            _buildPriceRow('Diskon ($_appliedDiscountCode)', '- ${currencyFormatter.format(_discountAmount)}', isDiscount: true),
            const Divider(height: 24),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                currencyFormatter.format(_finalTotal),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementasi logika pembayaran
              _showPaymentSuccessDialog(
                  context: context,
                  message: 'Your payment was successful!',
                  type: SnackBarType.success,
                  orderItems: widget.orderItems,
                  finalTotal: _finalTotal);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Pay Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        Text(
          amount,
          style: TextStyle(color: isDiscount ? Colors.green : Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// Enum untuk tipe SnackBar
enum SnackBarType { success, warning, error, info }

// Fungsi helper untuk menampilkan Dialog modern
void _showModernDialog({
  required BuildContext context,
  required String message,
  required SnackBarType type,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _buildDialogContent(dialogContext, message, type),
      );
    },
  );
}

// Dialog khusus untuk sukses pembayaran yang akan bernavigasi
void _showPaymentSuccessDialog(
    {required BuildContext context,
    required String message,
    required SnackBarType type,
    required List<Map<String, dynamic>> orderItems,
    required double finalTotal}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Pengguna harus menekan tombol
    builder: (BuildContext dialogContext) {
      // Konten dialog diambil dari _buildDialogContent, tapi dengan aksi navigasi
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _buildDialogContent(
          dialogContext,
          message,
          type,
          onOkPressed: () {
            // 1. Tutup dialog
            Navigator.of(dialogContext).pop();

            // 2. Buat Order ID unik
            final orderId = 'GLU-${DateTime.now().millisecondsSinceEpoch}';

            // 3. Navigasi ke OrderTrackingPage dan hapus semua halaman sebelumnya
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => OrderTrackingPage(
                  orderItems: orderItems,
                  finalTotal: finalTotal,
                  orderId: orderId,
                ),
              ),
              (Route<dynamic> route) => route.isFirst, // Hapus sampai ke root (HomePage)
            );
          },
        ),
      );
    },
  );
}

// Widget untuk membangun konten dialog kustom
Widget _buildDialogContent(
    BuildContext dialogContext, String message, SnackBarType type,
    {VoidCallback? onOkPressed}) {
  Color iconBackgroundColor;
  IconData iconData;
  String title;

  switch (type) {
    case SnackBarType.success:
      iconBackgroundColor = const Color(0xFF4CAF50); // Hijau
      iconData = Icons.check;
      title = 'Success!';
      break;
    case SnackBarType.warning:
      iconBackgroundColor = Colors.orange;
      iconData = Icons.warning_amber_rounded;
      title = 'Warning';
      break;
    case SnackBarType.error:
      iconBackgroundColor = Colors.red;
      iconData = Icons.error_outline;
      title = 'Error';
      break;
    case SnackBarType.info:
      iconBackgroundColor = Colors.blue;
      iconData = Icons.info_outline;
      title = 'Information';
      break;
  }

  return Stack(
    clipBehavior: Clip.none,
    children: <Widget>[
      // Konten utama dialog
      Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 65, // Memberi ruang untuk ikon di atas
          right: 20,
          bottom: 20,
        ),
        margin: const EdgeInsets.only(top: 45),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Membuat dialog menjadi sepadat kontennya
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: onOkPressed ?? () => Navigator.of(dialogContext).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      // Ikon di atas dialog
      Positioned(
        left: 20,
        right: 20,
        child: CircleAvatar(
          backgroundColor: iconBackgroundColor,
          radius: 45,
          child: Icon(iconData, color: Colors.white, size: 50),
        ),
      ),
    ],
  );
}