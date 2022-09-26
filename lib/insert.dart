import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mongdb/MongoDbModel.dart';
import 'package:mongdb/dbHelper/mongodb.dart';
import "package:mongo_dart/mongo_dart.dart" as M;

class MongoDbInsert extends StatefulWidget {
  const MongoDbInsert({super.key});

  @override
  State<MongoDbInsert> createState() => _MongoDbInsertState();
}

class _MongoDbInsertState extends State<MongoDbInsert> {
  var fnameController = new TextEditingController();
  var lnameController = new TextEditingController();
  var addressController = new TextEditingController();

  // create a variable to display insert or update
  var _checkInsertOrUpdate = "Insert";

  @override
  Widget build(BuildContext context) {
    // getting argument from previous page and store inside variable
    MongoDbModel data =
        ModalRoute.of(context)!.settings.arguments as MongoDbModel;

    // check data is null or not
    if (data != null) {
      // if not then will see text inside our controller
      fnameController.text = data.firstname;
      lnameController.text = data.lastname;
      addressController.text = data.address;
      _checkInsertOrUpdate = "Update";
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              _checkInsertOrUpdate,
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 50,
            ),
            TextField(
              controller: fnameController,
              decoration: InputDecoration(
                labelText: "First name",
              ),
            ),
            TextField(
              controller: lnameController,
              decoration: InputDecoration(
                labelText: "Last name",
              ),
            ),
            TextField(
              minLines: 3,
              maxLines: 5,
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Address",
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _fakerData();
                  },
                  child: Text("Generate AutoData"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_checkInsertOrUpdate == "Update") {
                      // call update fun and pass argument
                      _updataData(data.id, fnameController.text,
                          lnameController.text, addressController.text);
                    } else {
                      _insertData(fnameController.text, lnameController.text,
                          addressController.text);
                    }
                  },
                  child: Text(_checkInsertOrUpdate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //insert data
  Future<void> _insertData(String fName, String lName, String address) async {
    var _id = M.ObjectId();
    final data = MongoDbModel(
        id: _id, firstname: fName, lastname: lName, address: address);
    var result = await MongoDatabase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserted ID" + _id.$oid)));
    _clearAll();
  }

  void _clearAll() {
    fnameController.text = "";
    lnameController.text = "";
    addressController.text = "";
  }

  //update data
  // get argument
  Future<void> _updataData(
      var id, String fName, String lName, String address) async {
    // data as model class
    final updateData = MongoDbModel(
        id: id, firstname: fName, lastname: lName, address: address);
    await MongoDatabase.update(updateData)
        .whenComplete(() => Navigator.pop(context));
  }

  // install faker package to generate fake data
  void _fakerData() {
    setState(() {
      fnameController.text = faker.person.firstName();
      lnameController.text = faker.person.lastName();
      addressController.text =
          faker.address.streetName() + "\n" + faker.address.streetAddress();
    });
  }
}
