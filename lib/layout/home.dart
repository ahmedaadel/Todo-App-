import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Shared/cubit/cubit.dart';
import 'package:todo_app/Shared/cubit/states.dart';

class Home extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..CreateDB(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is InsertDBState) Navigator.pop(context);
      }, builder: (context, state) {
        AppCubit cub = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cub.titles[cub.currentIndex]),
          ),
          body: cub.pages[cub.currentIndex],
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cub.isupdating) {
                  if (formKey.currentState!.validate()) {
                    cub.insertDB(titlecontroller.text, timecontroller.text,
                        datecontroller.text);

                    cub.changebuttomsheet(false);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) {
                        return Container(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                      controller: titlecontroller,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Task field is empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.title),
                                        label: const Text(
                                          'Task title',
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      )),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      controller: timecontroller,
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timecontroller.text =
                                              value!.format(context);
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Time filed is empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: const Text(
                                          'Task Time',
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        prefixIcon: const Icon(
                                            Icons.watch_later_outlined),
                                      )),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      controller: datecontroller,
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2023-08-22'))
                                            .then((value) {
                                          datecontroller.text =
                                              DateFormat.yMMMd().format(value!);

                                          /// ممكن اظيطها ب  date format library (intl)
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Date filed is empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        label: const Text(
                                          'Task Date',
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        prefixIcon:
                                            const Icon(Icons.calendar_today),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((value) {
                        cub.changebuttomsheet(false);
                      });
                  cub.changebuttomsheet(true);
                }
              },
              child: Icon(cub.isupdating ? Icons.edit : Icons.add)),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cub.currentIndex,
              onTap: (index) {
                cub.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archive',
                )
              ]),
        );
      }),
    );
  }

  // ignore: non_constant_identifier_names

}
