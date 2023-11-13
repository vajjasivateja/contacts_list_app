import 'package:contacts_list_app/res/colors.dart';
import 'package:flutter/material.dart';

import '../contacts_api_integration/contacts_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(45),
              colors: [
                primaryBlueGradient2,
                primaryBlueGradient1,
                whiteColor,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 200),
                Container(
                  padding: EdgeInsets.all(60),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor.withOpacity(0.2),
                    border: Border.all(
                      color: whiteColor,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const FlutterLogo(size: 100),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome To Flutter",
                  style: TextStyle(color: blackColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please enter your details to continue",
                  style: TextStyle(color: blackColor, fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "User Name",
                  textFieldType: "username",
                  onChanged: (value) {
                    // Handle text changes
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Password",
                  textFieldType: "password",
                  onChanged: (value) {
                    // Handle text changes
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: secondaryBlue, fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ContactsScreen()),
                      (route) => false,
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String textFieldType;
  final Function(String value)? onChanged;

  const CustomTextField({required this.hintText, required this.textFieldType, this.onChanged, Key? key}) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.textFieldType == "password";
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: widget.textFieldType == "password"
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              )
            : null,
      ),
      onChanged: widget.onChanged,
    );
  }
}
