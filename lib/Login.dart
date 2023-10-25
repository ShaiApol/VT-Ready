import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/components.dart';

import 'home.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool emailValid = true;
  bool passwordValid = true;

  bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return (password.length >= 8 &&
        RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
            .hasMatch(password));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/getting_started.png"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(child: SizedBox.shrink()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [SubTitleText(text: "Login to your Account")],
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email"),
                      SizedBox(
                        height: 8,
                      ),
                      if (!emailValid) ...[
                        Row(children: [
                          Expanded(
                              child: Text(
                            "Please enter a valid email",
                            style: TextStyle(color: Colors.red),
                          ))
                        ]),
                        SizedBox(
                          height: 8,
                        )
                      ],
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF28404F),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: "Enter your Email",
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: InputBorder.none,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text("Password"),
                      SizedBox(
                        height: 8,
                      ),
                      if (!passwordValid) ...[
                        Row(children: [
                          Expanded(
                              child: Text(
                            "Please enter a valid password",
                            style: TextStyle(color: Colors.red),
                          ))
                        ]),
                        SizedBox(
                          height: 8,
                        )
                      ],
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF28404F),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Enter your password",
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: InputBorder.none,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                emailValid = isEmailValid(emailController.text);
                                passwordValid =
                                    isPasswordValid(passwordController.text);
                              });
                              if (emailValid && passwordValid) {
                                try {
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  auth
                                      .signInWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Forgot your password?"),
                  TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: ResetPasswordModal());
                            });
                      },
                      child: Text("Reset password."))
                ],
              ),
              Expanded(child: SizedBox.shrink())
            ],
          )),
    );
  }
}

class ResetPasswordModal extends StatefulWidget {
  _ResetPasswordModalState createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  TextEditingController emailController = TextEditingController();
  bool emailValid = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          image: DecorationImage(
              image: AssetImage("assets/images/forget_password.png"),
              fit: BoxFit.cover)),
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter your email address to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "We will send a password reset link to this email. If you do not receive the email, please check your spam folder.",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            if (!emailValid) ...[
              Row(children: [
                Expanded(
                    child: Text(
                  "Please enter a valid email",
                  style: TextStyle(color: Colors.red),
                ))
              ]),
              SizedBox(
                height: 8,
              )
            ],
            Row(
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF28404F),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ))
                      ],
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () async {
                    if (emailController.text != "" &&
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text)) {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      auth.sendPasswordResetEmail(email: emailController.text);
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        emailValid = false;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Send Reset Link",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
