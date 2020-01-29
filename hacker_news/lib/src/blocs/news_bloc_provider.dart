import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/news_bloc.dart';

class NewsBlocProvider extends InheritedWidget {
  final _bloc = NewsBloc();

  NewsBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static NewsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(NewsBlocProvider)
            as NewsBlocProvider)
        ._bloc;
  }
}
