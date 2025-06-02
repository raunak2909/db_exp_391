import 'package:db_exp_391/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> allNotes = [];
  var titleController = TextEditingController();
  var descController = TextEditingController();

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
                      Text(allNotes[index][DBHelper.columnNoteId].toString()),
                  title: Text(allNotes[index][DBHelper.columnNoteTitle]),
                  subtitle: Text(allNotes[index][DBHelper.columnNoteDesc]),
                );
              })
          : Center(
              child: Text('No Notes yet!!'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return Container(
                  padding: EdgeInsets.all(11),
                  width: double.infinity,
                  height: 400,
                  child: Column(
                    children: [
                      Text(
                        'Add Note',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                bool check = await dbHelper!.addNote(
                                    title: titleController.text,
                                    desc: descController.text);

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
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
