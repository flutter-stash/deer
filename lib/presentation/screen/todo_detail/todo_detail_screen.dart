import 'package:flutter/material.dart';
import 'package:tasking/domain/entity/todo_entity.dart';
import 'package:tasking/presentation/screen/todo_detail/todo_edit_screen.dart';
import 'package:tasking/presentation/shared/helper/date_formatter.dart';
import 'package:tasking/presentation/shared/widgets/buttons.dart';
import 'package:tasking/presentation/shared/widgets/todo_avatar.dart';

import 'todo_detail_actions.dart';
import 'todo_detail_bloc.dart';
import 'todo_detail_state.dart';

class TodoDetailScreen extends StatefulWidget {
  final TodoEntity todo;

  const TodoDetailScreen({
    Key key,
    @required this.todo,
  })  : assert(todo != null),
        super(key: key);

  @override
  _TodoDetailScreenState createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  // Place variables here
  TodoDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = TodoDetailBloc(todo: widget.todo);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  // Place methods here
  void _edit(TodoEntity todo) async {
    final updatedTodo = await Navigator.of(context).push<TodoEntity>(MaterialPageRoute(
      builder: (context) => TodoEditScreen(todo: todo),
    ));

    _bloc.actions.add(PushTodo(todo: updatedTodo));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.initialState,
      stream: _bloc.state,
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      },
    );
  }

  Widget _buildUI(TodoDetailState state) {
    // Build your root view here
    return Scaffold(
      appBar: AppBar(
        title: Text('Task details'),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(TodoDetailState state) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(height: 16.0),
              TodoAvatar(text: state.todo.name, isLarge: true),
              const SizedBox(height: 16.0),
              Text(
                'Title:',
                style: TextStyle().copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                state.todo.name,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Description:',
                style: TextStyle().copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                state.todo.description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text('Added on: ${DateFormatter.formatSimple(state.todo.addedDate)}'),
              const SizedBox(height: 8.0),
              Text('Due by: ${DateFormatter.formatSimple(state.todo.dueDate)}'),
              const SizedBox(height: 16.0),
              Expanded(child: Container()),
              RoundButton(
                text: 'Edit',
                onPressed: () => _edit(state.todo),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
