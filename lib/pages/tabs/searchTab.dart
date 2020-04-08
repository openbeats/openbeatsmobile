import 'package:flutter/material.dart';
import '../../widgets/tabsw/searchTabW.dart' as searchTabW;

class SearchTab extends StatefulWidget {
  // recieving passed values
  bool searchResultLoading;
  SearchTab(this.searchResultLoading);
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    print(widget.searchResultLoading);
    return Container(
      child: (widget.searchResultLoading)
          ? searchTabW.searchResultLoadingW()
          : null,
    );
  }
}
