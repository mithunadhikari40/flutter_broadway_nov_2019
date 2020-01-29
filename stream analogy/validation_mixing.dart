import 'dart:async';

class ValidationMixing {
  final emailValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains("@") && email.contains(".")) {
        sink.add(email);
      } else {
        sink.addError("Invalid email address");
      }
    },
  );
  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length > 4) {
        sink.add(password);
      } else {
        sink.addError("Password too short");
      }
    },
  );
}
