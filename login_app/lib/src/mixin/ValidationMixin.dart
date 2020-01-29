class ValidationMixin {
  String validateEmail(String email) {
    if (email.isEmpty) {
      return null;
    }

//         if (email.isEmpty) return null;
    //set up a rule to return  error message if the email is not valid else return null
    if (email.contains("@") && email.contains(".")) {
      return null;
    }

    return "Please enter a valid email";
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      return null;
    }

    if (password.length > 4) {
      return null;
    }
    return "Password must be at least 4 characters long";
  }
}
