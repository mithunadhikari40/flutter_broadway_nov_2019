import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hacker_news/src/models/news_model.dart';
import 'package:hacker_news/src/widgets/loading_container.dart';

class CommentListTile extends StatelessWidget {
  final int commentId;
  final int depth;
  final Map<int, Future<NewsModel>> map;

  const CommentListTile({this.commentId, this.map, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: map[commentId],
      builder: (BuildContext context, AsyncSnapshot<NewsModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return buildComments(snapshot.data);
      },
    );
  }

  Widget buildComments(NewsModel data) {
    final commentList = data.kids.map((kidId) {
      return CommentListTile(
        commentId: kidId,
        map: map,
        depth: depth + 1,
      );
    });

    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.only(left: depth * 16.0, right: 16),
          title: Html(data: data.text),
          subtitle: Text(data.by == '' ? 'Deleted' : 'by: ${data.by}'),
        ),
        Divider(
          height: 5,
        ),
        ...commentList,

      ],
    );
  }
}
