import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks.dart';
import '../../modules/done_tasks/done_tasks.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  int currentIndex = 0;
  late Database database;
  late List<Map> newTasks = [];
  late List<Map> doneTasks = [];
  late List<Map> archivedTasks = [];

  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todoey.db',
      version: 1,
      onCreate: (database, version) {
        if (kDebugMode) {
          print('Database Created');
        }
        database
            .execute(
                'CREATE TABLE Tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          if (kDebugMode) {
            print('Table Tasks Created');
          }
        }).catchError((error) {
          if (kDebugMode) {
            print('Error when Creating Table ${error.toString()}');
          }
        });
      },
      onOpen: (database) {
        if (kDebugMode) {
          print('Database Opened');
        }
        getFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    }).catchError((error) {
      if (kDebugMode) {
        print('Error when Creating Database ${error.toString()}');
      }
    });
  }

  void insertToDatabase({
    required taskTitle,
    required taskDate,
    required taskTime,
  }) {
    database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Tasks(title, date, time, status) VALUES("$taskTitle", "$taskDate", "$taskTime", "new")')
          .then((value) {
        if (kDebugMode) {
          print('$value Inserted successfully');
        }
        emit(AppInsertIntoDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        if (kDebugMode) {
          print(
              'Error when Inserting New Record in Tasks Table ${error.toString()}');
        }
      });
    });
  }

  void getFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      if (kDebugMode) {
        print(value);
      }
      for (var element in value) {
        if (element['status'] == "new") {
          newTasks.add(element);
        } else if (element['status'] == "done") {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      }
      emit(AppGetDataFromDatabaseState());
    });
  }

  void updateRecordInDatabase({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      if (kDebugMode) {
        print("Row $value Updated successfully");
      }
      emit(AppUpdateRecordInDatabaseState());
      getFromDatabase(database);
    });
  }

  void deleteRecordFromDatabase({required int id}) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteRecordFromDatabaseState());
      getFromDatabase(database);
    });
  }
}
