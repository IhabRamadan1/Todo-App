import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testflutter/shared/components/Reusable_component.dart';
import 'package:testflutter/shared/components/constants.dart';
import 'package:testflutter/shared/cubit/states.dart';

import '../shared/cubit/cubit.dart';

class NewTask extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks = AppCubit.get(context).NewTasks;
        return ConditionalBuilder(
          condition: tasks.length>0,
          builder: (context)=>ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index)=>BuildTasktem(AppCubit.get(context).NewTasks[index], context),
            separatorBuilder: (context,index)=>BuildSeparated(),
            itemCount: AppCubit.get(context).NewTasks.length,
          ),
          fallback: (context)=>BuildNoTasks(),
        );
      },
    );
  }
}
