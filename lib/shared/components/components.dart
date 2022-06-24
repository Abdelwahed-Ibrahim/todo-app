import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildSwipeActionLeft() => Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(20.0),
      child: const Icon(
        Icons.archive_outlined,
        color: Colors.greenAccent,
        size: 32.0,
      ),
    );

Widget buildSwipeActionRight() => Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(20.0),
      child: const Icon(
        Icons.delete_forever,
        color: Colors.redAccent,
        size: 32.0,
      ),
    );

Widget taskTile(task, context,
        {DismissDirection direction = DismissDirection.horizontal}) =>
    Dismissible(
      key: ObjectKey(task),
      background: buildSwipeActionLeft(),
      secondaryBackground: buildSwipeActionRight(),
      direction: direction,
      onDismissed: (direction) {
        switch (direction) {
          case DismissDirection.vertical:
            // TODO: Handle this case.
            break;
          case DismissDirection.horizontal:
            // TODO: Handle this case.
            break;
          case DismissDirection.endToStart:
            AppCubit.get(context).deleteRecordFromDatabase(id: task['id']);
            break;
          case DismissDirection.startToEnd:
            AppCubit.get(context)
                .updateRecordInDatabase(status: "archived", id: task['id']);
            break;
          case DismissDirection.up:
            // TODO: Handle this case.
            break;
          case DismissDirection.down:
            // TODO: Handle this case.
            break;
          case DismissDirection.none:
            // TODO: Handle this case.
            break;
        }
      },
      child: GestureDetector(
        child: Container(
          child: Column(
            children: [
              Text(
                '${task['title']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${task['date']}',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18.0,
                    ),
                  ),
                  const Text(
                    ' at ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    '${task['time']}',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onTap: () {
          if (kDebugMode) {
            AppCubit.get(context)
                .updateRecordInDatabase(status: "done", id: task['id']);
            print('Tapped');
          }
        },
      ),
    );

Widget buildTasksList(List<Map> tasks, context,
        {DismissDirection direction = DismissDirection.horizontal}) =>
    ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) =>
          taskTile(tasks[index], context, direction: direction),
      separatorBuilder: (context, index) => const SizedBox(
        height: 10.0,
      ),
      itemCount: tasks.length,
    );

Widget buildDefaultText(String str) => Center(
      child: Text(
        str,
        style: const TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

Widget defaultButton({
  Color colour = Colors.lightBlueAccent,
  Color txtColour = Colors.white,
  required String defaultText,
  required Function() onPressed,
}) =>
    MaterialButton(
      color: colour,
      child: Text(
        defaultText,
        style: TextStyle(
          color: txtColour,
        ),
      ),
      onPressed: onPressed,
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required IconData prefixIcon,
  required String hint,
  bool isAutoFocus = false,
  bool isReadOnly = false,
  String? Function(String?)? validation,
  Function()? onTouch,
}) =>
    TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      readOnly: isReadOnly,
      autofocus: isAutoFocus,
      validator: validation,
      decoration: InputDecoration(
        iconColor: Colors.lightBlueAccent,
        icon: Icon(prefixIcon),
        label: Text(
          hint,
        ),
        border: const OutlineInputBorder(),
      ),
      onTap: onTouch,
    );

ThemeData myTheme(bool isDark) => ThemeData(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: isDark ? const Color(0xff333739) : Colors.white,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.pinkAccent,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        color: isDark ? const Color(0xff333739) : Colors.white,
        elevation: 0.0,
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 20.0,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      primarySwatch: Colors.pink,
      scaffoldBackgroundColor: isDark ? const Color(0xff333739) : Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 15.0,
        backgroundColor: isDark ? const Color(0xff333739) : Colors.white,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
