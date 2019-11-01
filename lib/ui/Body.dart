import 'package:flutter/material.dart';
import 'package:keep_notes/helper_class/databseHelper.dart';
import 'package:keep_notes/helper_class/date_format.dart';
import 'package:keep_notes/mode_class/Note.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}
final List<Note> _list = <Note>[];
class _BodyState extends State<Body> {

  var db = DatabaseHelper();
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    _savedNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, int index) {
                return Card(
                    color: Colors.white,
                    elevation: 12.0,
                    child: GestureDetector(
                      child: ListTile(
                        onTap: () {},
                        title: Text(
                          _list[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Created On: ${_list[index].date}', style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline,),
                          onPressed: () {_delete(_list[index].id, index);},
                        ),
                      ),
                      onLongPress: () => updateNote(_list[index], index),
                    )
                  );
              }),
        ),


      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Notes',
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.green[800],
        onPressed: enterNotes,
        ),
    );
  }

  void enterNotes() {
    var dialog = AlertDialog(
      content: TextField(
        autofocus: true,
        controller: _controller,
        decoration: InputDecoration(
          icon: Icon(Icons.note_add),
          labelText: 'Enter Here',
          hintText: 'eg. Do Homework'
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed:() {Navigator.pop(context);},
          child: Text(
            'Cancel',
          ),),

        FlatButton(
          onPressed: (){
            Submit(_controller.text);
            Navigator.pop(context);
          },
          child: Text(
            'Save',
          ),),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      }
    );
  }

  void Submit(String text) async {

    Note note = Note(text, formatDate());
    var noteID = await db.saveNote(note);
    Note item = await db.getaNote(noteID);
    print(item);
    setState(() {
      _list.insert(0, item);
    });
    _controller.clear();

  }

  _savedNotes() async {
    List note = await db.getAllNote();
    note.forEach((items) {
      setState(() {
        _list.add(Note.fromMap(items));
      });
    });
  }

  void _delete(int id, int index) async {
    await db.deleteNote(id);
    setState(() {
      _list.removeAt(index);
    });
  }

  updateNote(Note note, int index) {
    var alert = AlertDialog(
      title: Text('Update Note'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          icon: Icon(Icons.update),
          labelText: 'Enter your Updated Note Here..'
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),

        FlatButton(
          child: Text('Update'),
          onPressed: () async {
            Note updatedNote = Note.fromMap({
             'name' : _controller.text,
             'date' : formatDate(),
              'id' : note.id
            });
            setState(() {
              _list.removeWhere((element) {
                // ignore: unnecessary_statements
                _list[index].name == note.name;
              });
            });
            db.updateNote(updatedNote);
            setState(() {
              _savedNotes();
            });
            _controller.clear();
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (context) {
      return alert;
    });
  }
}
