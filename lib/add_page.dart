

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Services/todo_service.dart';
import 'Utils/snack_bar_helper.dart';




class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key,this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(widget.todo != null){
      isEdit = true;
      final title = todo ?['title'];
      final description = todo ?['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEdit? 'Edit Todo':'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  isEdit? 'Update':'Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // Get the data from the form
    final todo = widget.todo;
    if(todo == null){
      print('you can not call updated without todo data');
      return;
    }
    final id = todo['_id'];

    // submit update data to the server

    final isSuccess = await TodoService.updateTodo(id, body);

    //show success or fail message based on status
    if (isSuccess) {
      // titleController.text = '';
      // descriptionController.text = '';
      showSuccessMessage(context, message: 'Updation success');
    } else {
      showErrorMessage(context, message: 'Updation failed');
    }
  }

  Future<void> submitData() async {

    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    // Submit the data to the server

    final isSuccess = await TodoService.addTodo( body);
    //show success or fail message based on status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message:'creation success');
    } else {
      showErrorMessage(context, message:'creation failed');
    }
  }


  Map get body {
    // Get the data from the form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
  }



}