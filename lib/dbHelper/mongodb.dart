import 'dart:developer';

import 'package:mongdb/MongoDbModel.dart';
import 'package:mongdb/dbHelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, userCollection;

  // create Static connect func to connect with db
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
  }

  // fetch data from db file
  // reutrn list of data (arrdata) without converting (decode json)
  static Future<List<Map<String, dynamic>>> getData() async {
    // .find() = get all data
    // .toList = convert data into list(array)
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  // insert
  static Future<String> insert(MongoDbModel data) async {
    try {
      // insert query collectionName.insertOne (your data is jsonformat)
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "some Error in appending";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  // update
  static Future<void> update(MongoDbModel data) async {
    // findOne (passing id) = it will fetch that first then it stores inside the result
    var result = await userCollection.findOne({"_id": data.id});
    // over write
    result["firstname"] = data.firstname;
    result["lastname"] = data.lastname;
    result['address'] = data.address;
    // save(result) will update data
    var response = await userCollection.save(result);
    inspect(response);
  }

  //delete
  // remove() = delete
  // where() = condition
  static Future<void> delete(MongoDbModel data) async {
    await userCollection.remove(where.id(data.id));
  }

  // create fun for query usage
  // where.eq(fieldName, value) first will field name (column) second will be value
  // this will return same age as value
  static Future<List<Map<String, dynamic>>> getQueryData() async {
    final data = await userCollection.find(where.eq("age", "43")).toList();
    return data;
  }
}
