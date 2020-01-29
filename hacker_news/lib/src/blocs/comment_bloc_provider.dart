import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/comment_bloc.dart';

class CommentBlocProvider extends InheritedWidget {
  final _bloc = CommentBloc();

  CommentBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static CommentBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CommentBlocProvider)
            as CommentBlocProvider)
        ._bloc;
  }
}
