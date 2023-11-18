
import 'package:badges/badges.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/screens/database/cart_provider.dart';
import 'package:shopping_cart/screens/database/db_helper.dart';

import '../../Models/cart_model.dart';



class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart  = Provider.of<Cartprovider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<Cartprovider>(
                builder: (context, value , child){
                  return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                },

              ),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              child: Icon(Icons.shopping_cart,color: Colors.white,),
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future:cart.getData() ,
                builder: (context , AsyncSnapshot<List<Cart>> snapshot){
                  if(snapshot.hasData){

                    if(snapshot.data!.isEmpty){
                      return Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [

                            SizedBox(height: 20,),
                            Text('Cart is empty' ,style: Theme.of(context).textTheme.headline5),
                            SizedBox(height: 20,),

                          ],
                        ),
                      );
                    }else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index){
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image(
                                            height: 100,
                                            width: 100,
                                            image: NetworkImage(snapshot.data![index].image.toString()),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(snapshot.data![index].productName.toString() ,
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                    ),
                                                    InkWell(
                                                        onTap: (){
                                                          dbHelper!.delete(snapshot.data![index].id!);
                                                          cart.removeCounter();
                                                          cart.removeTotaPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                        },
                                                        child: Icon(Icons.delete,))
                                                  ],
                                                ),

                                                SizedBox(height: 5,),
                                                Text(snapshot.data![index].unitTag.toString() +" "+r"$"+ snapshot.data![index].productPrice.toString() ,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                SizedBox(height: 5,),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: (){


                                                    },
                                                    child:  Container(
                                                      height: 35,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: Colors.orangeAccent,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child:  Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            InkWell(
                                                                onTap: (){

                                                                  int quantity =  snapshot.data![index].quantity! ;
                                                                  int price = snapshot.data![index].initialPrice!;
                                                                  quantity--;
                                                                  int? newPrice = price * quantity ;

                                                                  if(quantity > 0){
                                                                    dbHelper!.updateQuantity(
                                                                        Cart(
                                                                            id: snapshot.data![index].id!,
                                                                            productId: snapshot.data![index].id!.toString(),
                                                                            productName: snapshot.data![index].productName!,
                                                                            initialPrice: snapshot.data![index].initialPrice!,
                                                                            productPrice: newPrice,
                                                                            quantity: quantity,
                                                                            unitTag: snapshot.data![index].unitTag.toString(),
                                                                            image: snapshot.data![index].image.toString())
                                                                    ).then((value){
                                                                      newPrice = 0 ;
                                                                      quantity = 0;
                                                                      cart.removeTotaPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                    }).onError((error, stackTrace){
                                                                      print(error.toString());
                                                                    });
                                                                  }

                                                                },
                                                                child: Icon(Icons.remove , color: Colors.white,)),
                                                            Text( snapshot.data![index].quantity.toString(), style: TextStyle(color: Colors.white)),
                                                            InkWell(
                                                                onTap: (){
                                                                  int quantity =  snapshot.data![index].quantity! ;
                                                                  int price = snapshot.data![index].initialPrice!;
                                                                  quantity++;
                                                                  int? newPrice = price * quantity ;

                                                                  dbHelper!.updateQuantity(
                                                                      Cart(
                                                                          id: snapshot.data![index].id!,
                                                                          productId: snapshot.data![index].id!.toString(),
                                                                          productName: snapshot.data![index].productName!,
                                                                          initialPrice: snapshot.data![index].initialPrice!,
                                                                          productPrice: newPrice,
                                                                          quantity: quantity,
                                                                          unitTag: snapshot.data![index].unitTag.toString(),
                                                                          image: snapshot.data![index].image.toString())
                                                                  ).then((value){
                                                                    newPrice = 0 ;
                                                                    quantity = 0;
                                                                    cart.addTotaPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                  }).onError((error, stackTrace){
                                                                    print(error.toString());
                                                                  });
                                                                },
                                                                child: Icon(Icons.add , color: Colors.white,)),

                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }

                  }
                  return Text('') ;
                }),
            Consumer<Cartprovider>(builder: (context, value, child){
              return Visibility(
                visible: value.getTotaPrice().toStringAsFixed(2) == "0.00" ? false : true,
                child: Column(
                  children: [
                    ReusableWidget(title: 'Sub Total', value: r'$'+value.getTotaPrice().toStringAsFixed(2),),
                    ReusableWidget(title: 'Discout 5%', value: r'$'+'20',),
                    ReusableWidget(title: 'Total', value: r'$'+value.getTotaPrice().toStringAsFixed(2),)
                  ],
                ),
              );
            })
          ],
        ),
      ) ,
    );
  }
}


