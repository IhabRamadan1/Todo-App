
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testflutter/shared/cubit/states.dart';

import '../../modules/archived_task.dart';
import '../../modules/done_task.dart';
import '../../modules/new_tasks.dart';
import '../components/constants.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit():super(initialState());
  static AppCubit get(context)=>BlocProvider.of(context);

  List<Map> NewTasks=[];
  List<Map> DoneTasks=[];
  List<Map> ArchiveTasks=[];

  int currentIndex =0;
  List <Widget> screens = [
    NewTask(),
    DoneTask(),
    ArchiveTask(),
  ];
  List<String> title =[
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  void changeNavigationBar(int index)
  {
    currentIndex = index;
    emit(BottomChangeState());
  }

  late Database database;

  void createDatabase(){
    openDatabase(
        "Todo.db",
        version: 1,
        onCreate: (database, version) async
        {
          print("Database Created!");
          await database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
          ).then((value){
            print("Table Created!");
          });
        },

        onOpen: (database){
          getDatabase(database);
          print("Database Opened!");
        }
    ).then((value){
      database = value;
      emit(createState());
    });
  }

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

   InsertToDatabase({
    required String title,
    required String date,
    required String time,

  }) async {
     await database.transaction((txn)
    async {
      await txn.rawInsert(
          'INSERT INTO tasks (title, date, time, status) VALUES("$title","$date","$time","new")'
      ).then((value){
        emit(insertState());
        getDatabase(database);
        titleController.clear();
        dateController.clear();
        timeController.clear();
        print(" $value Inserted Successfuly");
      }).catchError((error){
        print("error when inserting ${error.toString()}");
      });
      return null;
    });
  }

  void getDatabase(database) {
    NewTasks=[];
    DoneTasks=[];
    ArchiveTasks=[];
     database.rawQuery('SELECT * FROM tasks').then((value){
       value.forEach((element){
         if(element['status']=='new'){
           NewTasks.add(element);}
           else if(element['status']=='done'){
             DoneTasks.add(element);}
             else ArchiveTasks.add(element);
         });
       });

       emit(getState());
     }

  void updateDatabase({
  required String status,
    required int id,
}){
    database.rawUpdate(
      'UPDATE tasks SET status=? WHERE id =?',
      ["${status}",id],
    ).then((value){
      getDatabase(database);
      emit(updateState());
    });
  }

  void deleteDatabase({required int id})
  {
    database.rawDelete(''
        'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value){
      getDatabase(database);
      emit(deleteState());
    });
  }


  bool isBottomSheetShown = false;
  IconData FloatingIcon = Icons.add;

  void changeBottomSheet({
  required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    FloatingIcon = icon;
    emit(SheetChangeState());
  }
}
