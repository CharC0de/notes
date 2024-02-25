import 'package:flutter/material.dart';
import 'package:notes/user_profile.dart';
import 'add_contacts.dart';
import 'nmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'demo.dart';
import 'helper.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key, required this.userData});
  final Map userData;
  @override
  State<StatefulWidget> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends State<ListScreen> {
  bool hasData = false;
  List<Note> note = [];
  List<int> selected = [];
  int index = 0;
  bool edit = false;

  select(id) {
    if (!selected.contains(id)) {
      setState(() {
        selected.add(id);
      });
    } else {
      setState(() {
        selected.remove(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Academic Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(
                          userData: widget.userData,
                        )),
              );
            },
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  edit = !edit;
                });
              },
              icon: Icon(edit ? Icons.close : Icons.edit)),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: DBHElper.readNote(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Note Yet'),
            );
          }
          if (snapshot.data!.isNotEmpty) {
            hasData = true;
          }
          return ListView(
            children: snapshot.data!.map((note) {
              return ListTile(
                title: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                note.subject,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 18),
                              ),
                              Text(note.date),
                              if (selected.contains(note.id))
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(note.description)),
                            ]))),
                trailing: edit
                    ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Note'),
                                content: const Text('Are you sure you want'
                                    ' to delete this note?'),
                                actionsAlignment:
                                    MainAxisAlignment.spaceBetween,
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      Database db = await DBHElper.initDB();
                                      db.rawDelete(
                                        'DELETE FROM note where id ="${note.id}"',
                                      );
                                      if (context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                super.widget,
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Delete'),
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : null,
                onTap: edit
                    ? () async {
                        final bool? refresh =
                            await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => NoteScreen(
                            userData: widget.userData,
                            index: snapshot.data!.first.title == note.title
                                ? 0
                                : null,
                            note: Note(
                              id: note.id,
                              title: note.title,
                              subject: note.subject,
                              date: note.date,
                              description: note.description,
                            ),
                          ),
                        ));
                        if (refresh != null) {
                          setState(() {
                            //if return true, rebuild whole widget
                          });
                        }
                      }
                    : () {
                        select(note.id);
                      },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final refresh = await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => NoteScreen(
                    userData: widget.userData,
                  )));
          if (refresh != null) {
            setState(() {
              //if return true, rebuild whole widget
            });
          }
        },
      ),
    );
  }
}
