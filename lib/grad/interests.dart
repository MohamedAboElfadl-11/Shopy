import 'package:flutter/material.dart';
import 'recommendations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InterestPage(),
    );
  }
}

class InterestPage extends StatefulWidget {
  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  List<String> categories = [];
  List<bool> selectedCategories = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    // Simulate a delay to mimic network request
    await Future.delayed(const Duration(seconds: 2));

    // Mock data
    List<String> mockCategories = [
      'Women Clothing',
      'Men Clothing',
      'Kid Clothing',
      'Electronics',
      'Shoes',
      'Jewelry',
      'Bags',
      'Games',
      'Tops',
      'Home Decor',
      'Jackets',
      'Necklaces'
    ];

    setState(() {
      categories = mockCategories;
      selectedCategories = List.generate(categories.length, (index) => false);
      isLoading = false;
    });
  }

  int get selectedCount =>
      selectedCategories.where((isSelected) => isSelected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to NAME',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Failed to load categories'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          Text(
                            'What are you interested in?',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 30),
                          Text('Select three or more'),
                        ],
                      ),
                    ),
                    Container(
                      height: 350, // Adjust the height as needed
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          InterestButtons(
                            selectedCategories: selectedCategories,
                            entries: categories,
                            onSelectionChanged: () => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: selectedCount >= 3
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Recommendations()),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCount >= 3
                            ? const Color(0xFF684399)
                            : Colors.grey,
                        minimumSize:
                            const Size(325, 40), // Adjust width as needed
                      ),
                      child: const Text('Continue', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
    );
  }
}

class InterestButtons extends StatelessWidget {
  final List<bool> selectedCategories;
  final List<String> entries;
  final VoidCallback onSelectionChanged;

  InterestButtons({
    required this.selectedCategories,
    required this.entries,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(
        entries.length,
        (index) => GestureDetector(
          onTap: () {
            selectedCategories[index] = !selectedCategories[index];
            onSelectionChanged();
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: selectedCategories[index]
                  ? const Color(0xFF684399).withOpacity(0.26)
                  : Colors.white,
              border: Border.all(
                color: const Color(0xFF684399),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              entries[index],
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
