import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cart_detail/cart_info.dart';
import '../login/sign_in.dart';
import '../provider/cart_provider.dart';
import '../user_drawer/drawer.dart';

class ClothesDetail extends StatefulWidget {
  final String? design;
  final int? colors;

  const ClothesDetail({
    super.key,
    required this.design,
    required this.colors,
  });

  @override
  State<ClothesDetail> createState() => _ClothesDetailState();
}

class _ClothesDetailState extends State<ClothesDetail> {
  dynamic size, height, width;

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    double cardHeight = height / 5;
    double cardFontSize = (width / 100) * 4;
    double buttonHeight = height / 14;
    double buttonWidth = width / 3;
    double buttonFontSize = (width / 100) * 4;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Colors for ${widget.design} (${widget.colors})',
          style: TextStyle(fontSize: (width / 100) * 5),
        ),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const CartInfo()));
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
                        color: Colors.red, shape: BoxShape.circle),
                    child: Center(
                        child: Text(
                          cartProvider.cartItems.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        )),
                  ),
                )
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('design', isEqualTo: widget.design)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final colors = snapshot.data!.docs;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              final imageUrl = color['image'] as String?;
              final price = color['price'] as String?;
              bool isItemWithColorInCart = cartProvider.cartItems.any(
                    (item) =>
                item.title == widget.design &&
                    item.imageUrl == imageUrl,
              );

              return Stack(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          child: SizedBox(
                            width: width / 2.5,
                            height: cardHeight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        backgroundColor: Colors.blue,
                                      ),
                                      body: Center(
                                        child: PhotoView(
                                          imageProvider:
                                          CachedNetworkImageProvider(
                                              imageUrl),
                                          minScale: PhotoViewComputedScale
                                              .contained *
                                              0.8,
                                          maxScale: PhotoViewComputedScale
                                              .covered *
                                              2,
                                          backgroundDecoration: BoxDecoration(
                                            color: Colors.yellow.shade50,
                                          ),
                                          loadingBuilder:
                                              (context, event) {
                                            if (event == null)
                                              return const CircularProgressIndicator();
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: event.cumulativeBytesLoaded /
                                                    (event.expectedTotalBytes ??
                                                        1),
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                          const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Design: ${widget.design}',
                                  style: TextStyle(
                                      fontSize: cardFontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Price: R.s $price/-',
                                  style: TextStyle(fontSize: cardFontSize),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: InkWell(
                      onTap: () {
                        if (FirebaseAuth.instance.currentUser?.uid ==
                            null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login to your account first'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signin()));
                        } else if (isItemWithColorInCart) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Item is already in cart!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        } else {
                          CartItem items = CartItem(
                            title: widget.design.toString(),
                            price: double.parse(price!),
                            imageUrl: imageUrl,
                          );
                          cartProvider.addToCart(items);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Item added to cart!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade300,
                          borderRadius:
                          const BorderRadius.only(bottomRight: Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Add to cart',
                              style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.shopping_cart_outlined, size: (width / 100) * 7,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      drawer: const Drawer(
        child: DrawerPage(),
      ),
    );
  }
}
