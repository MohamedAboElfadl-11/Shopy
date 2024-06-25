import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:start_project/brand_profile_pages/screens/personal_brand_profile.dart';
import 'package:start_project/theme/theme.dart';

import '../constants.dart';
import '../models/cart_item.dart';
import '../models/products.dart';
import '../widgets/product_widgets/add_to_cart.dart';
import '../widgets/product_widgets/appbar.dart';
import '../widgets/product_widgets/image_slider.dart';
import '../widgets/product_widgets/information.dart';
import '../widgets/product_widgets/product_desc.dart';






class ProductScreen extends StatefulWidget {
   Map product;
   ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int currentImage = 0;
  int currentColor = 0;
  int currentNumber = 1;
  late CartItem cartItem;

  // @override
  // void initState(){
  //   super.initState();
  //   cartItem = CartItem(quantity: currentNumber, product: widget.product);
  // }
  //
  // void increment(){
  //   setState(() {
  //     currentNumber++;
  //     cartItem = CartItem(quantity: currentNumber, product: widget.product);
  //   });
  // }
  //
  // void decrement(){
  //   setState(() {
  //     if(currentNumber > 1) {
  //       currentNumber--;
  //       cartItem = CartItem(quantity: currentNumber, product: widget.product);
  //     }
  //   });
  // }


    List favorites = [];
    List cart = [];
    Map users = {};
    @override
    void initState() {
      FirebaseDatabase.instance.ref("users")
          .onValue.listen((event) {
        if(event.snapshot.exists){
          Map o = event.snapshot.value as Map;
          if(mounted){
            setState(() {
              users = o;
            });
          }
        }else{
          if(mounted){
            setState(() {
              users = {};
            });
          }
        }
      });

      FirebaseDatabase.instance.ref("favorites")
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .onValue.listen((event) {
        if(event.snapshot.exists){
          Map o = event.snapshot.value as Map;
          favorites.clear();
          o.forEach((key, value) {
            if(mounted){
              setState(() {
                favorites.add(key);
              });
            }
          });
        }else{
          if(mounted){
            setState(() {
              favorites.clear();
            });
          }
        }
      });

      FirebaseDatabase.instance.ref("cart")
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .onValue.listen((event) {
        if(event.snapshot.exists){
          Map o = event.snapshot.value as Map;
          cart.clear();
          o.forEach((key, value) {
            if(mounted){
              setState(() {
                cart.add(key);
              });
            }
          });
        }else{
          if(mounted){
            setState(() {
              cart.clear();
            });
          }
        }
      });
    }


  @override
  Widget build(BuildContext context) {
      var from = widget.product["from"];
      Map user = users.containsKey(from)?users[from]:{};
      var driverImage = user.containsKey("image")?user["image"]:"";
      var sellerName = user.containsKey("name")?user["name"]:"";
    return Scaffold(
      backgroundColor: kcontentColor,
      // floatingActionButton: AddToCart(
      //   cartItem: cartItem,
      //   currentNumber: currentNumber,
      //   onAdd: increment,
      //   onRemove: decrement,
      //   onAddToCart: (CartItem item){
      //     setState(() {
      //       cartItem = item;
      //       cartItems.add(item);
      //     });
      //   }
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 12),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32,),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:BorderRadius.circular(15),
                      child: Image.network(
                        widget.product["image"],width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(40),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back_ios,size: 28,color: Colors.black,),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                // const ProductAppBar(),
                // ImageSlider(
                //   onChange: (index) {
                //     setState(() {
                //       currentImage = index;
                //     });
                //   },
                //   currentImage: currentImage,
                //   image: widget.product["image"],
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: List.generate(
                //     5,
                //     (index) => AnimatedContainer(
                //       duration: const Duration(milliseconds: 300),
                //       width: currentImage == index ? 15 : 8,
                //       height: 8,
                //       margin: const EdgeInsets.only(right: 2),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(
                //           color: Colors.black,
                //         ),
                //         color: currentImage == index
                //             ? Colors.black
                //             : Colors.transparent,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                    bottom: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4,),
                          Text(
                            widget.product["name"],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12,),
                          const Text(
                            "Price",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4,),

                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.product["price"]} EGP",
                                    style:  TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: lightColorScheme.primary
                                    ),
                                  ),
                                  // const SizedBox(height: 10),
                                ],
                              ),
                              // const Spacer(),
                              // const Text.rich(
                              //   TextSpan(
                              //     children: [
                              //       TextSpan(text: "Seller: "),
                              //       TextSpan(
                              //         text: "Fatma Muhammad",
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(widget.product["desc"],style: TextStyle(
                        color: Colors.black,fontSize: 20
                      ),),
                      SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Brand",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8,),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                               brand: user, brandId: from,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightColorScheme.primary.withAlpha(30)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: driverImage.toString().isNotEmpty?NetworkImage(driverImage):null,
                                  radius: 26,
                                  backgroundColor: Colors.grey.withAlpha(60),
                                ),
                                SizedBox(width: 12,),
                                Text(sellerName,style: TextStyle(
                                  color: lightColorScheme.primary,fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),)
                              ],
                            ),
                          ),
                        ),
                      )

                      // Row(
                      //   children: List.generate(
                      //     widget.product.colors.length,
                      //     (index) => GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           currentColor = index;
                      //         });
                      //       },
                      //       child: AnimatedContainer(
                      //         duration: const Duration(milliseconds: 300),
                      //         width: 35,
                      //         height: 35,
                      //         decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           color: currentColor == index
                      //               ? Colors.white
                      //               : widget.product.colors[index],
                      //           border: currentColor == index
                      //               ? Border.all(
                      //                   color: widget.product.colors[index],
                      //                 )
                      //               : null,
                      //         ),
                      //         padding: currentColor == index
                      //             ? const EdgeInsets.all(2)
                      //             : null,
                      //         margin: const EdgeInsets.only(right: 15),
                      //         child: Container(
                      //           width: 30,
                      //           height: 30,
                      //           decoration: BoxDecoration(
                      //             color: widget.product.colors[index],
                      //             shape: BoxShape.circle,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      // ProductDescription(text: widget.product["desc"]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                    if(!cart.contains(widget.product["id"])){
                      FirebaseDatabase.instance.ref("cart")
                          .child(FirebaseAuth.instance.currentUser!.uid.toString())
                          .child(widget.product["id"]).set({"id":widget.product["id"],
                      "amount":"1"});

                    }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: cart.contains(widget.product["id"])?
                        lightColorScheme.primary.withAlpha(30):lightColorScheme.primary,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text( cart.contains(widget.product["id"])?"Added to Cart":"Add to cart",textAlign: TextAlign.center,style: TextStyle(
                          color: cart.contains(widget.product["id"])?
                          lightColorScheme.primary:Colors.white,
                            fontSize: 20,fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                InkWell(
                  onTap: (){
                    if(favorites.contains(widget.product["id"])){
                      FirebaseDatabase.instance.ref("favorites")
                          .child(FirebaseAuth.instance.currentUser!.uid.toString())
                          .child(widget.product["id"]).remove();

                    }else{
                      FirebaseDatabase.instance.ref("favorites")
                          .child(FirebaseAuth.instance.currentUser!.uid.toString())
                          .child(widget.product["id"]).set(widget.product["id"]);

                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:favorites.contains(widget.product["id"])?
                        Colors.red.withAlpha(30):Colors.grey.withAlpha(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child:Icon(Icons.favorite,size: 32,color: favorites.contains(widget.product["id"])?
                      Colors.red:Colors.grey,)
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}

