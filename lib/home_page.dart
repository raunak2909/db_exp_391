import 'package:db_exp_391/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> allNotes = [];
  var titleController = TextEditingController();
  var descController = TextEditingController();
  DateFormat df = DateFormat.yMMMMEEEEd();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
    getAllNotes();
  }

  void getAllNotes() async {
    allNotes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading:
                      Text("${index+1}"),
                  title: Text(allNotes[index][DBHelper.columnNoteTitle]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(allNotes[index][DBHelper.columnNoteDesc]),
                      Text(df.format(DateTime.fromMillisecondsSinceEpoch(int.parse(allNotes[index][DBHelper.columnNoteCreatedAt])))),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 110,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              titleController.text =
                                  allNotes[index][DBHelper.columnNoteTitle];
                              descController.text =
                                  allNotes[index][DBHelper.columnNoteDesc];
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return getBottomSheetUI(
                                        isUpdate: true,
                                        noteId: allNotes[index]
                                            [DBHelper.columnNoteId]);
                                  });
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Container(
                                      padding: EdgeInsets.all(11),
                                      height: 150,
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Are you sure want to delete this Note?",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    bool check = await dbHelper!
                                                        .deleteNote(
                                                            id: allNotes[index][
                                                                DBHelper
                                                                    .columnNoteId]);
                                                    if (check) {
                                                      getAllNotes();
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  icon: Icon(Icons.done, color: Colors.green)),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Text("X", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: Text('No Notes yet!!'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.text = '';
          descController.clear();
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return getBottomSheetUI();
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetUI({bool isUpdate = false, int? noteId}) {
    return Container(
      padding: EdgeInsets.all(11),
      width: double.infinity,
      height: 400,
      child: Column(
        children: [
          Text(
            isUpdate ? 'Update Note' : 'Add Note',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 11,
          ),
          TextField(
              controller: titleController,
              decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
          SizedBox(
            height: 11,
          ),
          TextField(
              controller: descController,
              maxLines: 3,
              minLines: 3,
              decoration: InputDecoration(
                  labelText: 'Desc',
                  hintText: 'Enter desc',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
          SizedBox(
            height: 11,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                  onPressed: () async {
                    bool check = false;
                    if (isUpdate) {
                      check = await dbHelper!.updateNote(
                          title: titleController.text,
                          desc: descController.text,
                          id: noteId!);
                    } else {
                      check = await dbHelper!.addNote(
                          title: titleController.text,
                          desc: descController.text);
                    }

                    if (check) {
                      getAllNotes();
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save')),
              SizedBox(
                width: 11,
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          ),
        ],
      ),
    );
  }
}
