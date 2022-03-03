import 'package:flutter/material.dart';
import 'package:futurejson/info.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp(
    info: fetchInfo(),
  ));
}

class MyApp extends StatelessWidget {
  final Future<Info> info;
  const MyApp({this.info});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          // const는 한 번 붙이면 변환되지 않기 때문에. 나중에 rebuild가 되지 않아 앱의 성능이 향상된다.
          title: const Text('계좌정보 확인하기'),
          centerTitle: true,
        ),
        body: Center(
          child: FutureBuilder<Info>(
            future: info,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '고객번호: ' + snapshot.data.id.toString(),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      '고객명: ' + snapshot.data.userName.toString(),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      '계좌 아이디: ' + snapshot.data.account.toString(),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      '잔액: ' + snapshot.data.balance.toString() + '원',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // 데이터를 받기 전 Indicator가 돈다.
              return CircularProgressIndicator();

            },
          ),
        ),
      ),
    );
  }
}

Future<Info> fetchInfo() async {
  final response =
      await http.get(Uri.parse('https://my.api.mockaroo.com/bank.json?key=fea24270'));

  if (response.statusCode == 200) {
    return Info.fromJson(json.decode(response.body));
  } else {
    throw Exception('계좌정보를 불러오는데 실패했습니다');
  }
}
