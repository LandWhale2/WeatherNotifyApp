import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rainnotifyapp/utils/Util.dart';
import 'package:http/http.dart' as http;



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String SearchCity;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  Search(){
    var formstate = _formkey.currentState;
    if(formstate.validate()){
      formstate.save();
      setState(() {});
    }else{

      Fluttertoast.showToast(msg: '내용을 입력해주세요 !',
        backgroundColor: Colors.redAccent, textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              height:MediaQuery.of(context).size.height,
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage('assets/rain4.jpg',),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 100,),
                  Row(//도시검색창 ROW
                    children: <Widget>[
                      SizedBox(width: MediaQuery.of(context).size.width/9,),
                      Container(
                        height:MediaQuery.of(context).size.height/15,
                        width: MediaQuery.of(context).size.width/1.8,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          border: Border.all(width: 0.1),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Form(
                          key: _formkey,
                          child: TextFormField(
                            onSaved: (input)=> SearchCity = input,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).textScaleFactor*20,
                              color: Colors.white,
                              fontFamily: 'RIDI',
                            ),
                            decoration: InputDecoration(
                              hintText: '도시명을 입력해주세요. ',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                  fontFamily: 'RIDI',
                                  fontWeight: FontWeight.w500),
                              contentPadding: EdgeInsets.only(left: 20, top: 13)
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: Search,
                        child: Container(
                          height:MediaQuery.of(context).size.height/15,
                          width: MediaQuery.of(context).size.width/5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 0.1),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Center(
                            child: Text(
                              '검색',
                              style: TextStyle(
                                  fontSize : MediaQuery.of(context).textScaleFactor*25,
                                  fontFamily: 'RIDI',
                                  fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: WeatherWidget(SearchCity),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map> getWeather(String city)async{
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${ApiKey}&units=metric';
    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget WeatherWidget(String city){
    return FutureBuilder(
      future: getWeather(city == null? defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        Map content = snapshot.data;
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(
            valueColor:AlwaysStoppedAnimation<Color>(Colors.white),),);
        }
        if(content['name'] == null){
          return Container();
        }
        return Container(
          margin: EdgeInsets.only(left: 130, top: 20),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10, right: 120),
                child: Text(
                  content['name'].toString()??'',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).textScaleFactor*30,
                    fontFamily: 'RIDI',
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '${content['main']['temp'].toString()} °C\n'??'',
                  style: TextStyle(
                      fontFamily: 'NIX',
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: MediaQuery.of(context).textScaleFactor*30),
                ),
                subtitle: ListTile(
                  title: Text(
                    '최고: ${content['main']['temp_max']}\n'
                    '최저: ${content['main']['temp_min']}\n'
                    '습도: ${content['main']['humidity']}\n',
                    style: TextStyle(color: Colors.white,
                        fontSize: MediaQuery.of(context).textScaleFactor*25,
                        fontFamily: 'NIX'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
