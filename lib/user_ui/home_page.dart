import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../cart_detail/cart_info.dart';
import '../provider/cart_provider.dart';
import '../user_drawer/drawer.dart';
import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int getColorsCount(String design, List<QueryDocumentSnapshot> items) {
    return items.where((item) => item['design'] == design).length;
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    double cardHeight = height / 4.7;
    double cardFontSize = (width / 100) * 3.8;
    double subtitleFontSize = (width / 100) * 3.5;

    return Scaffold(
      backgroundColor: Colors.lime.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Bannu wool'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 30,
                ),
                tooltip: 'Open shopping cart',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartInfo()),
                  );
                },
              ),
              if (cartProvider.cartItems.isNotEmpty)
                Positioned(
                  right: 1,
                  top: -3,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        cartProvider.cartItems.length.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
      body: CustomMaterialIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 2)),
        indicatorBuilder: (context, controller) {
          return Icon(
            Icons.ac_unit,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          );
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: height / 3.7,
                        width: width / 1,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1,
                              spreadRadius: 0.5,
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(70),
                            bottomRight: Radius.circular(70),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 45),
                          child: Image.asset(
                            "assets/DirhamLogo2.png",
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: SizedBox(
                          height: height / 10,
                          width: 80,
                          child: Image.asset("assets/DirhamLogo.png"),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 5, right: 5),
                    child: Container(
                      height: height / 13,
                      width: width / 1,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                            color: Colors.grey,
                          )
                        ],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Image.asset(
                                "assets/Text.png",
                                scale: width * 0.004,
                              ),
                            ),
                            Text(
                              "All Pakistan delivery",
                              style: TextStyle(
                                  fontSize: (width / 100) * 4,
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Select a design ⤵",
                          style: TextStyle(
                              fontSize: (width / 100) * 4,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('items').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                      child: const Center(
                          child: CircularProgressIndicator()));
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SliverToBoxAdapter(
                      child: const Center(
                          child: Text(
                              'Please check your internet connection')));
                }

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Center(
                          child: Text('Error: ${snapshot.error}')));
                }

                final items = snapshot.data!.docs;

                Set<String> uniqueDesigns = <String>{};
                for (var item in items) {
                  uniqueDesigns.add(item['design'] as String? ?? '');
                }

                List<String> uniqueDesignList = uniqueDesigns.toList();

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 8 / 9.5,
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final design = uniqueDesignList[index];
                      var firstItem =
                      items.firstWhere((item) => item['design'] == design);
                      final imageUrl = firstItem['image'] as String?;
                      int colors = getColorsCount(design, items);

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClothesDetail(
                                  design: design,
                                  colors: colors,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: SizedBox(
                                  height: cardHeight,
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  children: [
                                    Text('Design: $design',
                                      style: TextStyle(
                                        fontSize: cardFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Available colors: $colors',
                                      style: TextStyle(
                                        fontSize: subtitleFontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: uniqueDesignList.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      drawer: const Drawer(
        child: DrawerPage(),
      ),
    );
  }
}

class Utils {
  toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
