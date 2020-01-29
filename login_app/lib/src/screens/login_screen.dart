import 'package:flutter/material.dart';
import 'package:login_app/src/mixin/ValidationMixin.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  //create a key and pass it to the form widget
  final refKey = GlobalKey<FormState>();

  String email;
  String password;

  bool validEmail = false;
  bool validPass = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Form(
          autovalidate: true,
          key: refKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildEmailField(),
              buildPasswordField(),
              Container(
                margin: EdgeInsets.only(bottom: 12),
              ),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) {
        if (value.contains("@") && value.contains(".")) {
          setState(() {
            validEmail = true;
          });
        } else {
          setState(() {
            validEmail = false;
          });
        }
      },
      validator: validateEmail,
      onSaved: (String val) {
        print("The email address is $val");
        email = val;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "someone@example.com",
       ),
    );
  }

  buildPasswordField() {
    return TextFormField(
      onChanged: (String value) {
        if (value.length > 4) {
          setState(() {
            validPass = true;
          });
        } else {
          setState(() {
            validPass = false;
          });
        }
      },
      obscureText: true,
      validator: validatePassword,
      onSaved: (String val) {
        print("The current password is $val");
        //update the password
        password = val;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "password",
      ),
    );
  }

  Widget buildSubmitButton() {
    return Container(
//      width: double.infinity,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
          child: Text("Submit"),
          color: Colors.blue[400],
          onPressed: validEmail && validPass
              ? () {
                  var isValid = refKey.currentState.validate();
                  if (isValid) {
                    refKey.currentState.save();
                    print("User entered email $email and password $password");
                  }
                  //tell the Form widget to validate all of its children *TextFormField*
                }
              : null),
    );
  }
}
