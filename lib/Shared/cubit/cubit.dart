import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Shared/cubit/states.dart';
import 'package:todo_app/modules/arch.dart';
import 'package:todo_app/modules/done.dart';
import 'package:todo_app/modules/new.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> pages = const [NewTasks(), DoneTasks(), ArchTasks()];
  List<String> titles = ["New Tasks", "Done Tasks", "Archive Tasks"];
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> arctasks = [];
  bool isupdating = false;

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeButtomNavBarState());
  }

  ////////////////////////
  late Database database;
  void CreateDB() {
    openDatabase('todoo.db', version: 1, onCreate: (database, version) async {
      print('database created');
      database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) => print('table created'))
          .catchError((onError) {
        print("error");
      });
    }, onOpen: (Database) {
      getfromDB(Database);
      print('opened');
    }).then((value) {
      database = value;
      emit(CreateDBState());
    });
  }

  Future insertDB(String title, String time, String date) async {
    return database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","New")');
    }).then((value) {
      emit(InsertDBState());
      getfromDB(database);
      print('raw $value inserted');
    }).catchError((error) {
      print('raw not inserted ');
    });
  }

  void getfromDB(Database database) {
    donetasks = [];
    newtasks = [];
    arctasks = [];
    emit(GetDBState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        if (element['status'] == 'New') newtasks.add(element);
        if (element['status'] == 'done') donetasks.add(element);
        if (element['status'] == 'archive') arctasks.add(element);
      }
      emit(GetDBState());
    });
  }

  void updateDB({required String state, required int id}) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [state, id]).then((value) {
      getfromDB(database);
      emit(UpdateDBState());
    });
  }

  void deleteDB({required int id}) {
    database.rawUpdate('DELETE FROM tasks WHERE  id = ?', [id]).then((value) {
      getfromDB(database);
      emit(DeleteDBState());
    });
  }

  void changebuttomsheet(bool val) {
    isupdating = val;
    emit(ChangeButtonSheetIconState());
  }
}
