import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:start_project/brand_profile_pages/jsonAnnotion/uploadOrder.dart';
import 'package:start_project/brand_profile_pages/screens/product_screen.dart';
import 'package:start_project/theme/theme.dart';
import '../constants.dart';
import '../models/cart_item.dart';
import '../widgets/cart_tile.dart';
import '../widgets/check_out_box.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void removeItem(CartItem item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  List cartProducts = [];
  Map products = {};
  Map cartValue = {};
  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.ref("products").onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            products = o;
          });
        }
      }
    });

    FirebaseDatabase.instance.ref("cart")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            cartValue = o;
          });
        }
        cartProducts.clear();
        o.forEach((key, value) {
          if(mounted){
            setState(() {
              cartProducts.add(key);
            });
          }
        });
        getPrice();
      }else{
        if(mounted){
          setState(() {
            cartProducts.clear();
          });
        }
        getPrice();
      }
    });
  }

  double price = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kcontentColor,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        backgroundColor: Colors.white,
        title:  Text(
          "Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: lightColorScheme.primary,
          ),
        ),
        // leadingWidth: 60,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 5),
        //   child: IconButton(
        //     onPressed: () {
        //      //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
        //     },
        //     icon: const Icon(
        //       Ionicons.arrow_back_outline,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //   ),
        // ),

      ),
      // bottomSheet: cartItems.isNotEmpty ? CheckOutBox(items: cartItems) : null,
      body: Column(
        children: [
          Expanded(child: cartProducts.isNotEmpty?ListView.builder(
            itemCount:cartProducts.length,
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
            itemBuilder: (context, index) {
              Map product = products.containsKey(cartProducts.elementAt(index))?
              products[cartProducts.elementAt(index)]:{};
              Map o = cartValue.containsKey(cartProducts.elementAt(index))?cartValue[cartProducts.elementAt(index)]:{};
              // var image = "";
              // var name = "ffdssddw";
              // var price = "QFwfqw";
              // var desc = "QWfqw";
              // var id = "fqef";
              var image = product["image"];
              var name = product["name"];
              var price = product["price"];
              var desc = product["desc"];
              var id = product["id"];
              var stock = product["stock"];
              int amount = int.parse(o["amount"]);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: (){
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ProductScreen(product: product),
                    //   ),
                    // );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      ClipRRect(
                        borderRadius:BorderRadius.circular(15),
                        child: image.isNotEmpty?Image.network(
                          image,width: 140,
                          height: 120,
                          fit: BoxFit.cover,
                        ):Container(
                          width: 140,height: 120,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,style: TextStyle(
                                color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20
                            ),),
                            SizedBox(height: 8,),
                            Text(price+" EGP",style: TextStyle(
                                color: lightColorScheme.primary,fontWeight: FontWeight.bold,fontSize: 18
                            ),),
                            SizedBox(height: 12,),
                            SizedBox(
                              height: 38,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [


                                  InkWell(
                                    onTap:(){
                                     if(amount > 1){
                                       FirebaseDatabase.instance.ref("cart")
                                           .child(FirebaseAuth.instance.currentUser!.uid.toString()).child(id).child("amount").set((amount-1).toString());
                                     }
                                    },
                                    child: CircleAvatar
                                      (
                                        child: Icon(Icons.exposure_minus_1,
                                        color: Colors.black,),
                                    backgroundColor: Colors.grey.withAlpha(40)),
                                  ),
                                  SizedBox(width: 8,),
                                  Text("$amount",style: TextStyle(
                                    color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(width: 8,),
                                  InkWell(
                                    onTap:(){
                                      if(amount >= 1){
                                        FirebaseDatabase.instance.ref("cart")
                                            .child(FirebaseAuth.instance.currentUser!.uid.toString())
                                            .child(id).child("amount").set("${amount+1}");
                                      }
                                    },
                                    child: CircleAvatar
                                      (
                                        child: Icon(Icons.plus_one,
                                        color: Colors.white,),
                                    backgroundColor: lightColorScheme.primary.withAlpha(120)),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap:(){
                                      FirebaseDatabase.instance.ref("cart")
                                          .child(FirebaseAuth.instance.currentUser!.uid.toString()).child(id).remove();
                                    },
                                    child: CircleAvatar(
                                        backgroundColor: Colors.red.withAlpha(40),
                                        child: Icon(Icons.delete_outline,
                                          color: Colors.red,)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),



                    ],
                  ),
                ),
              );
            },):Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("There is no products added to the cart yet",style: TextStyle(
                fontSize: 20,color: Colors.black54
              ),),
            ),
          )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const Text(
                  //       "Subtotal",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     Text(
                  //       "200 EGP",
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(height: 10),
                  // const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$price EGP",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: (){
                      if(cartProducts.isNotEmpty){
                        List brands = [];
                        products.forEach((key, value) {
                          var id =value["id"];
                          var from =value["from"];
                          // var pricee =value["price"];
                          if(cartProducts.contains(key)){
                            brands.add(from);
                            // Map o = cartValue.containsKey(key)?cartValue[key]:{};
                            // int amount = int.parse(o["amount"]);
                            // setState(() {
                            //   price = price + (double.parse(pricee)*amount);
                            // });
                          }
                        });
                        int r = 0;
                        brands.forEach((element) {
                          List pp = [];
                          List dd = [];
                          cartProducts.forEach((elementp) {
                            Map i = products.containsKey(elementp)?
                            products[elementp]:{};
                            Map ii = cartValue.containsKey(elementp)?
                            cartValue[elementp]:{};
                            var f = i.containsKey("from")?i["from"]:"";
                            var amount = ii.containsKey("amount")?ii["amount"]:"";
                            print("SSSSSSSSSss $amount mmmmmmmmmmm $ii");
                            if(f == element){
                              pp.add(elementp);
                              dd.add({"id":elementp,
                                "amount":amount});
                            }
                          });
                          var tp = getPriceWhileCheck(pp);
                          var ref = FirebaseDatabase.instance.ref("orders");
                          var orderId = ref.push().key.toString();
                          var upload = UploadProduct(orderId, tp,
                              FirebaseAuth.instance.currentUser!.uid.toString(), element
                              , dd);

                          ref.child(orderId).set(upload.toJson()).then((value){
                            r=r+1;
                            if(r==brands.length){
                              FirebaseDatabase.instance.ref("cart")
                                  .child(FirebaseAuth.instance.currentUser!.uid.toString()).remove();
                            }
                          });
                          // FirebaseDatabase.instance.ref("cart")
                          //    .child(FirebaseAuth.instance.currentUser!.uid.toString())
                          //    .child(widget.product["id"]).set(widget.product["id"]);

                        });

                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: cartProducts.isNotEmpty?lightColorScheme.primary:lightColorScheme.primary.withAlpha(30)
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text("Check Out",textAlign: TextAlign.center,style: TextStyle(
                            color: cartProducts.isNotEmpty?Colors.white:Colors.grey,fontSize: 19,fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (cartItems.isEmpty)
            Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          // for (var item in cartItems) ...[
          //   CartTile(
          //     item: item,
          //     onRemove: () {
          //       if (item.quantity != 1) {
          //         setState(() {
          //           item.quantity--;
          //         });
          //       }
          //     },
          //     onAdd: () {
          //       setState(() {
          //         item.quantity++;
          //       });
          //     },
          //     onRemoveItem: () {
          //       removeItem(item);
          //     },
          //   ),
          //   const SizedBox(height: 20),
          // ],
        ],
      ),
    );
  }

  void getPrice() {
    setState(() {
      price = 0;
    });
    products.forEach((key, value) {
      var id =value["id"];
      var pricee =value["price"];
      if(cartProducts.contains(key)){
        Map o = cartValue.containsKey(key)?cartValue[key]:{};
        int amount = int.parse(o["amount"]);
       if(mounted){
         setState(() {
           price = price + (double.parse(pricee)*amount);
         });
       }
      }
    });
  }

  String getPriceWhileCheck(List e) {
    double price = 0;
    products.forEach((key, value) {
      var id =value["id"];
      var pricee =value["price"];
      if(e.contains(key)){
        Map o = cartValue.containsKey(key)?cartValue[key]:{};
        int amount = int.parse(o["amount"]);
        // setState(() {
          price = price + (double.parse(pricee)*amount);
        // });
      }
    });
    return price.toString();
  }
}