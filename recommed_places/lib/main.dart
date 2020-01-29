import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import 'package:recommed_places/core/constants/app_contstants.dart';
import 'package:recommed_places/base/provider_setup.dart';
import 'package:recommed_places/base/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool isUserLoggedIn =
       sharedPreferences.getBool(RoutePaths.USER_LOGGED_IN) ?? false;
  runApp(MyApp(isUserLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;

  MyApp(this.isUserLoggedIn);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: isUserLoggedIn ? RoutePaths.Home : RoutePaths.Login,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
