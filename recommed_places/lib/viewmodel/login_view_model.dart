import 'package:flutter/material.dart';
import 'package:recommed_places/core/services/authentication_service.dart';
import 'package:recommed_places/base/base_model.dart';

class LoginViewModel extends BaseModel {
  AuthenticationService service;

  LoginViewModel({@required this.service});



 Future<bool> login(String userId) async {
    setBusy(true);
    int id = int.tryParse(userId);
    bool response = await service.login(id);
    setBusy(false);
    return response;
  }
}
