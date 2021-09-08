import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/network/local/cache_helper/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'app_states.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppInitialState());

  static AppCubit get(context)=> BlocProvider.of(context);
  static var mstatus;

  int currentIndex = 0 ;

  List<String> titles = [
    'NewTask',
    'DoneTasks',
    'ArchivedTasks',
  ];



  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database database ;
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;

  void ChangeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavIndexState());
  }

  void createDatabase()  {
   openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version)
      {
        print('database created');
         database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value) {
           print('table created');
         });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('database opened');
        emit(AppGetDatabaseState());
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
   });
  }

   insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async{
    await database.transaction((txn) {
      return txn.rawInsert('INSERT INTO tasks (title ,date ,time ,status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error){
        print('error when inserting new row ${error.toString()}');
        return Completer<Never>().future;
      });
    });
  }

  void getDataFromDatabase(database){
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
     database.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element){
         if (element['status'] == 'new')
           newTasks.add(element);
         else if (element['status'] == 'done')
           doneTasks.add(element);
         else
           archivedTasks.add(element);

       });
       emit(AppGetDatabaseState());
     });
  }

  void UpdateData ({
    required String status,
    required int id,
  })async
  {

    database.rawUpdate("UPDATE tasks SET status = ? WHERE id = ?",
      ['$status',id],).then((value) {

      emit(AppChangeStatus());
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void DeleteData ({
    required int id,
  })async
  {

    database.rawDelete('DELETE FROM tasks WHERE id = ?' ,['$id'],)
        .then((value) {

      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


  void ChangeBottomSheetState({
    required bool isShow,
    required IconData icon
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
  bool isDark = false;
  void ChangeAppTheme ({ bool? fromShared}){
    if(fromShared != null){
      isDark= fromShared;
      emit(AppChangeAppThemeStatus());
    }
    else{
      isDark= !isDark;
      CacheHelper.putData(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeAppThemeStatus());
      });

    }

  }


}

