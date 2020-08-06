import 'package:flutter/material.dart';
import 'package:flutter_maps/polysharedlist.dart';
import 'package:flutter_maps/sharedlist.dart';
class TabHomePage extends StatefulWidget {
  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Shared List"),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
          new Tab(icon: new Icon(Icons.list)),
          new Tab(
            icon: new Icon(Icons.favorite),
          ),
         
        ],
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,),
        bottomOpacity: 1,
      ),
      body: TabBarView(
          children: [
        MySharedListPage(),
      PolyMySharedListPage()
       // new Text("This is chat Tab View"),
        
      ],
      controller: _tabController,),
    );
  }
}