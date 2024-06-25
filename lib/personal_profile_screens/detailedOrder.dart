import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'Review.dart';

class detailedOrder extends StatelessWidget {
  final Map order;

  detailedOrder({required this.order});

  List<Map<String, dynamic>> getTrackingSteps(String orderStatus) {
    final List<Map<String, dynamic>> steps = [
      {'stepText': 'Placed', 'isCompleted': false},
      {'stepText': 'Confirmed', 'isCompleted': false},
      {'stepText': 'Shipped', 'isCompleted': false},
      {'stepText': 'Delivered', 'isCompleted': false},
    ];

    switch (orderStatus) {
      case 'Placed':
        steps[0]['isCompleted'] = true;
        break;
      case 'Confirmed':
        steps[0]['isCompleted'] = true;
        steps[1]['isCompleted'] = true;
        break;
      case 'Shipped':
        steps[0]['isCompleted'] = true;
        steps[1]['isCompleted'] = true;
        steps[2]['isCompleted'] = true;
        break;
      case 'Delivered':
        steps[0]['isCompleted'] = true;
        steps[1]['isCompleted'] = true;
        steps[2]['isCompleted'] = true;
        steps[3]['isCompleted'] = true;
        break;
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final trackingSteps = getTrackingSteps(order['orderStatus']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Text(
              'Order Details',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Products',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            ...order['items'].map<Widget>((product) {
              return ProductCard(
                productName: product['productName'],
                productImage: product['productImage'],
                productPrice: product['productPrice'],
                orderStatus:
                    order['orderStatus'], // Pass order status to ProductCard
              );
            }).toList(),
            const SizedBox(height: 20.0),
            const Text(
              'Tracking',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10.0),
            Column(
              children: trackingSteps.map((step) {
                return _buildTrackingStep(
                  stepText: step['stepText'],
                  isCompleted: step['isCompleted'],
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Shipping Details',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            _buildShippingDetails(orderNumber: order['orderNumber']),
            const SizedBox(height: 20.0),
            _buildPaymentDetails(
              itemsCount: order['items'].length,
              itemsPrice: order['items'].fold(
                  0,
                  (sum, item) =>
                      sum + double.parse(item['productPrice'].substring(1))),
              shippingPrice: 40,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _generateInvoice(context, order);
          },
          child: const Text('Invoice'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF684399),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingStep(
      {required String stepText, required bool isCompleted}) {
    return Row(
      children: [
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? const Color(0xFF684399) : Colors.transparent,
            border: Border.all(color: const Color(0xFF684399), width: 2.0),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 16.0, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 10.0),
        Text(
          stepText,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildShippingDetails({required String orderNumber}) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(label: 'Order Number:', value: orderNumber),
          const SizedBox(height: 8.0),
          _buildDetailRow(label: 'Phone Number:', value: '01234567'),
          const SizedBox(height: 8.0),
          _buildDetailRow(
              label: 'Address:', value: '123 Mockup Street, City, Country'),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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

  Widget _buildPaymentDetails(
      {required int itemsCount,
      required double itemsPrice,
      required double shippingPrice}) {
    final double totalPrice = itemsPrice + shippingPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Details',
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
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
          style: const TextStyle(fontSize: 14.0, color: Colors.black),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14.0, color: Colors.black),
        ),
      ],
    );
  }

  Future<void> _generateInvoice(BuildContext context, Maporder) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Order Number: ${order['orderNumber']}'),
              pw.SizedBox(height: 10),
              pw.Text('Order Status: ${order['orderStatus']}'),
              pw.SizedBox(height: 10),
              pw.Text('Items:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.ListView.builder(
                itemCount: order['items'].length,
                itemBuilder: (context, index) {
                  final item = order['items'][index];
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(item['productName']),
                      pw.Text(item['productPrice']),
                    ],
                  );
                },
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Total: EGP ${order['items'].fold(0, (sum, item) => sum + double.parse(item['productPrice'].substring(1)))}'),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }
}

class ProductCard extends StatefulWidget {
  final String productName;
  final String productImage;
  final String productPrice;
  final String orderStatus; // New field for order status

  ProductCard({
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.orderStatus, // Initialize orderStatus
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final bool isDelivered =
        widget.orderStatus == 'Delivered'; // Check if the order is delivered

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              widget.productImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.productPrice,
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isDelivered) // Show review button only if the order is delivered
            IconButton(
              icon: const Icon(
                Icons.rate_review,
                color: Colors.grey,
              ),
              onPressed: () {
                // Navigate to the review screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewScreen()),
                );
              },
            ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
    );
  }
}
