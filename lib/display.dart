import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mongdb/MongoDbModel.dart';
import 'package:mongdb/dbHelper/mongodb.dart';

class MongoDbDisplay extends StatefulWidget {
  const MongoDbDisplay({super.key});

  @override
  State<MongoDbDisplay> createState() => _MongoDbDisplayState();
}

class _MongoDbDisplayState extends State<MongoDbDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Fetch data
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            // call get data in mongodb.dart
            future: MongoDatabase.getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  // get totel length of data
                  var totalData = snapshot.data.length;
                  print("Total Data" + " " + totalData.toString());
                  return ListView.builder(
                    // the length of listview
                    itemCount: totalData,
                    // Print out each data
                    itemBuilder: (context, index) {
                      // call fun and pass data here converting (form json) data into our model class
                      return displayCard(
                        MongoDbModel.fromJson(snapshot.data[index]),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("No Data Available"),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  // create fun with parameter(ModelClass) for card which reutnr widget
  Widget displayCard(MongoDbModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
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
          ],
        ),
      ),
    );
  }
}
