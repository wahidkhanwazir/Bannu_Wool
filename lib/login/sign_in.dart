import 'package:bannuwool/login/sign_up.dart';
import 'package:bannuwool/user_ui/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
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
                  validator: (value) {
                    final emailError = EmailValidator(errorText: 'Invalid email').call(value);
                    if (emailError != null) {
                      return emailError;
                    } else if (value?.isEmpty ?? true) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    final passwordError =
                    MinLengthValidator(8, errorText: 'Password must be at least 8 characters').call(value);
                    if (passwordError != null) {
                      return passwordError;
                    } else if (value?.isEmpty ?? true) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                  controller: passwordController,
                ),
                const SizedBox(height: 30,),
                Container(
                  height: 55,
                  width: 130,
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
                        if (!formkey.currentState!.validate()) {
                          return;
                        } else {
                          try {
                            setState(() {
                              isbusy = true;
                            });
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString(),
                            );
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                            const HomePage()));
                            emailController.clear();
                            passwordController.clear();
                           } catch (e) {
                            if (e is FirebaseAuthException) {
                              String errorMessage = '';

                              switch (e.code) {
                                case 'user-not-found':
                                  errorMessage = 'User not found. Please check your email or sign up.';
                                  break;
                                case 'wrong-password':
                                  errorMessage = 'Wrong password. Please try again.';
                                  break;
                                case 'invalid-email':
                                  errorMessage = 'Invalid email format. Please enter a valid email address.';
                                  break;
                                case 'user-disabled':
                                  errorMessage = 'This account has been disabled. Please contact support.';
                                  break;
                                default:
                                  errorMessage = 'User not found.';
                                  break;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                           }

                          finally {
                            setState(() {
                              isbusy = false;
                            });
                          }
                        }
                      },
                       child: Text('Sign in',style: TextStyle(fontSize: width/15,color: Colors.white),)),
                ),
                const SizedBox(height: 20,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account  ",style: TextStyle(fontSize: height/45),),
                    InkWell(
                      child: Text('Sign up',style: TextStyle(fontSize: height/37,fontWeight: FontWeight.bold,color: Colors.blue),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Signup()));
                      },
                    )
                  ],
                )
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