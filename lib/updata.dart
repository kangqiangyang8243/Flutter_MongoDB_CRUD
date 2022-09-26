import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mongdb/MongoDbModel.dart';
import 'package:mongdb/dbHelper/mongodb.dart';
import 'package:mongdb/insert.dart';

class MongoDbUpdate extends StatefulWidget {
  const MongoDbUpdate({super.key});

  @override
  State<MongoDbUpdate> createState() => _MongoDbUpdateState();
}

class _MongoDbUpdateState extends State<MongoDbUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: MongoDatabase.getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  // 1. display data
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return CardData(
                        MongoDbModel.fromJson(snapshot.data[index]),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("No Data Found!"),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget CardData(MongoDbModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${data.id.$oid}"),
                SizedBox(
                  height: 5,
                ),
                Text("${data.firstname}"),
                SizedBox(
                  height: 5,
                ),
                Text("${data.lastname}"),
                SizedBox(
                  height: 5,
                ),
                Text("${data.address}"),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            // create icon button to edit
            IconButton(
              onPressed: () {
                // on Edit navigate to insert page with passing data (Model class) as argument
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContextcontext) {
                      return MongoDbInsert();
                    },
                    settings: RouteSettings(arguments: data),
                  ),
                ).then((value) {
                  // using setstate() to update list of Date
                  setState(() {});
                });
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
