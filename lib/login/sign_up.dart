import 'package:bannuwool/user_ui/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpasswordController = TextEditingController();
  bool isbusy = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(
                    height: height/6,
                    width: height/6,
                    child: Image.asset('assets/DirhamLogo.png')),
                const SizedBox(height: 20,),
                TextFormField(
                  decoration:  InputDecoration(
                    suffixIcon:  const Icon(Icons.email),
                    labelText: 'email:',
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    errorBorder: buildOutlineInputBorder(),
                    focusedErrorBorder: buildOutlineInputBorder(),
                  ),
                  validator: EmailValidator(errorText: 'invalid email').call,
                  controller: emailController,
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  decoration:  InputDecoration(
                    suffixIcon:  const Icon(Icons.password),
                    labelText: 'password:',
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    errorBorder: buildOutlineInputBorder(),
                    focusedErrorBorder: buildOutlineInputBorder(),
                  ),
                  validator: MinLengthValidator(8, errorText: 'password must at least 8 character').call,
                  controller: passwordController,
                ),
                const SizedBox(height: 20,),
                TextFormField(
                    decoration:  InputDecoration(
                      suffixIcon:  const Icon(Icons.password),
                      labelText: 'confirm password:',
                      enabledBorder: buildOutlineInputBorder(),
                      focusedBorder: buildOutlineInputBorder(),
                      errorBorder: buildOutlineInputBorder(),
                      focusedErrorBorder: buildOutlineInputBorder(),
                    ),
                    controller: confirmpasswordController,
                    validator: (confirmpasswordController) {
                      if(confirmpasswordController!.isEmpty)
                      {
                        return 'please enter confirm password';
                      }if(confirmpasswordController!=passwordController.text)
                      {
                        return 'password not matched';
                      }
                    }
                ),
                const SizedBox(height: 30,),
                Container(
                  height: height/13,
                  width: width/2.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                    boxShadow: const [
                      BoxShadow(color: Colors.grey,
                          blurRadius: 1,
                          spreadRadius: 0.5,
                          offset: Offset(0,2)
                      )
                    ],
                  ),
                  child: isbusy
                      ? const Center(
                        child: CircularProgressIndicator(
                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : TextButton(
                      onPressed: () async {
                        try{
                          setState(() {
                            isbusy = true;
                          });
                          if(!formkey.currentState!.validate())
                          {
                            return;
                          }
                          {
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString()
                            );
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const HomePage()));
                            emailController.clear();
                            passwordController.clear();
                            confirmpasswordController.clear();
                          }
                        }on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('This email is already in use. Please use a different email.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('An error occurred. Please check network connection.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                        finally {
                          setState(() {
                            isbusy = false;
                          });
                        }
                      },
                       child: Text('Sign up',style: TextStyle(fontSize: width/15,color: Colors.white),)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue
      ),
      borderRadius: BorderRadius.circular(15),
    );
  }
}