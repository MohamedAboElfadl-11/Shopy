import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<File?> _pickedImages = [];

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImages.add(File(pickedImage.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Write your review:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const TextField(
                maxLines: null,
                maxLength: 255,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  hintText: 'Write your review here...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            const Text(
              'Upload up to 3 photos:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPhotoPicker(0),
                _buildPhotoPicker(1),
                _buildPhotoPicker(2),
              ],
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
                onPressed: () {
                  // Add functionality to submit review
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF684399),
                ),
                child: const Text('Submit Review')),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPicker(int index) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _pickedImages.length > index && _pickedImages[index] != null
            ? Image.file(
                _pickedImages[index]!,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.camera_alt),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReviewScreen(),
  ));
}
