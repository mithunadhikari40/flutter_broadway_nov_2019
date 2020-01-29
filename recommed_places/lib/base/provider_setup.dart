import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:recommed_places/core/services/api.dart';
import 'package:recommed_places/core/services/authentication_service.dart';
import 'package:recommed_places/core/services/db_provider.dart';
import 'package:recommed_places/core/services/home_service.dart';

List<SingleChildWidget> providers = [
  ...independentProviders,
  ...dependentProviders,
//  ...uiConsumableProvider,
];

List<SingleChildWidget> independentProviders = [
  Provider.value(value: Api()),
  Provider.value(value: DbProvider())
];

List<SingleChildWidget> dependentProviders = [
  ProxyProvider<Api, AuthenticationService>(
    update: (BuildContext context, Api api, AuthenticationService auth) {
      return AuthenticationService(api: api);
    },
  ),
  ProxyProvider2<Api, DbProvider, HomeService>(
    update: (BuildContext context, Api api, DbProvider dbProvider,
        HomeService home) {
      return HomeService(api: api, dbProvider: dbProvider);
    },
  )
];
//
//List<SingleChildWidget> uiConsumableProvider = [
//  StreamProvider<User>(
//    create: (BuildContext context) {
//      return Provider.of<AuthenticationService>(context).user;
//    },
//  ),
//];
