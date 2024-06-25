import 'package:flutter/material.dart';

class ShippingAddressPage extends StatefulWidget {
  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  List<Map<String, dynamic>> addresses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF684399),
        title: const Row(
          children: [
            Text(
              'Shipping Addresses',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(addresses[index]['address']),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    color: addresses[index]['isDefault']
                        ? Colors.green
                        : null, // Change color based on isDefault
                    onPressed: () {
                      // Implement functionality to set this address as default
                      setState(() {
                        // Set isDefault to false for all addresses except the selected one
                        addresses.forEach((address) {
                          if (address != addresses[index]) {
                            address['isDefault'] = false;
                          }
                        });
                        addresses[index]['isDefault'] =
                            true; // Set selected address as default
                      });
                    },
                  ),
                  tileColor:
                      addresses[index]['isDefault'] ? Colors.grey[200] : null,
                  onTap: () {
                    // Implement functionality to edit or delete the address
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddAddressDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF684399),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
              ),
              child: const Text('Add Address',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddAddressDialog(BuildContext context) async {
    String newAddress = ''; // Declare newAddress here
    newAddress = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Address'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter your address',
          ),
          onChanged: (value) {
            newAddress = value; // Update newAddress with the entered value
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement functionality to save the entered address
              if (newAddress.isNotEmpty) {
                setState(() {
                  addresses.add({'address': newAddress, 'isDefault': false});
                });
                Navigator.pop(context); // Close the dialog
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF684399),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
