import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import 'package:http/http.dart' as http;


class SignUpForm extends StatefulWidget {

  SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController phonenumber = TextEditingController();

  TextEditingController adresse = TextEditingController();

  TextEditingController role = TextEditingController();

  bool _isNotValidate = false;

  void registerUser() async{
    if(username.text.isNotEmpty && password.text.isNotEmpty && email.text.isNotEmpty && phonenumber.text.isNotEmpty && adresse.text.isNotEmpty && role.text.isNotEmpty ){
      var registerBody = {
        "username" :username.text,
        "password" :password.text,
        "email" :email.text,
        "phoneNumber" :phonenumber.text,
        "adresse" :adresse.text,
        "role" :role.text,
      };
      var response= await http.post(Uri.parse('http://localhost:7001/user/users'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(registerBody)
      );
      var jsonResponse = json.decode(response.body);
      print(jsonResponse['status']);
      if(jsonResponse['status']){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ),
        );
      }else{
        print("something went wrong");
      }
    }else{
      setState(() {
        _isNotValidate=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: username,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,

            decoration:  InputDecoration(
              hintText: "username",
              errorText: _isNotValidate ? "Enter correct inforamtions" :null,
              errorStyle: TextStyle(color: Colors.red),
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: password,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration:  InputDecoration(
                errorText: _isNotValidate ? "Enter correct inforamtions" :null,
                errorStyle: TextStyle(color: Colors.red),
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration:  InputDecoration(
              errorText: _isNotValidate ? "Enter correct inforamtions" :null,
              errorStyle: TextStyle(color: Colors.red),
              hintText: "email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
          ),
          SizedBox(height: 25),
          TextFormField(
            controller: phonenumber,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration:  InputDecoration(
              errorText: _isNotValidate ? "Enter correct inforamtions" :null,
              errorStyle: TextStyle(color: Colors.red),
              hintText: "phoneNumber",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone),
              ),
            ),
          ),
          SizedBox(height: 25),
          TextFormField(
            controller: adresse,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration:  InputDecoration(
              hintText: "adresse",
              errorText: _isNotValidate ? "Enter correct inforamtions" :null,
              errorStyle: TextStyle(color: Colors.red),
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.place),
              ),
            ),
          ),
          SizedBox(height: 25),
          TextFormField(
            controller: role,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration:  InputDecoration(
              hintText: "role",
              errorText: _isNotValidate ? "Enter correct inforamtions" :null,
              errorStyle: TextStyle(color: Colors.red),
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person_search),
              ),
            ),
          ),
          SizedBox(height: 10),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: ()=> {
              registerUser()
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}