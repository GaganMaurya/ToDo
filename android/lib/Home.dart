// ignore_for_file: file_names, unused_field, duplicate_ignore, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'dbHelper.dart';

// ignore: use_key_in_widget_constructors
// ignore: unused_element
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ignore: duplicate_ignore
class _HomeScreenState extends State<HomeScreen> {
  // ignore: unused_field, prefer_final_fields
  List<Map<String, dynamic>> _allData = [];
  // ignore: prefer_final_fields
  bool _isLoading = true;

  // ignore: unused_element
  void _refreshing() async {
    final data = await SqlHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshing();
  }

  // ignore: unused_element
  Future<void> _addData() async {
    await SqlHelper.createData(_titleController.text, _descController.text);
    _refreshing();
  }

  // ignore: unused_element
  Future<void> _updateData(int id) async {
    await SqlHelper.updateData(id, _titleController.text, _descController.text);
    _refreshing();
  }

  // ignore: unused_element
  void _deleteData(int id) async {
    await SqlHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.red,
      content: Text("Data Deleted ")
    ));
    _refreshing();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingdata =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingdata['title'];
      _descController.text = existingdata['desc'];
    }
    showModalBottomSheet(
        elevation: 5,
        context: context,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "title",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Description"),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addData();
                        }
                        if (id != null) {
                          await _updateData(id);
                        }

                        _titleController.text = "";
                        _descController.text = "";

                        Navigator.of(context).pop();
                        // ignore: avoid_print
                        print("Data Added");
                      },
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          id == null ? "Add Data" : "Update",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: prefer_const_constructors
       backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text("Todo List App"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
            itemCount: _allData.length,
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      _allData[index]['title'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  subtitle: Text(_allData[index]['desc']+ "\n"+ "\n"+ _allData[index]['createdAt']),
                  
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(_allData[index]['id']);
                        },
                        icon: Icon(Icons.edit, color: Colors.indigo),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteData(_allData[index]['id']);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
