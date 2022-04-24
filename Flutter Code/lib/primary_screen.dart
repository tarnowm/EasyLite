import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu_item.dart';
import 'menu_items.dart';

int LDRValue = 0;
int PIRValue = 0;
int actValue = 0;
int manValue = 0;
int LDRIN = 0;
String LDRUpdate = "0";
const dogPic = 'https://www.prestigeanimalhospital.com/sites/default/files/styles/large/public/australian-shepherd-dog-breed-info.jpg?itok=VAYK7S5A';

/* WRITE FIELDS */
Future<http.Response> writeFields(int ldrV, int pirV, int actV, int manM, int ldrIn) async {
  final response = await http
      .get(Uri.parse("https://api.thingspeak.com/update?api_key=GC7MIJJU643NIPD4&field1="+ldrV.toString()+"&field2="+pirV.toString()+"&field3="+actV.toString()+"&field4="+manM.toString()+"&field5="+ldrIn.toString()));

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception("Failed to Write Fields");
  }
}

/* READ FIELDS */
Future<List> readFields() async {
  final response = await http
      .get(Uri.parse("https://api.thingspeak.com/channels/1656875/feeds.json?api_key=T8S2OWK502FFUB1C&results=1"));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    var jString = (json['feeds']).toString();
    var list = jString.split(",");
    var thingSpeakList = List<int>.filled(5, 0);

    /* Extract LDR Reading from json */
    var ldrField = list[2].toString();
    String ldrRead = ldrField.substring(9, 12);
    thingSpeakList[0] = int.parse(ldrRead);

    /* Extract PIR Reading from json */
    var pirField = list[3].toString();
    String pirRead = pirField.substring(9, 10);
    thingSpeakList[1] = int.parse(pirRead);

    /* Extract Actuator State Reading from json */
    var actField = list[4].toString();
    String actRead = actField.substring(9,10);
    thingSpeakList[2] = int.parse(actRead);

    /* Extract Manual Mode Status from json */
    var manField = list[5].toString();
    String manRead = manField.substring(9,10);
    thingSpeakList[3] = int.parse(manRead);

    /* Extract LDR User Input from json */
    var ldrInField = list[6].toString();
    String ldrInRead = ldrInField.substring(9,12);
    thingSpeakList[4] = int.parse(ldrInRead);

    return thingSpeakList;
  }
  else {
    throw Exception('Failed to Read Fields');
  }
}

Container lightOFF = Container(
    height: 150,
    width: 150,
    decoration: BoxDecoration(color: Colors.transparent),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.lightbulb_sharp, size: 80, color: Colors.grey),
        const Text("Light is OFF",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.bold)),
      ],
    )
);
Container lightON = Container(
    height: 150,
    width: 150,
    decoration: BoxDecoration(color: Colors.transparent),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.lightbulb_sharp, size: 80, color: Colors.yellow),
        const Text("Light is ON",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold)),
      ],
    )
);
Container motionNO = Container(
    height: 150,
    width: 150,
    decoration: BoxDecoration(color: Colors.transparent),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off_sharp, size: 80, color: Colors.black),
        const Text("No Motion",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.bold)),
      ],
    )
);
Container motionYES = Container(
    height: 150,
    width: 150,
    decoration: BoxDecoration(color: Colors.transparent),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_sharp, size: 80, color: Colors.black),
        const Text("Motion Detected",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.bold)),
      ],
    )
);

String _currentThresh = LDRIN.toString();
String _brightness = LDRValue.toString();

