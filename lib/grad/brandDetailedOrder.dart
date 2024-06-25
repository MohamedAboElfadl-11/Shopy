import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF684399), // Custom primary color
        hintColor: const Color(0xFF684399), // Custom accent color
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          toolbarTextStyle: const TextTheme(
            titleLarge: TextStyle(color: Colors.black),
          ).bodyMedium,
          titleTextStyle: const TextTheme(
            titleLarge: TextStyle(color: Colors.black),
          ).titleLarge,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF684399), // Custom button background color
          ),
        ),
      ),
      home: const BrandOwnerOrderDetails(
        orderData: {
          'orderNumber': '12345',
          'orderDate': '2024-05-28 14:30:00',
          'items': [
            {
              'productName': 'Product 1',
              'productImage': 'images/image-not-found.jpg',
              'productPrice': 'EGP 100.00'
            },
            {
              'productName': 'Product 2',
              'productImage': 'images/image-not-found.jpg',
              'productPrice': 'EGP 150.00'
            },
          ],
          'itemsPrice': 250.00,
          'shippingPrice': 40.00,
          'customerDetails': {
            'name': 'John Doe',
            'phoneNumber': '0123456789',
            'address': '123 Mockup Street, City, Country',
          },
          'isConfirmed': false,
        },
      ),
    );
  }
}

class BrandOwnerOrderDetails extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const BrandOwnerOrderDetails({Key? key, required this.orderData})
      : super(key: key);

  @override
  _BrandOwnerOrderDetailsState createState() => _BrandOwnerOrderDetailsState();
}

class _BrandOwnerOrderDetailsState extends State<BrandOwnerOrderDetails> {
  late bool isConfirmed;
  late Map<String, dynamic> orderData;

  @override
  void initState() {
    super.initState();
    orderData = Map<String, dynamic>.from(
        widget.orderData); // تحويل البيانات إلى النوع الصحيح
    isConfirmed = orderData['isConfirmed'] as bool? ?? false;
  }

  void _confirmOrder() {
    setState(() {
      isConfirmed = true;
      orderData['isConfirmed'] = true;
    });
  }

  Future<void> _generateInvoice() async {
    final pdf = pw.Document();

    final orderNumber = orderData['orderNumber'] as String? ?? 'Unknown';
    final orderDate = orderData['orderDate'] as String? ?? 'Unknown';
    final items = orderData['items'] as List<dynamic>? ?? [];
    final itemsPrice = orderData['itemsPrice'] as double? ?? 0.0;
    final shippingPrice = orderData['shippingPrice'] as double? ?? 0.0;
    final customerDetails =
        orderData['customerDetails'] as Map<String, dynamic>? ?? {};

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Invoice', style: const pw.TextStyle(fontSize: 40)),
            pw.SizedBox(height: 20),
            pw.Text('Order Number: $orderNumber'),
            pw.Text('Order Date: $orderDate'),
            pw.SizedBox(height: 20),
            pw.Text('Items:'),
            pw.ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map<String, dynamic>;
                final productName = item['productName'] as String? ?? 'Unknown';
                final productPrice =
                    item['productPrice'] as String? ?? 'EGP 0.00';
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('$productName - $productPrice'),
                    pw.SizedBox(height: 10),
                  ],
                );
              },
            ),
            pw.SizedBox(height: 20),
            pw.Text('Items Price: EGP ${itemsPrice.toStringAsFixed(2)}'),
            pw.Text('Shipping Price: EGP ${shippingPrice.toStringAsFixed(2)}'),
            pw.Text(
                'Total: EGP ${(itemsPrice + shippingPrice).toStringAsFixed(2)}'),
            pw.SizedBox(height: 20),
            pw.Text('Customer Details:'),
            pw.Text('Name: ${customerDetails['name'] as String? ?? 'Unknown'}'),
            pw.Text(
                'Phone: ${customerDetails['phoneNumber'] as String? ?? 'Unknown'}'),
            pw.Text(
                'Address: ${customerDetails['address'] as String? ?? 'Unknown'}'),
          ],
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final items = orderData['items'] as List<dynamic>? ?? [];
    final itemsPrice = orderData['itemsPrice'] as double? ?? 0.0;
    final shippingPrice = orderData['shippingPrice'] as double? ?? 0.0;
    final customerDetails =
        orderData['customerDetails'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Order #${orderData['orderNumber']}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Order Date: ${orderData['orderDate']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Products',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            ...items.map<Widget>((item) {
              final product = item as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          product['productImage'] as String,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['productName'] as String,
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            product['productPrice'] as String,
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: isConfirmed ? null : _confirmOrder,
              child: Text(isConfirmed ? 'Order Confirmed' : 'Confirm Order'),
            ),
            const SizedBox(height: 20.0),
            _buildPaymentDetails(items.length, itemsPrice, shippingPrice),
            const SizedBox(height: 20.0),
            _buildCustomerDetails(customerDetails),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _generateInvoice,
              child: const Text('Generate Invoice'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails(
      int itemsCount, double itemsPrice, double shippingPrice) {
    final double totalPrice = itemsPrice + shippingPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Details',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaymentDetailRow('Items ($itemsCount):',
                  'EGP ${itemsPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 5.0),
              _buildPaymentDetailRow(
                  'Shipping:', 'EGP ${shippingPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 5.0),
              _buildPaymentDetailRow(
                  'Total:', 'EGP ${totalPrice.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14.0),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14.0),
        ),
      ],
    );
  }

  Widget _buildCustomerDetails(Map<String, dynamic> customerDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Details',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Name:', customerDetails['name'] ?? 'Unknown'),
              const SizedBox(height: 8.0),
              _buildDetailRow(
                  'Phone Number:', customerDetails['phoneNumber'] ?? 'Unknown'),
              const SizedBox(height: 8.0),
              _buildDetailRow(
                  'Address:', customerDetails['address'] ?? 'Unknown'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
