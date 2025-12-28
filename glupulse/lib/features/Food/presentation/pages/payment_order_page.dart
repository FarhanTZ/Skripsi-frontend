import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/Address/presentation/cubit/address_cubit.dart';
import 'package:glupulse/features/Address/presentation/pages/address_list_page.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/orders/presentation/pages/order_history_page.dart';
import 'package:glupulse/features/orders/presentation/pages/order_tracking_page.dart';
import 'package:glupulse/features/profile/data/models/address_model.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:glupulse/features/Food/presentation/cubit/checkout_cubit.dart';
import 'package:glupulse/features/Food/presentation/cubit/checkout_state.dart';
import 'package:glupulse/injection_container.dart';

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

  // State untuk alamat pengiriman
  AddressModel? _shippingAddress;

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
  void initState() {
    super.initState();
    // Mengambil state otentikasi saat ini dari AuthCubit.
    final authState = context.read<AuthCubit>().state;
    // Memeriksa apakah pengguna sudah terotentikasi.
    if (authState is AuthAuthenticated) {
      // Memeriksa apakah daftar alamat pengguna tidak null dan tidak kosong.
      if (authState.user.addresses != null &&
          authState.user.addresses!.isNotEmpty) {
        // Mencari alamat yang ditandai sebagai 'isDefault'.
        // Jika tidak ada, maka akan menggunakan alamat pertama dalam daftar sebagai fallback.
        _shippingAddress = authState.user.addresses!
            .firstWhere((addr) => addr.isDefault, orElse: () => authState.user.addresses!.first);
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          _showPaymentSuccessDialog(
              context: context,
              message: 'Your payment was successful!',
              type: SnackBarType.success,
              orderItems: widget.orderItems,
              finalTotal: _finalTotal,
              realOrderId: state.orderId); // Pass real ID
        } else if (state is CheckoutError) {
          _showModernDialog(
              context: context,
              message: state.message,
              type: SnackBarType.error);
        }
      },
      child: Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Shipping Address'),
            const SizedBox(height: 12),
            _buildAddressCard(),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Order Summary'),
            const SizedBox(height: 12),
            _buildOrderSummaryCard(),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Payment Method'),
            const SizedBox(height: 12),
            _buildPaymentMethodCard(),
            const SizedBox(height: 24),
            
            _buildDiscountSection(),
            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildPayNowBar(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildAddressCard() {
    return InkWell(
      onTap: () async {
        final authState = context.read<AuthCubit>().state;
        List<AddressModel> userAddresses = [];
        if (authState is AuthAuthenticated) {
          userAddresses = authState.user.addresses ?? [];
        }

        final selectedAddress = await Navigator.of(context).push<AddressModel>(
          MaterialPageRoute(
            builder: (routeContext) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: BlocProvider.of<AuthCubit>(context)),
                BlocProvider(create: (context) => sl<ProfileCubit>()),
                BlocProvider(create: (context) => sl<AddressCubit>()),
              ],
              child: AddressListPage(addresses: userAddresses, currentSelectedAddress: _shippingAddress),
            ),
          ),
        );

        if (selectedAddress != null) {
          setState(() {
            _shippingAddress = selectedAddress;
          });
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_on_rounded, color: Theme.of(context).colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _shippingAddress?.addressLabel ?? 'No Address Selected',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_shippingAddress?.addressLine1 ?? 'Please select an address'}, ${_shippingAddress?.addressCity ?? ''}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ...widget.orderItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${item['quantity']}x",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['name'],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    currencyFormatter.format(item['price'] * item['quantity']),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            );
          }).toList(),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal", style: TextStyle(color: Colors.grey)),
              Text(currencyFormatter.format(widget.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: _selectedPaymentMethod,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.symmetric(vertical: 4),
            items: <String>['Credit Card', 'Bank Transfer', 'E-Wallet']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Icon(
                      value == 'Credit Card' ? Icons.credit_card : 
                      value == 'Bank Transfer' ? Icons.account_balance : Icons.account_balance_wallet,
                      color: Colors.grey.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
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

  Widget _buildDiscountSection() {
    return InkWell(
      onTap: _showDiscountSelectionSheet,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _appliedDiscountCode.isNotEmpty ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _appliedDiscountCode.isNotEmpty ? Colors.green.shade200 : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.local_offer_rounded, 
              color: _appliedDiscountCode.isNotEmpty ? Colors.green : Colors.grey.shade600,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _appliedDiscountCode.isEmpty ? 'Apply Discount Code' : 'Discount Applied: $_appliedDiscountCode',
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.w600, 
                  color: _appliedDiscountCode.isEmpty ? Colors.black87 : Colors.green.shade700
                ),
              ),
            ),
            if (_appliedDiscountCode.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.green),
                onPressed: _removeDiscount,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            else
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPayNowBar() {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: 24 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_discountAmount > 0) ...[
            _buildPriceRow('Discount', '- ${currencyFormatter.format(_discountAmount)}', isDiscount: true),
            const SizedBox(height: 12),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payment',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                currencyFormatter.format(_finalTotal),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<CheckoutCubit, CheckoutState>(
            builder: (context, state) {
              if (state is CheckoutLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: () {
                  if (_shippingAddress == null) {
                    _showModernDialog(
                        context: context,
                        message: 'Please select a shipping address.',
                        type: SnackBarType.warning);
                    return;
                  }
                  context.read<CheckoutCubit>().submitCheckout(
                        addressId: _shippingAddress!.addressId,
                        paymentMethod: _selectedPaymentMethod ?? 'Credit Card',
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Confirm Payment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              );
            },
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
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isDiscount ? Colors.green : Colors.black87, 
            fontSize: 14, 
            fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }
  
  // ... (Rest of dialog methods remain similar, but styling can be tweaked if needed)
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
    // Jika dipanggil dari sheet, mungkin perlu pop. Tapi tombol remove ada di halaman utama.
    // Jadi cukup tampilkan dialog.
    _showModernDialog(
        context: context,
        message: 'Diskon berhasil dihapus.',
        type: SnackBarType.warning);
  }

  Future<void> _showDiscountSelectionSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4, 
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Available Discounts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._availableDiscounts.map((discount) {
                bool isSelected = _appliedDiscountCode == discount['code'];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : Colors.white,
                    border: Border.all(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Icon(Icons.local_activity, color: Theme.of(context).colorScheme.primary),
                    title: Text(discount['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(discount['description'] as String, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    onTap: () => _applyDiscount(discount),
                    trailing: isSelected ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null,
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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
    required double finalTotal,
    required String realOrderId}) {
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

            // 3. Hapus semua halaman sampai ke root (HomePage)
            Navigator.of(context).popUntil((route) => route.isFirst);

            // 4. Dorong halaman Riwayat Pesanan
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
            );

            // 5. Dorong halaman Lacak Pesanan di atasnya
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OrderTrackingPage(
                orderItems: orderItems,
                finalTotal: finalTotal,
                orderId: realOrderId, // Use real ID
              ),
            ));
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onOkPressed ?? () => Navigator.of(dialogContext).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(dialogContext).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  elevation: 0,
                ),
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      // Ikon di atas dialog
      Positioned(
        left: 0,
        right: 0,
        child: Center(
          child: CircleAvatar(
            backgroundColor: iconBackgroundColor,
            radius: 45,
            child: Icon(iconData, color: Colors.white, size: 50),
          ),
        ),
      ),
    ],
  );
}
