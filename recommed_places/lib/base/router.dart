import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recommed_places/core/constants/app_contstants.dart';
import 'package:recommed_places/ui/views/add_new_place.dart';
import 'package:recommed_places/ui/views/home_view.dart';
import 'package:recommed_places/ui/views/login_view.dart';
import 'package:recommed_places/ui/views/map_view.dart';
import 'package:recommed_places/ui/views/place_detail_view.dart';
import 'package:recommed_places/viewmodel/home_view_model.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginView());

      case RoutePaths.AddNew:
        final HomeViewModel model = settings.arguments as HomeViewModel;
        return MaterialPageRoute(
          builder: (_) => AddNewPlace(
            model: model,
          ),
        );

      case RoutePaths.Detail:
        final String id = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => PlaceDetailView(
            id: id,
          ),
        );

      case RoutePaths.Map:
        List args = settings.arguments as List;
        Function(LatLng latLng) fun = args[0];
        LatLng latLng = args[1];
        bool selectOnMap = args[2];

        return MaterialPageRoute(
          builder: (_) {
            return MapView(
              onLocationCallback: fun,
              currentLocation: latLng,
              selectOnMap: selectOnMap,
            );
          },
          fullscreenDialog: true,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
