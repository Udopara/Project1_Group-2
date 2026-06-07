import "package:flutter/material.dart";

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

enum Gender { male, female}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 63, 81, 181),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "A",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Text("ALU Intercampus",
            style: TextStyle(
              color: const Color.fromARGB(255, 118, 68, 255),
              fontSize: 25,
              fontWeight: FontWeight.bold
            )
            ),
          ],
        ),
        centerTitle: false,

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 200, 210, 240),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Icon(
                        Icons.lock,
                        size: 40,
                        color: const Color.fromARGB(255, 63, 81, 181),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text("Welcome Back",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  SizedBox(height: 8),
                  Text("Sign in to stay connected with your campus community",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Text("Username",
                        style: TextStyle(
                          fontSize: 14,
                          
                        ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.person,
                              color: const Color.fromARGB(255, 63, 81, 181),
                            ),
                            hintText: "Enter your username",
                          )
                        ),
                        SizedBox(height: 16),
                        Text("Password",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          obscureText: _obscurePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: const Color.fromARGB(255, 63, 81, 181),
                            ),
                            hintText: "Enter your password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: const Color.fromARGB(255, 63, 81, 181),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                        },
                        child: Text("Forgot Password?"),
                      )
                    ]
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                        },
                        child: Text("Login"),
                      )
                    ]
                  ),
                  Text("------ or continue with ------",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                  ),
                  textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                        },
                        icon: Icon(Icons.login),
                        label: Text("Google"),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                      SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                        },
                        icon: Icon(Icons.school),
                        label: Text("Edu Portal"),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 63, 81, 181),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}