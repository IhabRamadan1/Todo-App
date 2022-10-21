import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testflutter/modules/archived_task.dart';
import 'package:testflutter/modules/done_task.dart';
import 'package:testflutter/modules/new_tasks.dart';
import 'package:testflutter/shared/cubit/cubit.dart';
import 'package:testflutter/shared/cubit/states.dart';
import '../shared/components/constants.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey =GlobalKey<ScaffoldState>();
  var formKey =GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is insertState)
            {
              Navigator.pop(context);
            }
        },
        builder: (context,state){
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(AppCubit.get(context).title[AppCubit.get(context).currentIndex]),
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20
              ),
              elevation: 0.0,
            ),
            body: AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(AppCubit.get(context).isBottomSheetShown == true)
                {
                  if(formKey.currentState!.validate())
                  {
                    AppCubit.get(context).InsertToDatabase(
                        title: AppCubit.get(context).titleController.text,
                        date: AppCubit.get(context).dateController.text,
                        time: AppCubit.get(context).timeController.text
                    );

                  }
                }
                else
                {
                  scaffoldKey.currentState!.showBottomSheet((context)=>Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: AppCubit.get(context).titleController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Task Title",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.title),
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "can't be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15,),
                            TextFormField(
                              controller: AppCubit.get(context).timeController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Task Time",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.access_time),
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "can't be empty";
                                }
                                return null;
                              },

                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  AppCubit.get(context).timeController.text = value!.format(context).toString();
                                });
                              },

                            ),
                            SizedBox(height: 15,),
                            TextFormField(
                              controller: AppCubit.get(context).dateController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Task Date",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.date_range),
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "can't be empty";
                                }
                                return null;
                              },
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2023),
                                ).then((value){
                                  AppCubit.get(context).dateController.text = DateFormat.yMMMd().format(value!);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),elevation: 15 )
                      .closed.then((value){
                    AppCubit.get(context).changeBottomSheet(
                        isShow: false,
                        icon: Icons.edit,
                    );
                  });
                  AppCubit.get(context).changeBottomSheet(
                      isShow: true,
                      icon: Icons.add,
                  );
                }
              },
              child: Icon(AppCubit.get(context).FloatingIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                )
              ],
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              selectedItemColor: Colors.blueAccent,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index)
              {
                AppCubit.get(context).changeNavigationBar(index);
              },
            ),
          );
        },
      ),
    );
  }

}
