import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

var titleController = TextEditingController();
var timeController = TextEditingController();
var dateController = TextEditingController();
var formKey = GlobalKey<FormState>();

class AddTaskScreen extends StatelessWidget {
  final AppCubit cubit;

  const AddTaskScreen(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(
          20.0,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Task',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              defaultTextFormField(
                controller: titleController,
                prefixIcon: Icons.title,
                hint: 'Task Title',
                isAutoFocus: true,
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Task Title must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              defaultTextFormField(
                controller: timeController,
                prefixIcon: Icons.timer,
                hint: 'Task Time',
                isReadOnly: true,
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Task Time must not be empty';
                  }
                  return null;
                },
                onTouch: () {
                  showTimePicker(context: context, initialTime: TimeOfDay.now())
                      .then((value) {
                    timeController.text = value!.format(context).toString();
                  });
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              defaultTextFormField(
                controller: dateController,
                prefixIcon: Icons.calendar_today,
                hint: 'Task Date',
                isReadOnly: true,
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Task Date must not be empty';
                  }
                  return null;
                },
                onTouch: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.parse('2040-12-31'))
                      .then((value) => dateController.text =
                          DateFormat.yMMMd().format(value!));
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              defaultButton(
                defaultText: 'Done',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      taskTitle: titleController.text,
                      taskDate: dateController.text,
                      taskTime: timeController.text,
                    );
                    titleController.text = '';
                    timeController.text = '';
                    dateController.text = '';
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
