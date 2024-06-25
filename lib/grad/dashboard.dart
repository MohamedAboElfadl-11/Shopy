import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:start_project/chat_screens/chats_screen.dart';
import 'package:start_project/grad/product.dart';

import 'brandProfile-brandView.dart';
import 'order.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF684399),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                // Add your back button functionality here
              },
            ),
            const Text(
              'Dashboard',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: DashboardScreen(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
        ),
        child: SalomonBottomBar(
          currentIndex: 0, // يجب تعيين الفهرس الحالي للصفحة الصحيحة
          backgroundColor: Colors.white,
          onTap: (index) {
            switch (index) {
              case 0:
                // لا حاجة للتنقل هنا، لأننا بالفعل في لوحة القيادة
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage()),
                );
                break;
              case 2:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatsScreen()));
                // Add navigation logic for Messages page if you have one
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductPage()),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                break;
            }
          },
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.dashboard, color: Color(0xFF684399)),
              title: const Text("Dashboard"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.receipt_long),
              title: const Text("Orders"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.message),
              title: const Text("Message"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.inventory_2),
              title: const Text("Products"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.account_circle, color: Colors.black),
              title:
                  const Text("Account", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showByMonth = true;
  late Future<List<SalesData>> futureSalesData;
  late Future<List<ProductData>> futureTopProducts;

  @override
  void initState() {
    super.initState();
    futureSalesData = fetchSalesData();
    futureTopProducts = fetchTopProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showByMonth = true;
                      futureSalesData = fetchSalesData();
                    });
                  },
                  child: Text(
                    'View by Month',
                    style: TextStyle(
                      color:
                          _showByMonth ? const Color(0xFF684399) : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showByMonth = false;
                      futureSalesData = fetchSalesData();
                    });
                  },
                  child: Text(
                    'View by Day',
                    style: TextStyle(
                      color:
                          !_showByMonth ? const Color(0xFF684399) : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<SalesData>>(
              future: futureSalesData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildSalesChart(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Top Selling Products',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder<List<ProductData>>(
              future: futureTopProducts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _buildTopProductsList(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart(List<SalesData> salesData) {
    List<charts.Series<SalesData, String>> series = [
      charts.Series(
        id: "Sales",
        data: salesData,
        domainFn: (SalesData sales, _) => sales.label,
        measureFn: (SalesData sales, _) => sales.amount,
        colorFn: (SalesData, _) =>
            charts.ColorUtil.fromDartColor(const Color(0xFF684399)),
      ),
    ];

    return Container(
      height: 300.0,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: charts.BarChart(
        series,
        animate: true,
      ),
    );
  }

  Widget _buildTopProductsList(List<ProductData> products) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(products[index].imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(products[index].name),
          subtitle: Text('Sales: ${products[index].sales}'),
        );
      },
    );
  }

  Future<List<SalesData>> fetchSalesData() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    List<SalesData> salesData = [];
    if (_showByMonth) {
      for (int i = 1; i <= 12; i++) {
        salesData.add(
          SalesData(
            label: DateFormat.MMMM().format(DateTime(0, i)),
            amount: Random().nextInt(1000) + 100,
          ),
        );
      }
    } else {
      int daysInMonth = DateTime.now().month == 2
          ? (DateTime.now().year % 4 == 0 ? 29 : 28)
          : (DateTime.now().month % 2 == 0 ? 30 : 31);
      for (int i = 1; i <= daysInMonth; i++) {
        salesData.add(
          SalesData(
            label: i.toString(),
            amount: Random().nextInt(100) + 10,
          ),
        );
      }
    }

    return salesData;
  }

  Future<List<ProductData>> fetchTopProducts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    List<ProductData> products = [
      ProductData(
        name: 'Product 1',
        imagePath: 'images/image-not-found.jpg',
        sales: Random().nextInt(500) + 50,
      ),
      ProductData(
        name: 'Product 2',
        imagePath: 'images/image-not-found.jpg',
        sales: Random().nextInt(500) + 50,
      ),
      ProductData(
        name: 'Product 3',
        imagePath: 'images/image-not-found.jpg',
        sales: Random().nextInt(500) + 50,
      ),
    ];

    return products;
  }
}

class SalesData {
  final String label;
  final int amount;

  SalesData({
    required this.label,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'amount': amount,
    };
  }
}

class ProductData {
  final String name;
  final String imagePath;
  final int sales;

  ProductData({
    required this.name,
    required this.imagePath,
    required this.sales,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'sales': sales,
    };
  }
}
