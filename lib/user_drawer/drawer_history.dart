import 'package:bannuwool/login/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../order_models/bannumodel.dart';
import 'drawer.dart';
import 'drawer_history_detail.dart';

class DrawerHistory extends StatefulWidget {
  const DrawerHistory({super.key});

  @override
  State<DrawerHistory> createState() => _Page4State();
}

class _Page4State extends State<DrawerHistory> {
  late Future<QuerySnapshot<BanuModel>> information =
  BanuModel.collection().where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Your orders',style: TextStyle(fontSize: height/30),),
      ),
      body: FirebaseAuth.instance.currentUser == null
          ? Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('User not found please ',style: TextStyle(fontSize: width/25),),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Signin()));
                  },
                  child: Text('Login',style: TextStyle(fontSize: width/20,fontWeight: FontWeight.bold,color: Colors.blue),)),
              Text(' to your account',style: TextStyle(fontSize: width/25)),
            ],
          ),)
          : FutureBuilder<QuerySnapshot<BanuModel>>(
           future: information,
           builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
           }
            if(snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
           }

            return  snapshot.data!.docs.isEmpty ? const Center(child: Text('No orders yet')) : ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                BanuModel customerInfo = snapshot.data!.docs[index].data();

              // Convert items to the expected type
              List<Map<String, dynamic>> convertedItems =
              (customerInfo.items).cast<Map<String, dynamic>>();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DrawerHistoryDetail(
                          orderDetails: customerInfo,
                          orderItems: convertedItems,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.blue)),
                    title: Text(customerInfo.name.toString(),
                        style: TextStyle(fontSize: height/40, fontWeight: FontWeight.bold)),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(customerInfo.currentDate as DateTime),
                      style: TextStyle(fontSize: height/50),),
                    leading: CircleAvatar(
                      radius: height/25,
                      backgroundImage: AssetImage('assets/DirhamLogo.png'),
                    ),
                    trailing: Text('(${index + 1})', style: TextStyle(fontSize: height/45)),
                  ),
                ),
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
