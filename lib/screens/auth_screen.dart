import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../functions/auth_functions.dart';
import './bottom_navigation_screen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RegExp email = RegExp(r"\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6}");
  RegExp password = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}");

  bool isLoading = false;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? const BottomNavigationScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                        height: 200,
                        width: 200,
                      ),
                      Image.asset(
                        "assets/images/name.png",
                        fit: BoxFit.contain,
                        width: 200,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              key: const ValueKey("email"),
                              autocorrect: false,
                              enableSuggestions: false,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.5,
                                    color: Colors.black54,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                ),
                                labelText: "Email",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your email";
                                } else if (!email
                                    .hasMatch(value.trim().toLowerCase())) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              key: const ValueKey("password"),
                              autocorrect: false,
                              controller: passwordController,
                              obscureText: true,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.5,
                                    color: Colors.black54,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(
                                  Icons.key,
                                ),
                                labelText: "Password",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter password";
                                } else if (!password.hasMatch(value.trim())) {
                                  return "Password must be between 8 to 15 characters and must contain atleast one uppercase, one lowercase and one digit.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (isLoading)
                              const CircularProgressIndicator.adaptive(),
                            if (!isLoading)
                              ElevatedButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  bool valid =
                                      _formKey.currentState!.validate();
                                  if (!valid) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  await AuthFunctions.loginChef(
                                    context,
                                    emailController.text.trim().toLowerCase(),
                                    passwordController.text.trim(),
                                  ).then(
                                    (value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (value) {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          BottomNavigationScreen.routeName,
                                          (route) => false,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Something went wrong, please try again.",
                                              textScaleFactor: 1,
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                                child: const Text(
                                  "Login",
                                  textScaleFactor: 1,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
