import 'package:flutter/material.dart';
import 'package:todo_app/Shared/cubit/cubit.dart';

Widget buildTaskiIem(Map data, context) => Dismissible(
      key: Key(data['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDB(id: data['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${data['time']}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${data['title']}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${data['date']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateDB(state: 'done', id: data['id']);
              },
              icon: const Icon(Icons.check_box),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDB(state: 'archive', id: data['id']);
              },
              icon: const Icon(Icons.archive),
              color: Colors.black26,
            )
          ],
        ),
      ),
    );
