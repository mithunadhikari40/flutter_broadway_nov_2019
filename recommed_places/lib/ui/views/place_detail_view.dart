import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recommed_places/base/base_widget.dart';
import 'package:recommed_places/core/constants/app_contstants.dart';
import 'package:recommed_places/core/models/places.dart';
import 'package:recommed_places/core/services/home_service.dart';
import 'package:recommed_places/helpers/image_helper.dart';
import 'package:recommed_places/ui/shared/ui_helpers.dart';
import 'package:recommed_places/viewmodel/home_view_model.dart';

class PlaceDetailView extends StatelessWidget {
  final String id;

  PlaceDetailView({this.id});

//  var height = AppBar().preferredSize.height;
//
//  final _controller = ScrollController();
//
//  String text = '';
//
//  @override
//  void initState() {
//    super.initState();
//    _controller.addListener(() {
//      setScrollListener();
//    });
//  }
//
//  void setScrollListener() {
//    print("The defalut appbar height is $height");
//    ScrollDirection direction = _controller.position.userScrollDirection;
//    var distance = _controller.position.pixels;
//
//    if (direction == ScrollDirection.forward) {
//      setState(() {
//        text = '';
//      });
//    } else {
//      if (distance > height * 1.5) {
//        setState(() {
//          text = 'This is the appbar';
//        });
//      }
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      onModelReady: _init,
      child: buildErrorView(),
      model: HomeViewModel(
        homeService: Provider.of<HomeService>(context, listen: false),
      ),
      builder: _buildDetailSection,
    );
  }

  Widget buildErrorView() {
    return Center(
      child: Text("Looks like we do not have that item as of now"),
    );
  }

  Widget _buildDetailSection(
      BuildContext context, HomeViewModel model, Widget child) {
    final place = model.findById(id);
    return Scaffold(
//      appBar: AppBar(
//        title: Text(place.title),
//        leading: _buildBackArrow(context),
//      ),
      body: place == null ? child : _buildPlaceDetailSection(place, context),
    );
  }

  Widget _buildPlaceDetailSection(Place place, BuildContext context) {
    final size = MediaQuery.of(context).size;
    var fileExist = ImageHelper.fileExists(place.imagePath);
    return CustomScrollView(
//      controller: _controller,

      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.blue,
//          title: Text(place.title),
          floating: false,
          flexibleSpace: buildFlexibleSpaceBar(place, fileExist, size),
          expandedHeight: size.height / 2,
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Text("""
            In by an appetite no humoured returned informed. Possession so comparison inquietude he he conviction no decisively. Marianne jointure attended she hastened surprise but she. Ever lady son yet you very paid form away. He advantage of exquisite resolving if on tolerably. Become sister on in garden it barton waited on.

Oh acceptance apartments up sympathize astonished delightful. Waiting him new lasting towards. Continuing melancholy especially so to. Me unpleasing impossible in attachment announcing so astonished. What ask leaf may nor upon door. Tended remain my do stairs. Oh smiling amiable am so visited cordial in offices hearted.

May musical arrival beloved luckily adapted him. Shyness mention married son she his started now. Rose if as past near were. To graceful he elegance oh moderate attended entrance pleasure. Vulgar saw fat sudden edward way played either. Thoughts smallest at or peculiar relation breeding produced an. At depart spirit on stairs. She the either are wisdom praise things she before. Be mother itself vanity favour do me of. Begin sex was power joy after had walls miles.

Day handsome addition horrible sensible goodness two contempt. Evening for married his account removal. Estimable me disposing of be moonlight cordially curiosity. Delay rapid joy share allow age manor six. Went why far saw many knew. Exquisite excellent son gentleman acuteness her. Do is voice total power mr ye might round still.
Day handsome addition horrible sensible goodness two contempt. Evening for married his account removal. Estimable me disposing of be moonlight cordially curiosity. Delay rapid joy share allow age manor six. Went why far saw many knew. Exquisite excellent son gentleman acuteness her. Do is voice total power mr ye might round still.
Day handsome addition horrible sensible goodness two contempt. Evening for married his account removal. Estimable me disposing of be moonlight cordially curiosity. Delay rapid joy share allow age manor six. Went why far saw many knew. Exquisite excellent son gentleman acuteness her. Do is voice total power mr ye might round still.
"""),
              UIHelper.verticalSpaceSmall,
              Text(
                place.address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              UIHelper.verticalSpaceSmall,
              FlatButton(
                child: Text("View on map"),
                onPressed: () {
                  _pushMapScreen(context, place);
                },
              )
            ],
          ),
        )
      ],
    );
  }

  FlexibleSpaceBar buildFlexibleSpaceBar(
      Place place, bool fileExist, Size size) {
    return FlexibleSpaceBar(
      title: Text(place.title),
      background: Hero(
        tag: place.id,
        child: fileExist
            ? Image.file(
          File(place.imagePath),
          fit: BoxFit.fitWidth,
          width: size.width,
        )
            :
//                      image: CachedNetworkImageProvider(place.imagePath),
        Image.network(
          place.serverImagePath,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  void _pushMapScreen(BuildContext context, Place place) {
    Navigator.of(context).pushNamed(
      RoutePaths.Map,
      arguments: [
        _onMapClickCb,
        LatLng(place.latitude, place.longitude),
        false
      ],
    );
  }

  void _onMapClickCb(LatLng latLng) {}

  _init(HomeViewModel model) {
  }
}