class ReusableWidget extends StatelessWidget {
  final String title , value ;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title , style: Theme.of(context).textTheme.subtitle2,),
          Text(value.toString() , style: Theme.of(context).textTheme.subtitle2,)
        ],
      ),
    );
  }
}

















// import 'package:badges/badges.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shopping_cart/Models/cart_model.dart';
// import 'package:shopping_cart/screens/database/cart_provider.dart';
// import 'package:shopping_cart/screens/database/db_helper.dart';
//
// class CartScreen extends StatefulWidget {
//   const CartScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   DBHelper? dbHelper = DBHelper();
//
//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<Cartprovider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Products'),
//         centerTitle: true,
//         actions: [
//           Center(
//             child: Badge(
//               badgeContent: Consumer<Cartprovider>(
//                 builder: (context, value, child) {
//                   return Text(
//                     value.getCounter().toString(),
//                     style: const TextStyle(color: Colors.white),
//                   );
//                 },
//               ),
//               animationDuration: const Duration(milliseconds: 300),
//               child: const Icon(Icons.shopping_cart),
//             ),
//           ),
//           const SizedBox(
//             width: 20,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             FutureBuilder(
//                 future: cart.getData(),
//                 builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
//                   if (snapshot.hasData) {
//                     if (snapshot.data!.isEmpty) {
//                       return Center(
//                         child: Text('Cart is empty'),
//                       );
//                     } else {
//                       return Expanded(
//                         child: ListView.builder(
//                             itemCount: snapshot.data!.length,
//                             itemBuilder: (context, index) {
//                               return Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisSize: MainAxisSize.max,
//                                         children: [
//                                           Image(
//                                               height: 100,
//                                               width: 100,
//                                               image: NetworkImage(snapshot
//                                                   .data![index].image
//                                                   .toString())),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Expanded(
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                       snapshot.data![index]
//                                                           .productName
//                                                           .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           fontSize: 16),
//                                                     ),
//                                                     InkWell(
//                                                         onTap: () {
//                                                           dbHelper!.delete(
//                                                               snapshot
//                                                                   .data![index]
//                                                                   .id!);
//                                                           cart.removeCounter();
//                                                           cart.removeTotaPrice(
//                                                               double.parse(
//                                                             snapshot
//                                                                 .data![index]
//                                                                 .productPrice
//                                                                 .toString(),
//                                                           ));
//                                                         },
//                                                         child: const Icon(
//                                                             Icons.delete))
//                                                   ],
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 Text(
//                                                   snapshot.data![index].unitTag
//                                                           .toString() +
//                                                       "  " +
//                                                       r"$" +
//                                                       snapshot.data![index]
//                                                           .productPrice
//                                                           .toString(),
//                                                   style: const TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 16),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 Align(
//                                                   alignment:
//                                                       Alignment.centerRight,
//                                                   child: InkWell(
//                                                     onTap: () {},
//                                                     child: Container(
//                                                       height: 35,
//                                                       width: 100,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.green,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(5),
//                                                       ),
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(4.0),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             InkWell(
//                                                               onTap: () {
//                                                                 int quantity =
//                                                                     snapshot
//                                                                         .data![
//                                                                             index]
//                                                                         .quantity!;
//                                                                 int price = snapshot
//                                                                     .data![
//                                                                         index]
//                                                                     .initialPrice!;
//                                                                 quantity--;
//                                                                 int? newPrice =
//                                                                     price *
//                                                                         quantity;
//
//                                                                 if (quantity >
//                                                                     0) {
//                                                                   dbHelper!
//                                                                       .updateQuantity(Cart(
//                                                                           id: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .id!,
//                                                                           productId: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .id!
//                                                                               .toString(),
//                                                                           productName: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .productName!,
//                                                                           initialPrice: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .initialPrice!,
//                                                                           productPrice:
//                                                                               newPrice,
//                                                                           quantity:
//                                                                               quantity,
//                                                                           unitTag: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .unitTag
//                                                                               .toString(),
//                                                                           image: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .image
//                                                                               .toString()))
//                                                                       .then(
//                                                                           (value) {
//                                                                     newPrice =
//                                                                         0;
//                                                                     quantity =
//                                                                         0;
//                                                                     cart.addTotaPrice(double.parse(snapshot
//                                                                         .data![
//                                                                             index]
//                                                                         .initialPrice!
//                                                                         .toString()));
//                                                                   }).onError((error,
//                                                                           stackTrace) {
//                                                                     print(error
//                                                                         .toString());
//                                                                   });
//                                                                 }
//                                                               },
//                                                               child: const Icon(
//                                                                 Icons.remove,
//                                                                 color: Colors
//                                                                     .white,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               snapshot
//                                                                   .data![index]
//                                                                   .quantity
//                                                                   .toString(),
//                                                               style:
//                                                                   const TextStyle(
//                                                                 color: Colors
//                                                                     .white,
//                                                               ),
//                                                             ),
//                                                             InkWell(
//                                                                 onTap: () {
//                                                                   int quantity = snapshot
//                                                                       .data![
//                                                                           index]
//                                                                       .quantity!;
//                                                                   int price = snapshot
//                                                                       .data![
//                                                                           index]
//                                                                       .initialPrice!;
//                                                                   quantity++;
//                                                                   int?
//                                                                       newPrice =
//                                                                       price *
//                                                                           quantity;
//
//                                                                   dbHelper!
//                                                                       .updateQuantity(Cart(
//                                                                           id: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .id!,
//                                                                           productId: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .id!
//                                                                               .toString(),
//                                                                           productName: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .productName!,
//                                                                           initialPrice: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .initialPrice!,
//                                                                           productPrice:
//                                                                               newPrice,
//                                                                           quantity:
//                                                                               quantity,
//                                                                           unitTag: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .unitTag
//                                                                               .toString(),
//                                                                           image: snapshot
//                                                                               .data![
//                                                                                   index]
//                                                                               .image
//                                                                               .toString()))
//                                                                       .then(
//                                                                           (value) {
//                                                                     newPrice =
//                                                                         0;
//                                                                     quantity =
//                                                                         0;
//                                                                     cart.addTotaPrice(double.parse(snapshot
//                                                                         .data![
//                                                                             index]
//                                                                         .initialPrice!
//                                                                         .toString()));
//                                                                   }).onError((error,
//                                                                           stackTrace) {
//                                                                     print(error
//                                                                         .toString());
//                                                                   });
//                                                                 },
//                                                                 child:
//                                                                     const Icon(
//                                                                   Icons.add,
//                                                                   color: Colors
//                                                                       .white,
//                                                                 )),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }),
//                       );
//                     }
//                   }
//                   return const Text('');
//                 }),
//             Consumer<Cartprovider>(builder: (context, value, child) {
//               return Visibility(
//                 visible: value.getTotaPrice().toStringAsFixed(2) == "0.00"
//                     ? false
//                     : true,
//                 child: Column(
//                   children: [
//                     ReusableWidget(
//                         title: 'Sub Total',
//                         value: r'$' + value.getTotaPrice().toStringAsFixed(2)),
//                     ReusableWidget(title: 'Discount 5%', value: r'$' + '20'),
//                     ReusableWidget(
//                         title: 'Total',
//                         value: r'$' + value.getTotaPrice().toStringAsFixed(2)),
//                   ],
//                 ),
//               );
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ReusableWidget extends StatelessWidget {
//   final String title, value;
//
//   const ReusableWidget({required this.title, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: Theme.of(context).textTheme.subtitle2,
//           ),
//           Text(
//             value.toString(),
//             style: Theme.of(context).textTheme.subtitle2,
//           )
//         ],
//       ),
//     );
//   }
// }
