import 'dart:async';

import 'validation_mixing.dart';

// class Bloc extends Object with ValidationMixing {
class Bloc extends ValidationMixing {
  final _emailController = StreamController<String>();
  final _passwordController = StreamController<String>();

  //add data to the sink
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // get the data
  Stream<String> get email => _emailController.stream;
  Stream<String> get password => _passwordController.stream;

  // Stream<String> get email => _emailController.stream.transform(emailValidator);
  // Stream<String> get password => _passwordController.stream.transform(passwordValidator);

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
