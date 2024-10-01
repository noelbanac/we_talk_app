import 'package:flutter/material.dart';
import 'package:wetalk_application_2/screens/home.dart';
import 'package:wetalk_application_2/screens/register.dart';
import 'package:wetalk_application_2/styles/button.dart'; 
import 'package:wetalk_application_2/styles/colors.dart';
import 'package:wetalk_application_2/utils/config.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackground(context),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ConstrainedBox( 
                constraints: const BoxConstraints( 
                  maxWidth: 400,
                  maxHeight: 450,
              ),
              child: Card(
                color: Colors.white.withOpacity(0.8),
                shape: RoundedRectangleBorder( 
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "SIGN IN",
                            style: TextStyle(
                              color: Color(MyColors.primary),
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 60),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Config.primaryColor,
                            decoration: const InputDecoration(
                              hintText: 'Type your email address here',
                              labelText: 'Email address',
                              alignLabelWithHint: true,
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          Config.spaceSmall,
                          TextFormField(
                            controller: _passController,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: Config.primaryColor,
                            obscureText: obsecurePass,
                            decoration: InputDecoration(
                              hintText: 'Type your password here',
                              labelText: 'Password',
                              alignLabelWithHint: true,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obsecurePass = !obsecurePass;
                                  });
                                },
                                icon: obsecurePass
                                    ? const Icon(
                                        Icons.visibility_off_outlined,
                                        color: Colors.black38,
                                      )
                                    : const Icon(
                                        Icons.visibility_outlined,
                                        color: Config.primaryColor,
                                      ),
                              ),
                            ),
                          ),
                          Config.spaceVerySmall,
                          
                          Button(
                            width: double.infinity,
                            title: 'Sign In',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Get.to(() => const Home());
                              }
                            },
                            disable: false,
                            ),
                            const SizedBox(height: 5),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const SignUpPage());
                              },
                              child: const Text(
                                "Don't have an account? Register here.",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                )
              ),
          ),
        ),
      ),
    ],
  ),
);
}

  Widget buildBackground(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/intro_image.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(1), 
              BlendMode.dstATop
            ),
          ),
        ),
        child: const Scaffold(
        backgroundColor: Colors.black45,
      ),
    );
  }

}
