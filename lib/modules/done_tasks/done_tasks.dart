import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: cubit.doneTasks.isNotEmpty
              ? buildTasksList(cubit.doneTasks, context)
              : buildDefaultText('Done Tasks'),
        );
      },
    );
  }
}
