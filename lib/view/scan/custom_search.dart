import 'package:driver_app/utils/const.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    return Column(
      children: <Widget>[
        ListView.builder(
          itemCount: 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(""),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: primaryColorHome,
      padding: EdgeInsets.all(32),
      child: Text(
        "Ae bình tĩnh, chưa search được đâu!"
            "\nKhi nào rảnh mới làm được"
        , style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
