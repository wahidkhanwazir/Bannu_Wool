import 'package:bannuwool/order_models/bannumodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';

class CForm extends StatefulWidget {
  final List<CartItem> cartItems;

  const CForm({
    super.key,
    required this.cartItems,
  });

  @override
  State<CForm> createState() => _CFormState();
}

class _CFormState extends State<CForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  bool isBusy = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.04),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: width / 7,
                      child: Image.asset(
                        "assets/DirhamLogo.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Enter your name:',
                        enabledBorder: buildOutlineInputBorder(width),
                        errorBorder: buildOutlineInputBorder(width),
                        focusedBorder: buildOutlineInputBorder(width),
                        focusedErrorBorder: buildOutlineInputBorder(width),
                      ),
                      validator: MinLengthValidator(4,
                          errorText: 'Name must be at least 4 characters'),
                      controller: nameController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Contact no:',
                        enabledBorder: buildOutlineInputBorder(width),
                        errorBorder: buildOutlineInputBorder(width),
                        focusedBorder: buildOutlineInputBorder(width),
                        focusedErrorBorder: buildOutlineInputBorder(width),
                      ),
                      validator: MinLengthValidator(11,
                          errorText: 'Contact no. must have 11 digits'),
                      controller: contactController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Province',
                        enabledBorder: buildOutlineInputBorder(width),
                        errorBorder: buildOutlineInputBorder(width),
                        focusedBorder: buildOutlineInputBorder(width),
                        focusedErrorBorder: buildOutlineInputBorder(width),
                      ),
                      validator: MinLengthValidator(2,
                          errorText: 'No selected province').call,
                      controller: provinceController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'District:',
                        enabledBorder: buildOutlineInputBorder(width),
                        errorBorder: buildOutlineInputBorder(width),
                        focusedBorder: buildOutlineInputBorder(width),
                        focusedErrorBorder: buildOutlineInputBorder(width),
                      ),
                      validator: MinLengthValidator(2,
                          errorText: 'No selected district').call,
                      controller: districtController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Address:',
                        enabledBorder: buildOutlineInputBorder(width),
                        errorBorder: buildOutlineInputBorder(width),
                        focusedBorder: buildOutlineInputBorder(width),
                        focusedErrorBorder: buildOutlineInputBorder(width),
                      ),
                      validator: MinLengthValidator(4,
                          errorText: 'No address found').call,
                      controller: addressController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'City:',
                        enabledBorder: buildOutlineInputBorder(width),
                        errorBorder: buildOutlineInputBorder(width),
                        focusedBorder: buildOutlineInputBorder(width),
                        focusedErrorBorder: buildOutlineInputBorder(width),
                      ),
                      validator: MinLengthValidator(2,
                          errorText: 'Select your city').call,
                      controller: cityController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Container(
                      height: height * 0.07,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * 0.05),
                        color: Colors.blue,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          } else {
                            setState(() {
                              isBusy = true;
                            });

                            BanuModel banuModel = BanuModel(
                              name: nameController.text.trim(),
                              contactNo: int.parse(contactController.text.trim()),
                              totalAmount: cartProvider.calculateTotal().toInt(),
                              totalItems: cartProvider.cartItems.fold(0, (total, item) => total + item.quantity).toInt(),
                              province: provinceController.text.trim(),
                              district: districtController.text.trim(),
                              address: addressController.text.trim(),
                              city: cityController.text.trim(),
                              userId: FirebaseAuth.instance.currentUser?.uid,
                              orderComplete: false,
                              currentDate: DateTime.now(),
                              items: cartProvider.cartItems.map((item) {
                                return {
                                  'title': item.title,
                                  'price': item.price,
                                  'imageUrl': item.imageUrl,
                                  'quantity': item.quantity,
                                };
                              }).toList(),
                            );

                            await BanuModel.collection().add(banuModel);
                            cartProvider.clearCart();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SubmissionPage(),
                              ),
                            );
                          }
                          setState(() {
                            isBusy = false;
                          });

                          // Clear controllers
                          nameController.clear();
                          contactController.clear();
                          districtController.clear();
                          cityController.clear();
                          addressController.clear();
                          provinceController.clear();
                        },
                        child: Text('Submit',
                          style: TextStyle(fontSize: width * 0.05, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isBusy)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder(double width) {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(width * 0.05),
    );
  }
}

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.25),
          child: Column(
            children: [
              Text(
                'Order successfully submitted',
                style: TextStyle(fontSize: width * 0.05, color: Colors.white),
              ),
              CircleAvatar(
                radius: width * 0.08,
                child: Icon(Icons.check, size: width * 0.12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
