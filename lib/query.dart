import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mongdb/MongoDbModel.dart';
import 'package:mongdb/dbHelper/mongodb.dart';

class MongDbQuery extends StatefulWidget {
  const MongDbQuery({super.key});

  @override
  State<MongDbQuery> createState() => _MongDbQueryState();
}

class _MongDbQueryState extends State<MongDbQuery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: MongoDatabase.getQueryData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return _dataCard(
                        MongoDbModel.fromJson(snapshot.data[index]),
                      );
                    });
              } else {
                return Center(
                  child: Text('No Data Found!'),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _dataCard(MongoDbModel data) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${data.firstname} ${data.lastname}"),
              SizedBox(
                height: 5,
              ),
              Text("${data.address}"),
            ],
          ),
        ),
      ),
    );
  }
}
