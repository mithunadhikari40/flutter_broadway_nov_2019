import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/news_bloc.dart';
import 'package:hacker_news/src/blocs/news_bloc_provider.dart';
import 'package:hacker_news/src/widgets/news_list_tile.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = NewsBlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Trending News!"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.theaters,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildNewsList(bloc),
    );
  }

  _buildNewsList(NewsBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIdsStream,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            await bloc.clearCache();
            await bloc.fetchTopIds();
//            return bloc.clearCache();
          },
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              bloc.fetchItem(snapshot.data[index]);

              return NewsListTile(snapshot.data[index]);
            },
          ),
        );
      },
    );
  }
}
