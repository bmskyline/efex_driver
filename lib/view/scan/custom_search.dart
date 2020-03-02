import 'package:driver_app/data/model/order_model.dart';
import 'package:driver_app/utils/const.dart';
import 'package:driver_app/view/scan/list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate {

  final ListProvider provider;
  final List<Order> orders;
  List<Order> result = List();

  CustomSearchDelegate(this.provider, this.orders);

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
  String get searchFieldLabel => 'Mã đơn hàng';

  @override
  Widget buildResults(BuildContext context) {
    result.clear();
    orders.forEach((e) {
      if(e.trackingNumber.contains(query)) {
        result.add(e);
      }
    });

    return ChangeNotifierProvider<ListProvider>.value(
      value: provider,
      child: Consumer<ListProvider>(builder: (context, value, child) {
        return Container(
          color: primaryColorHome,
          padding: EdgeInsets.all(16.0),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(color: Colors.white, thickness: 0.5,);
            },
            itemCount: result.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: (){
                  value.list.contains(result[index].trackingNumber)
                      ? value.remove(result[index].trackingNumber)
                      : value.add(result[index].trackingNumber);
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        result[index].trackingNumber,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                    Checkbox(
                      value: value.list.contains(result[index].trackingNumber),
                      checkColor: Colors.white,
                      onChanged: null,
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    result.clear();
    orders.forEach((e) {
      if(e.trackingNumber.contains(query)) {
        result.add(e);
      }
    });

    return ChangeNotifierProvider<ListProvider>.value(
      value: provider,
      child: Consumer<ListProvider>(builder: (context, value, child) {
        return Container(
          color: primaryColorHome,
          padding: EdgeInsets.all(16.0),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(color: Colors.white, thickness: 0.5,);
            },
            itemCount: result.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: (){
                  value.list.contains(result[index].trackingNumber)
                      ? value.remove(result[index].trackingNumber)
                      : value.add(result[index].trackingNumber);
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        result[index].trackingNumber,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                    Checkbox(
                      value: value.list.contains(result[index].trackingNumber),
                      checkColor: Colors.white,
                      onChanged: null,
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
