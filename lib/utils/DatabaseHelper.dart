import 'dart:async';
import 'dart:io';
import 'package:exercise/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
    
    static Database _database;
    static init()async {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path,"exercise.db");
        _database = await openDatabase(path,version: 1,onCreate: (Database db,int version) async{
           await db.execute(
               "CREATE TABLE exercise_cookie (id INTEGER PRIMARY KEY,cookie VARCHAR (255) NOT NULL)"
           );
        });
    }
    static saveCookie(String cookie) async{
        Map<String, dynamic> cookieMap = {"id":"1","cookie":cookie};
        List<Map> cookies = await _database.rawQuery("select cookie from exercise_cookie where id = 1");
        if(cookies.isEmpty){
            await _database.insert("exercise_cookie", cookieMap);
            print("saved.insert");
        }else{
            await _database.update("exercise_cookie", cookieMap,where: "id=1");
            print("saved.update");
        }
        print("saved.null");
    }

    static Future<String> getCookie() async {
        List<Map> cookies = await _database.rawQuery("select cookie from exercise_cookie where id = 1");
        return cookies[0]['cookie'];
    }

    static Future<bool> checkCookie() async{
        List<Map> cookies = await _database.rawQuery("select cookie from exercise_cookie where id = 1");
        if(cookies.isEmpty){
            return true;
        }else{
            var temp = cookies[0]['cookie'];
            if(temp == originCookie){
                return true;
            }else{
                cookie = temp;
                return false;
            }
        }
    }

}