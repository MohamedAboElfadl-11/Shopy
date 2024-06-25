import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start_project/theme/theme.dart';
import 'dart:io';
import '../brand_profile_pages/jsonAnnotion/uploadProduct.dart';
import 'product.dart';

class EditProductScreen extends StatefulWidget {
  Map product;

  EditProductScreen({ required this.product});

  @override
  _editProductScreen createState() => _editProductScreen();
}

class _editProductScreen extends State<EditProductScreen> {
  File? _productImage;
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _productStockController = TextEditingController();

  // Mock data for category and subcategory
  List<String> categories = [
    "Fashion",
    "Electronics",
    "Beauty",
    "Home & Garden",
    "Sports",
  ];

  Map<String, List<String>> subcategories = {
    "Fashion": ["Men's Clothing", "Women's Clothing", "Accessories"],
    "Electronics": ["Smartphones", "Laptops", "Headphones"],
    "Beauty": ["Skincare", "Makeup", "Fragrances"],
    "Home & Garden": ["Furniture", "Kitchenware", "Gardening"],
    "Sports": ["Fitness Equipment", "Sportswear", "Outdoor Gear"],
  };

  String selectedCategory = "";
  String selectedSubcategory = "";
  var imageUrl = "";
  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _productNameController.text = widget.product["name"];
      _productDescriptionController.text = widget.product["desc"];
      _productPriceController.text = widget.product["price"];
      _productStockController.text = widget.product["stock"];
      imageUrl = widget.product["image"];
      // selectedCategory = widget.product!.category;
      // selectedSubcategory = widget.product!.subcategory;
      // _productImages.add(XFile(widget.product!.imageFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.arrow_back_ios,size: 26,color: Colors.black,),
              ),
            ),
            SizedBox(width: 12,),
            Text('Edit Product',style: TextStyle(
              color: lightColorScheme.primary,fontWeight: FontWeight.bold
            ),),
          ],
        ),
        backgroundColor: Colors.white,
        // iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                _uploadProductImages(context);
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF684399).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: _productImage!=null
                      ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          _productImage!,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Positioned(
                      //   top: 0,
                      //   right: 0,
                      //   child: IconButton(
                      //     icon: const Icon(Icons.close, color: Colors.white),
                      //     onPressed: () {
                      //       setState(() {
                      //         _productImages.clear();
                      //       });
                      //     },
                      //   ),
                      // ),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      imageUrl,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // _buildUploadedImages(),
            // const SizedBox(height: 20),
            const Text(
              'Product Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black54),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productNameController,
              decoration:  InputDecoration(labelText: 'Product Title',
              fillColor: lightColorScheme.primary.withAlpha(40),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide: BorderSide.none
              )),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productPriceController,
              decoration:  InputDecoration(labelText: 'Price', fillColor: lightColorScheme.primary.withAlpha(40),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide: BorderSide.none
                  )),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productDescriptionController,
              decoration:  InputDecoration(labelText: 'Product Description' ,
                  fillColor: lightColorScheme.primary.withAlpha(40),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none
                )),
              maxLines: 3,

            ),

            const SizedBox(height: 20),
            const Text(
              'Stock',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productStockController,
              decoration:  InputDecoration(labelText: 'Available Quantity' ,
    fillColor: lightColorScheme.primary.withAlpha(40),
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(45),
    borderSide: BorderSide.none
    )),
              keyboardType: TextInputType.number,
            ),
            // const SizedBox(height: 20),
            // buildDropdown("Category", categories, (value) {
            //   setState(() {
            //     selectedCategory = value ?? selectedCategory;
            //     selectedSubcategory = ""; // Reset subcategory when category changes
            //   });
            // }),
            // const SizedBox(height: 10),
            // buildDropdown("Subcategory", subcategories[selectedCategory] ?? [], (value) {
            //   setState(() {
            //     selectedSubcategory = value ?? selectedSubcategory;
            //   });
            // }),
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ElevatedButton(
                onPressed: () {
                  if(_productNameController.text.isNotEmpty &&
                      _productDescriptionController.text.isNotEmpty &&
                      _productPriceController.text.isNotEmpty &&
                      _productStockController.text.isNotEmpty
                      // selectedCategory.isNotEmpty &&
                      // selectedSubcategory.isNotEmpty &&
                     ){
                    // print("SSSSSSSSSSSaaaaaaaaaaaa");
                    _saveProduct();
                  }
                },
                // _canSaveProduct() ?  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: 
                  const Color(0xFF684399)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: const Text('Save Changes',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadProductImages(BuildContext context) async {
    final pickedImages = await ImagePicker().
    pickImage(source: ImageSource.gallery,imageQuality: 30);
    if (pickedImages!=null) {
      var path = pickedImages.path;
      setState(() {
        _productImage = File(path);
      });
    }
  }

  // Widget _buildUploadedImages() {
  //   return Wrap(
  //     spacing: 8.0,
  //     runSpacing: 8.0,
  //     children: _productImages.map((image) {
  //       return Container(
  //         width: 100,
  //         height: 100,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.grey),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(8.0),
  //           child: Image.file(
  //             File(image.path),
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget buildDropdown(String labelText, List<String> items, void Function(String?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        value: items.contains(selectedCategory) ? selectedCategory : null,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  bool _canSaveProduct() {
    print("SSSSSSSSS");
    return _productNameController.text.isNotEmpty &&
        _productDescriptionController.text.isNotEmpty &&
        _productPriceController.text.isNotEmpty &&
        _productStockController.text.isNotEmpty &&
        // selectedCategory.isNotEmpty &&
        // selectedSubcategory.isNotEmpty &&
        _productImage!=null;
  }

  _saveProduct() async {

    var currentUid = FirebaseAuth.instance.currentUser!.uid.toString();
    var ref = FirebaseDatabase.instance.ref("products");
    var productId = widget.product["id"];
    if(_productImage!=null){
      var firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(currentUid)
          .child("products").child(productId);
      var uploadTask = firebaseStorageRef.putFile(_productImage!);
      var taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then(
              (imageUrl) async {

            var upload = UploadProduct(
                productId,
                _productNameController.text.trim(),
                imageUrl,
                _productPriceController.text.trim(),
                _productDescriptionController.text.trim(),
                _productStockController.text.trim(),
                currentUid
            );

            ref
                .child(productId).set(upload.toJson()).then((value) {
              Navigator.pop(context);
              // Navigator.pop(context);
            });
          });


    }else{
      var upload = UploadProduct(
          productId,
          _productNameController.text.trim(),
          imageUrl,
          _productPriceController.text.trim(),
          _productDescriptionController.text.trim(),
          _productStockController.text.trim(),
          currentUid
      );

      ref
          .child(productId).set(upload.toJson()).then((value) {
        Navigator.pop(context);
        // Navigator.pop(context);
      });
    }

    // Navigator.pop(
    //   context,
    //   Product(
    //     name: _productNameController.text,
    //     description: _productDescriptionController.text,
    //     price: double.parse(_productPriceController.text),
    //     stockStatus: _productStockController.text,
    //     category: selectedCategory,
    //     subcategory: selectedSubcategory,
    //     imageFile: _productImage!,
    //   ),
    // );
  }
}
