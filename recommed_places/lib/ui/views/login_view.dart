import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recommed_places/base/base_widget.dart';
 import 'package:recommed_places/core/constants/app_contstants.dart';
import 'package:recommed_places/core/services/authentication_service.dart';
import 'package:recommed_places/ui/shared/app_colors.dart';
import 'package:recommed_places/ui/widgets/login_header.dart';
import 'package:recommed_places/viewmodel/login_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: LoginViewModel(
        service: Provider.of<AuthenticationService>(context),
      ),
      onModelReady: _onModelReady,
      child: LoginHeader(
        controller: controller,
      ),
      builder: (BuildContext context, LoginViewModel model, Widget child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                child,
                model.busy
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text("Login"),
                        color: Colors.blue,
                        onPressed: () async {
                          bool response = await model.login(controller.text);
                          if (response) {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();

                            sharedPreferences.setBool(
                                RoutePaths.USER_LOGGED_IN, true);

                             Navigator.of(context)
                                .pushReplacementNamed(RoutePaths.Home);
                          }
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  _onModelReady(LoginViewModel model) {}
}
