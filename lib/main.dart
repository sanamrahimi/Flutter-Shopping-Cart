import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/screens/database/cart_provider.dart';
import 'package:shopping_cart/screens/cart/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Cartprovider(),
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            home: const ProducstList(),
          );
        },
      ),
    );
  }
}
