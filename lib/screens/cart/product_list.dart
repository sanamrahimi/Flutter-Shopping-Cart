import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/Models/cart_model.dart';
import 'package:shopping_cart/screens/cart/cart_screen.dart';
import 'package:shopping_cart/screens/database/cart_provider.dart';
import 'package:shopping_cart/screens/database/db_helper.dart';

class ProducstList extends StatefulWidget {
  const ProducstList({Key? key}) : super(key: key);

  @override
  State<ProducstList> createState() => _ProducstListState();
}

class _ProducstListState extends State<ProducstList> {
  DBHelper? dbHelper = DBHelper();

  List ProductName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List productUnit = [
    'KG',
    'Dozen',
    'KG',
    'KG',
    'Dozen',
    'Dozen',
    'KG',
  ];
  List productPrice = [10, 20, 30, 40, 50, 60, 70];
  List productImage = [

    'https://images.pexels.com/photos/1132047/pexels-photo-1132047.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/1132047/pexels-photo-1132047.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/1132047/pexels-photo-1132047.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/1132047/pexels-photo-1132047.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/1132047/pexels-photo-1132047.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/1132047/pexels-photo-1132047.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/1132047/pexels-photo-1132047.jpeg?auto=compress&cs=tinysrgb&w=600',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cartprovider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products List', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                badgeContent: Consumer<Cartprovider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_cart,color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: ProductName.length,
                itemBuilder: (context, index) {
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
                                  image: NetworkImage(
                                      productImage[index].toString())),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ProductName[index].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      productUnit[index].toString() +
                                          "  " +
                                          r"$" +
                                          productPrice[index].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          dbHelper!
                                              .insert(Cart(
                                                  id: index,
                                                  productId: index.toString(),
                                                  productName:
                                                      ProductName[index]
                                                          .toString(),
                                                  initialPrice:
                                                      productPrice[index],
                                                  productPrice:
                                                      productPrice[index],
                                                  quantity: 1,
                                                  unitTag: productUnit[index]
                                                      .toString(),
                                                  image: productImage[index]
                                                      .toString()))
                                              .then((value) {
                                            print('product is added to cart');

                                            cart.addTotaPrice(double.parse(
                                                productPrice[index]
                                                    .toString()));
                                            cart.addCounter();
                                          }).onError((error, stackTrace) {
                                            print(error.toString());
                                          });
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.orangeAccent,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Add to Cart',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
