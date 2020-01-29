import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:recommed_places/base/base_widget.dart';
import 'package:recommed_places/core/constants/app_contstants.dart';
import 'package:recommed_places/core/models/places.dart';
import 'package:recommed_places/core/services/home_service.dart';
import 'package:recommed_places/helpers/image_helper.dart';
import 'package:recommed_places/viewmodel/home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      child: buildTextView(),
      model: HomeViewModel(
        homeService: Provider.of<HomeService>(context),
      ),
      onModelReady: _init,
      builder: _buildHomeView,
    );
  }

  Widget buildTextView() {
    return Center(
      child: Text("No items to view. Try adding some items"),
    );
  }

  _init(HomeViewModel model) {
    //do some initialization steps here
//    model.checkInternetConnection();
    model.getAllPlaces();
    model.getAllDataFromServer();
    model.syncAllData();
  }

  Widget _buildHomeView(
      BuildContext context, HomeViewModel model, Widget child) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Awesome places"),
        actions: <Widget>[
          _buildChangeThemeWidget(context),
          _buildAddNewPlace(context, model),
          _buildSyncService(context, model),
        ],
      ),
      body: model.busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : model.places.length == 0 ? child : buildPlaceList(model),
    );
  }

  Widget _buildChangeThemeWidget(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.theaters,
      ),
      onPressed: _changeTheme,
    );
  }

  void _changeTheme() {
//    bool isDark = themeService.getCurrentTheme ?? false;
//    themeService.changeTheme(!isDark);
//    print("The current changing theme is $isDark");
  }

  _buildAddNewPlace(BuildContext context, HomeViewModel model) {
    return IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(RoutePaths.AddNew, arguments: model);
        });
  }

  Widget buildPlaceList(HomeViewModel model) {
    print('something model here');
    return RefreshIndicator(
        child: ListView.builder(
          itemCount: model.places.length,
          itemBuilder: (BuildContext context, int index) {
            final place = model.places[index];
            final fileExists = ImageHelper.fileExists(place.imagePath);
            return buildListTile(place, fileExists, context, model);
          },
        ),
        onRefresh: () {
          return _wipeLocalData(model);
        });
  }

  Dismissible buildListTile(
      Place place, bool fileExists, BuildContext context, HomeViewModel model) {
    return Dismissible(
      background: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: ListTile(
          leading: Icon(Icons.delete),
          title: Text("Delete"),
        ),
        width: double.infinity,
      ),
      secondaryBackground: Container(
        alignment: Alignment.center,
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 300),
          trailing: Icon(Icons.update),
          title: Text("Update"),
        ),
        color: Colors.green,
        width: double.infinity,
      ),
      key: Key(place.id),
      onDismissed: (direction) {
        _onItemDismiss(place, direction, model);
      },
      child: Container(
        child: ListTile(
          leading: Hero(
            tag: place.id,
            child: CircleAvatar(
              backgroundImage: fileExists
                  ? FileImage(
                      File(place.imagePath),
                    )
                  : CachedNetworkImageProvider(place.serverImagePath),
            ),
          ),
          title: Text(place.title),
          subtitle: Text(place.address),
          onTap: () {
            Navigator.of(context)
                .pushNamed(RoutePaths.Detail, arguments: place.id);
          },
        ),
      ),
    );
  }

  Future _wipeLocalData(HomeViewModel model) async {
    await model.wipeLocalData();
//    await model.getAllDataFromServer();
  }

  _buildSyncService(BuildContext context, HomeViewModel model) {
    var isConnected = model.connectivity != ConnectivityResult.none ?? false;
    print("The connectivity is $isConnected");

    return isConnected
        ? IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              Fluttertoast.showToast(msg: "The sync button is clicked");
              model.syncAllData();
            },
          )
        : IconButton(
            icon: Icon(Icons.sync_disabled),
            onPressed: null,
          );
  }

  void _onItemDismiss(
      Place place, DismissDirection direction, HomeViewModel model) {
    if (direction == DismissDirection.horizontal &&
        direction == DismissDirection.startToEnd) {
      Fluttertoast.showToast(msg: "from the left to the right");
    } else if (direction == DismissDirection.horizontal &&
        direction == DismissDirection.endToStart) {
      Fluttertoast.showToast(msg: "from the right to the left");
    }

//    model.removeItem(place.id);
  }
}
