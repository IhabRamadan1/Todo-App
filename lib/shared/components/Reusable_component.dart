import 'package:flutter/material.dart';
import 'package:testflutter/shared/cubit/cubit.dart';

Widget BuildTasktem(Map Model, context)=>Dismissible(

  key: Key(Model['id'].toString()),
  child:Padding(
    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40,

          child: Text("${Model['time']}"),

        ),

        SizedBox(width: 20,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text("${Model['title']}",

                style: TextStyle(

                  fontSize: 18,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text("${Model['date']}",

                style: TextStyle(

                    color: Colors.grey

                ),

              )

            ],

          ),

        ),

        SizedBox(width: 20,),

        IconButton(onPressed: (){

          AppCubit.get(context).updateDatabase(status: 'done', id: Model['id']);

        },

            icon:Icon(Icons.check_box, color: Colors.green,) ),

        IconButton(onPressed: (){

          AppCubit.get(context).updateDatabase(status: 'archive', id: Model['id']);

        },

            icon:Icon(Icons.archive, color: Colors.black45,) ),

      ],

    ),

  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteDatabase(id: Model['id']);
  },
);
Widget BuildSeparated()=>Padding(
  padding: const EdgeInsets.all(20.0),
  child:   Container(

    color: Colors.grey,

    height: 1,

    width: double.infinity,

  ),
);
Widget BuildNoTasks()=>Center(
  child:   Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.menu, size: 100,color: Colors.grey,),
      Text("No Tasks Yet, Please Add Some Tasks", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),),
    ],
  ),
);