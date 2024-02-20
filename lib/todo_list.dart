


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Services/todo_service.dart';
import 'Utils/snack_bar_helper.dart';
import 'Widgets/todo_card.dart';
import 'add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                 await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child:CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text('No Todo Item',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index){
                  final item = items[index] as Map ;
                  final id = item['_id'] as String;
                  return TodoCard(
                    index: index,
                    item: item,
                    deleteById: deleteById,
                    navigateEdit: navigateToEditPage,
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add Todo'),
      ),
    );
  }

  Future <void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context)=> const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;

    });
    fetchTodo();
  }

  Future <void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context)=>  AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;

    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    //delete the item
    // final url = 'https://api.nstack.in/v1/todos/$id';
    // final uri = Uri.parse(url);
    final isSuccess = await TodoService.deleteById(id);
    if(isSuccess){
      // remove the item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items  = filtered;
      });
    } else{
      // show error
      showErrorMessage(context, message:'Deletion Failed');
    }

  }





  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();

    if(response != null){

      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message:'Something Went Wrong');
    }
    setState(() {
      isLoading = false;
    });

  }


}
