import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components/Reusable_component.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class DoneTask extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks = AppCubit.get(context).DoneTasks;

        return ConditionalBuilder(
          condition: tasks.length>0,
          builder: (context)=> ListView.separated(
            physics: BouncingScrollPhysics(),
        itemBuilder: (context,index)=>BuildTasktem(AppCubit.get(context).DoneTasks[index], context),
        separatorBuilder: (context,index)=>BuildSeparated(),
        itemCount: AppCubit.get(context).DoneTasks.length,
        ),
        fallback: (context)=>BuildNoTasks(),
        );

      },
    );
  }
}