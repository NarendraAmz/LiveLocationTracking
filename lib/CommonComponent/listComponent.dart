import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListClass extends StatefulWidget {
 
  double height;
  double width;
  Function didTap;
  Widget subChildWidget;
  String errorMessage;
  String textFont;
  Color textColor;
  FontWeight fontWeight;
  double fontSize;
 List<dynamic>  datalistArray;
 dynamic emptyObject;
 Function(int) subChild;

// ListClass({Key key, this.subChild}) : super(key: key);

  @override
  ListState createState() => new ListState();
  ListClass(
      { this.width, this.height, this.didTap,this.subChildWidget,this.errorMessage,this.fontSize,this.fontWeight,this.textColor,
      this.textFont,this.datalistArray, this.subChild});
}

class ListState extends State<ListClass> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        key: Key('social buttons'),
        padding: EdgeInsets.fromLTRB(0.0, 20, 0.0, 0.0),
        child: dataList());
  }

   Widget dataList() {
    return Container(
      height: widget.height != null ? widget.height : MediaQuery.of(context).size.height / 2,
      child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 50),
          child:
               widget.datalistArray != null  
                  ?
              dataListView()
          : errorClass(),
          ),
    );
  }


  Widget dataListView() {
    return
         widget.datalistArray.length != 0
            ?
        ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.transparent,
                ),
            padding: EdgeInsets.only(top: 10),
            itemCount: widget.datalistArray.length != null ? widget.datalistArray.length : 0,
            itemBuilder: (context, index) {
              return Container(child:widget.subChild(index),color: Colors.transparent,) ;
            }
            )
    : errorClass();
  }
  Widget errorClass(){
     return new Padding(
      padding: EdgeInsets.all(15),
      child: Center(
          child: Text(widget.errorMessage != null ? widget.errorMessage : 'No Data Found',
              style: TextStyle(
                color: widget.textColor != null ? widget.textColor : Colors.black,
                fontWeight: widget.fontWeight != null ? widget.fontWeight : FontWeight.bold,
                fontSize: widget.fontSize != null ? widget.fontSize : 16,
              ))),
    );
  }
}