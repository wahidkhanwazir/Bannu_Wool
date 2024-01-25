import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../order_models/bannumodel.dart';

class DrawerHistoryDetail extends StatefulWidget {
  final BanuModel orderDetails;
  final List<Map<String, dynamic>> orderItems;

  const DrawerHistoryDetail({
    super.key,
    required this.orderDetails,
    required this.orderItems,
  });

  @override
  State<DrawerHistoryDetail> createState() => _DrawerHistoryDetailState();
}

class _DrawerHistoryDetailState extends State<DrawerHistoryDetail> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Order Details',
          style: TextStyle(fontSize:  width / 17),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.03, top: height * 0.01),
            child: Row(
              children: [
                Text(
                  'Order Name: ${widget.orderDetails.name}',
                  style: TextStyle(fontSize:  width / 27),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.03),
            child: Row(
              children: [
                Text(
                  'Contact Number: 0${widget.orderDetails.contactNo}',
                  style: TextStyle(fontSize:  width / 27),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.03),
            child: Row(
              children: [
                Text(
                  'District: ${widget.orderDetails.district}',
                  style: TextStyle(fontSize:  width / 27),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.03),
            child: Row(
              children: [
                Text(
                  'City: ${widget.orderDetails.city}',
                  style: TextStyle(fontSize:  width / 27),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.03),
            child: Row(
              children: [
                Text(
                  'Address: ${widget.orderDetails.address}',
                  style: TextStyle(fontSize:  width / 27),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.03),
            child: Row(
              children: [
                Text(
                  'Total amount: R.s ${widget.orderDetails.totalAmount}.0''+ delivery charges',
                  style: TextStyle(fontSize: width / 27),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.orderItems.length,
              itemBuilder: (context, index) {
                final item = widget.orderItems[index];
                return ListTile(
                  title: Text(
                    'Item: ${item['title']}',
                    style: TextStyle(fontSize: width / 24),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quantity: ${item['quantity']}',
                        style: TextStyle(fontSize: width / 27),
                      ),
                    ],
                  ),
                  leading: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _PhotoViewWidget(
                            imageUrl: item['imageUrl'],
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: item['imageUrl'],
                      width: height / 13,
                      height: height / 13,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(color: Colors.blue),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoViewWidget extends StatelessWidget {
  final String imageUrl;

  const _PhotoViewWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
          backgroundDecoration: BoxDecoration(
            color: Colors.yellow.shade50,
          ),
        ),
      ),
    );
  }
}
