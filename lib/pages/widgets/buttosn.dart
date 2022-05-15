import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




/// ---------------------------
///     Raised Buttons widgets goes here.
/// ---------------------------

class ButtonRaised extends StatefulWidget {
  static const routeName = '/ButtonRaised';
  @override
  _ButtonRaisedState createState() => _ButtonRaisedState();
}

class _ButtonRaisedState extends State<ButtonRaised> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        /// ---------------------------
        ///     Building scrollable content goes here.
        /// ---------------------------

        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //====================
                        //    enable  raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RaisedButton(
                            child: Text("Raised Button"),
                            onPressed: () {},
                          ),
                        ),
                       

                        //====================
                        //    disable  raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RaisedButton(
                            child: Text("Disable Raised Button"),
                            onPressed: null,
                          ),
                        ),
                      ],
                    ),
                    new Container(
                      margin: EdgeInsets.all(8.0),
                      height: 1.0,
                      color: Colors.lightBlueAccent,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //====================
                        //    Under Line   raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RaisedButton(
                            child: Text("Under Line "),
                            shape: UnderlineInputBorder(),
                            onPressed: () {},
                          ),
                        ),
                   

                        //====================
                        //   Out Line raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RaisedButton(
                            child: Text("Out Line"),
                            shape: OutlineInputBorder(),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                   

                        //====================
                        //  Shaped Rec raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RaisedButton(
                            child: Text(
                              "Shaped Rectengle Border",
                              style: TextStyle(color: Colors.deepOrangeAccent),
                            ),
                            shape: Border.all(),
                            onPressed: () {},
                          ),
                        ),
                   

                        //====================
                        //  Shaped Rounded raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RaisedButton(
                            child: Text("Shaped Rounded Border"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.black)),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    new Container(
                      margin: EdgeInsets.all(8.0),
                      height: 1.0,
                      color: Colors.lightGreen,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //====================
                        //  Shaped Rectengle raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RaisedButton(
                            child: Text(
                              "Shaped Rectengle fill color",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.red,
                            onPressed: () {},
                          ),
                        ),
                   

                        //====================
                        //  Shaped Rectengle Rounded raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RaisedButton(
                            child: Text("Shaped Rectengle Rounded fill color",
                                style: TextStyle(color: Colors.white)),
                            color: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    new Container(
                      margin: EdgeInsets.all(8.0),
                      height: 1.0,
                      color: Colors.deepOrangeAccent,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //====================
                        // Icon Button raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RaisedButton.icon(
                            icon: Icon(Icons.ac_unit,
                                color: Colors.white,
                                textDirection: TextDirection.ltr),
                            label: Text(
                              "Icon Button",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.deepPurple,
                            onPressed: () {},
                          ),
                        ),
                   

                        //====================
                        //Disabled  Icon Button raised button
                        //====================

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RaisedButton.icon(
                            label: Text("Disabled Icon Button",
                                style: TextStyle(color: Colors.white)),
                            color: Colors.amber,
                            icon: Icon(Icons.ac_unit, color: Colors.white),
                            onPressed: null,
                          ),
                        ),
                      ],
                    ),
               

                    //====================
                    //Shaped Rounded Gradient Button raised button
                    //====================
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RaisedButton(
                        child: Text("Shaped Rounded Gradient"),
                        shape: BorderDirectional(
                            bottom: BorderSide(
                                color: Colors.lightGreenAccent, width: 1.8),
                            start:
                            BorderSide(color: Colors.lightBlue, width: 1.8),
                            end: BorderSide(
                                color: Colors.lightGreenAccent, width: 1.8),
                            top: BorderSide(color: Colors.lightBlue, width: 1.8)),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
