import 'package:bannuwool/provider/cart_provider.dart';
import 'package:bannuwool/user_ui/form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartInfo extends StatefulWidget {
  const CartInfo({super.key});

  @override
  State<CartInfo> createState() => _CartInfoState();
}

class _CartInfoState extends State<CartInfo> {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Shopping summary'),
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(child: Text('No item selected'))
          : Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: cartProvider.cartItems.map((item) {
                        return Padding(
                          padding: EdgeInsets.all(width * 0.005),
                          child: Stack(
                            children: [
                              Container(
                                height: height / 5.4,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all()),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: height / 5.4,
                                      width: height / 5.4,
                                      child: CachedNetworkImage(
                                        imageUrl: item.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(width * 0.002),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('➣ Design: ${item.title}',
                                            style: TextStyle(fontSize: (width / 100) * 3.5),
                                          ),
                                          Text('➣ Item price:  R.s ${item.price}/-',
                                            style: TextStyle(fontSize: (width / 100) * 3.5),
                                          ),
                                          Text('➣ Items: ${item.quantity}',
                                            style: TextStyle(fontSize: (width / 100) * 3.5),
                                          ),
                                          Container(
                                            height: height / 17,
                                            width: width / 2.5,
                                            decoration: BoxDecoration(
                                                border: Border.all()),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceAround,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (item.quantity > 1) {
                                                          item.quantity--;
                                                        }
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove)),
                                                Text(item.quantity.toString(),
                                                  style: TextStyle(fontSize: (width / 100) * 5),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        item.quantity++;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.add)),
                                              ],
                                            ),
                                          ),
                                          Text('➣ Total price:  R.s ${item.price * item.quantity}',
                                            style: TextStyle(fontSize: (width / 100) * 3.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text('Are you sure you want to remove this item from the cart?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                cartProvider.removeFromCart(item);
                                                Navigator.of(context).pop();
                                              },
                                              child:
                                              const Text('Confirm'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete_sharp,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(width * 0.003),
                      child: Container(
                        height: height / 8.4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            border: Border.all()),
                        child: Column(
                          children: [
                            Text('Total designs: ${cartProvider.cartItems.map((item) => item.title).toSet().length}',
                              style: TextStyle(color: Colors.white, fontSize: (width / 100) * 3.7),
                            ),
                            Text('Total items: ''${cartProvider.cartItems.fold(0, (total, item) => total + item.quantity)}',
                              style: TextStyle(color: Colors.white,fontSize: (width / 100) * 3.7),
                            ),
                            Text(
                              'Total amount: R.s ''${cartProvider.calculateTotal()}',
                              style: TextStyle(color: Colors.white, fontSize: (width / 100) * 3.7),
                            ),
                            Text('+ Delivery charges',
                              style: TextStyle(color: Colors.white, fontSize: (width / 100) * 3.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: height * 0.005,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CForm(cartItems: cartProvider.cartItems)),
                  );
                },
                child: Container(
                  height: height / 15,
                  width: width / 3,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(width * 0.04),
                  ),
                  child: Center(
                      child: Text(
                        'Check out',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: (width / 100) * 6),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