class PrimaryScreen extends StatefulWidget{
  @override
  _PrimaryScreenState createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {

  double ldrInput = 800;

  bool isSwitched = false;
  bool noSpam = false;
  int manualMode = 0;

  Container lightState = lightOFF;
  Container motionState = motionNO;


  @override
  void initState() {
    Timer refresh = Timer.periodic(const Duration(seconds: 5), (timer) async {
      Future<List> thingSpeakListFuture = readFields();
      List thingSpeakList = await thingSpeakListFuture;
      LDRValue = thingSpeakList[0];
      PIRValue = thingSpeakList[1];
      actValue = thingSpeakList[2];
      manValue = thingSpeakList[3];
      LDRIN = thingSpeakList[4];
      print("Timer goes count");
      setState(() {

        if(actValue == 0) {
          lightState = lightOFF;
        } else {
          lightState = lightON;
        }
        if(PIRValue == 0) {
          motionState = motionNO;
        } else {
          motionState = motionYES;
        }
        _currentThresh = LDRIN.toString();
        _brightness = LDRValue.toString();
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
            children: [
              Icon(item.icon, color: Colors.black, size: 20),
              const SizedBox(width: 10),
              Text(item.text)]));

    void onSelected(BuildContext context, MenuItem item) {
      switch(item) {
        case MenuItems.itemProfile:
          showDialog(
              context: context,
              builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ const SizedBox(height: 80), // MOVES PROFILE BOX DOWN
                  Container( width: 360, height: 500,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [ BoxShadow(color: Colors.grey, offset: Offset(3, 5))]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [ Stack(
                            children: [ const SizedBox(height:10),
                              Container(width:360, height: 80,
                                decoration: BoxDecoration(
                                    color: Colors.lightGreen.shade700,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Column(
                                  children: const [ SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              Row(
                                children: [ const SizedBox(width:295),
                                  Column(
                                    children: [ const SizedBox(height:2),
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Icon(Icons.close, size: 25, color: Colors.white),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.lightGreen.shade700,
                                          shadowColor: Colors.grey,
                                          elevation: 4,
                                          shape: const CircleBorder(),),),],),],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 125),
                                      Container(
                                          height: 130,
                                          width:130,
                                          decoration:const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          )
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: const [SizedBox(width: 130),
                                      CircleAvatar(
                                          radius: 60,
                                          backgroundImage: NetworkImage(dogPic)),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 15),
                                  Column(
                                    children: [
                                      SizedBox(height: 145),
                                      Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                            height: 125,
                                            width: 345,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("User Name",
                                                    style: TextStyle(
                                                        fontSize: 20
                                                    )),
                                                Divider(
                                                  thickness: 1.0,
                                                  color: Colors.black,
                                                  endIndent: 90,
                                                  indent: 90,
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.email_sharp, color: Colors.grey, size: 25),
                                                    SizedBox(width: 10),
                                                    Text("example_email@gmail.com",
                                                        style: TextStyle(
                                                            fontSize: 16
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.bolt, color: Colors.grey, size: 25),
                                                    Text('\$ 0.3 kWh',
                                                        style: TextStyle(
                                                            fontSize: 16
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ]
                        ),
                          Row(
                            children: [SizedBox(width:8),
                              Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  height: 200,
                                  width: 345,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(color: Colors.black)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height:10),
                                      Row(
                                        children: [
                                          SizedBox(width: 15),
                                          Column(
                                            children: [
                                              Text("Energy Calculations",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              )),
                                              SizedBox(height:10),
                                              Text("Average yearly cost at 0.3kWh:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  )),
                                              SizedBox(height:10),
                                              Text("5 120V lights = 0.6kW. At 12hrs daily: \$788.94 ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 14,
                                                  )),
                                              SizedBox(height:15),
                                              Text("Yearly cost with automation:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  )),
                                              SizedBox(height:10),
                                              Text("5 120V lights = 0.6kW. At 4hrs daily: \$262.98 ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 14,
                                                  )),
                                              SizedBox(height:15),
                                              Text("Total Potential Yearly Savings:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  )),
                                              SizedBox(height:10),
                                              Text("\$788.94 - \$262.98 = \$525.96",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 14,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),

                                    ],
                                  )
                                )


                              ),
                            ],
                          )
                        ],
                      )
                  )
                ],
              )
          );
          break;
      }
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
              children: [
                SizedBox(height: 94),
                Image.asset('assets/wall_green.png',
                    height: MediaQuery.of(context).size.height-94,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.colorDodge
                )
              ]
          ),
          Row(
            children: [ SizedBox(width:10),
              Column(
                children: [ const SizedBox(height: 126),
                  Container(
                      height: 150,
                      width: 375,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          border: Border.all(color: Colors.black)
                      )
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 64.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset('assets/logo.png'),
                        const SizedBox(width: 8),
                      ],),),],),),),
          Row(
            children: <Widget>[
              const SizedBox(width: 335),
              Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      PopupMenuButton<MenuItem>(
                          icon: const Icon(Icons.menu, color: Colors.black, size: 35),
                          onSelected: (item) => onSelected(context, item),
                          itemBuilder: (context) => [
                            ...MenuItems.profAndSettings.map(buildItem).toList(),
                          ]
                      ),
                    ],
                  ),
                ], // Column Children
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height:85),
              const Divider(
                color: Colors.black,
                indent:10,
                endIndent: 10,
                thickness: 1,
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                      height: 25, width: 150,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen.shade700,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)
                        ),),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 2.0),
                        child: Text("Readings",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            )),
                      )
                  ),
                ],
              ),
              SizedBox(height:0),
              Container(
                height: 150,
                child: Row(
                  children: [ SizedBox(width: 40),lightState,VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: 20,
                    indent: 20,
                  ), motionState],
                ),
              ),
              SizedBox(height:10),
              Row(
                children: [SizedBox(width:10),
                  Container(
                      height: 25, width: 150,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen.shade700,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)
                        ),),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 3.0),
                        child: Text("Brightness Settings",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black
                            )),
                      )
                  ),
                ],
              ),
              Padding( /* THRESHOLD SLIDER */
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.grey.shade100, Colors.grey.shade100]),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      border: Border.all(color: Colors.black),
                    ),
                    height: 160,
                    width: 400,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height:10),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.wb_sunny, size: 30, color: Colors.yellow.shade600),
                                    SizedBox(width: 10),
                                    Text('Adjust the threshold with the slider,',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.0,
                                          color: Colors.grey.shade800,
                                        )),
                                  ],
                                ),
                              ],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 70),
                                Slider(
                                  label: 'Adjust Threshold : ${ldrInput.round().toString()}',
                                  value: ldrInput,
                                  min: 630,
                                  max: 900,
                                  divisions: 18,
                                  inactiveColor: Colors.grey,
                                  activeColor: Colors.yellow.shade600,
                                  onChanged: (value) => setState(() => ldrInput = value),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Text('New Threshold: ${ldrInput.round().toString()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(' Current Threshold: ' + _currentThresh,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        )),
                                    Text(' Brightness: ' + _brightness,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                                SizedBox(width:40),
                                Container(
                                    height: 40,
                                    width: 120,
                                    child: RawMaterialButton(
                                      onPressed: ()  {
                                        writeFields(LDRValue, PIRValue, actValue, manValue, ldrInput.toInt());
                                        setState(() {
                                          LDRUpdate = ldrInput.round().toString();
                                        });
                                      },
                                      fillColor: Colors.yellow.shade400,
                                      elevation: 2,
                                      padding: const EdgeInsets.symmetric(),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                      child: const Text("Set Threshold",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black,
                                          )),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
              ),
              SizedBox(height:10),
              Row(
                children: [SizedBox(width:10),
                  Container(
                      height: 25, width: 150,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen.shade700,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)
                        ),),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 3.0),
                        child: Text("Manual Controls",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            )),
                      )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:10, right:10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.grey.shade100, Colors.grey.shade100]),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    border: Border.all(color: Colors.black),
                  ),
                  height: 227,
                  width: 400,
                  child: Row(
                    children: [SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height:5),
                          Container(
                              height: 110,
                              width: 360,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                  )
                              ),
                              child: Row(
                                children: [SizedBox(width:10),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(width:10),
                                          const Text("Manual Mode Toggle ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black,
                                              )),
                                          const SizedBox(width: 50),
                                          Switch(
                                            value: isSwitched,
                                            onChanged: (value) {
                                              if (noSpam == false) {
                                                setState(() {
                                                  isSwitched = value;
                                                  if (isSwitched) {
                                                    manualMode = 1;
                                                  } else {
                                                    manualMode = 0;
                                                  }
                                                  writeFields(
                                                      LDRValue, PIRValue,
                                                      actValue, manualMode,
                                                      ldrInput.toInt());
                                                  noSpam = true;
                                                });
                                              } else {
                                                null;
                                              }
                                              Timer(Duration(seconds: 20),(){
                                                setState(() {
                                                  noSpam = false;
                                                });
                                              });
                                            },
                                            activeTrackColor: Colors.lightGreen,
                                            activeColor: Colors.green,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height:8),
                                      Row(
                                        children: [
                                          const SizedBox(width: 40),
                                          Container(
                                            height: 40,
                                            width: 120,
                                            child: RawMaterialButton(
                                                elevation: 3,
                                                padding: const EdgeInsets.all(1),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                onPressed: isSwitched?() {
                                                  actValue = 1;
                                                  writeFields(LDRValue, PIRValue, actValue, manualMode, ldrInput.toInt());
                                                }: null,
                                                fillColor: Colors.green,
                                                child: const Text("Turn Light ON",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.black
                                                    )
                                                )
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Container(
                                            height: 40,
                                            width: 120,
                                            child: RawMaterialButton(
                                              elevation: 3,
                                              padding: const EdgeInsets.all(1),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                              onPressed: isSwitched?() {
                                                actValue = 0;
                                                writeFields(LDRValue, PIRValue, actValue, manualMode, ldrInput.toInt());
                                              }:null,
                                              fillColor: Colors.redAccent,
                                              child: const Text("Turn Light OFF",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.black,),),),),],
                                      ),
                                    ],
                                  )
                                ],
                              )
                          ),
                          SizedBox(height: 5),
                          Container(
                              height: 100,
                              width: 360,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(width: 100),
                                      Column(
                                        children: [
                                          Text("Refresh Current Readings",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black,
                                              )),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              SizedBox(width: 85),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                      height:40,
                                      width:120,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.yellow.shade400,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              )
                                          ),
                                          onPressed: () async {
                                            Future<List> thingSpeakListFuture = readFields();
                                            List thingSpeakList = await thingSpeakListFuture;
                                            LDRValue = thingSpeakList[0];
                                            PIRValue = thingSpeakList[1];
                                            actValue = thingSpeakList[2];
                                            manValue = thingSpeakList[3];
                                            LDRIN = thingSpeakList[4];
                                            setState(() {
                                              if(actValue == 0) {
                                                lightState = lightOFF;
                                              } else {
                                                lightState = lightON;
                                              }
                                              if(PIRValue == 0) {
                                                motionState = motionNO;
                                              } else {
                                                motionState = motionYES;
                                              }
                                            });
                                          },
                                          child: Text("Refresh",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black,
                                              ))
                                      )
                                  ),

                                ],
                              )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        ],),);
  }
}