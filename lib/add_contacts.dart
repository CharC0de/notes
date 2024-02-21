import 'package:flutter/material.dart';
import 'nmodel.dart';
import 'helper.dart';
import 'screen.dart';
import 'demo.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key, this.index, this.note, required this.userData});

  final Note? note;
  final int? index;
  final Map userData;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _subjectController.text = widget.note!.subject;
      _dateController.text = widget.note!.date;
      _descriptionController.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.note != null ? "Edit" : "Add"} notes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTextField(_titleController, 'Title'),
                  const SizedBox(height: 30),
                  _buildTextField(_subjectController, 'Subject'),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onDoubleTap: () async {
                        await _selectDate(context);
                      },
                      child: TextFormField(
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Date";
                          }
                          return null;
                        },
                        controller: _dateController,
                        decoration: const InputDecoration(
                          labelText: "Date",
                          hintText: "Double Tap to Add Date",
                          border: OutlineInputBorder(),
                        ),
                      )),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Description";
                      }
                      return null;
                    },
                    maxLines: null,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (widget.note != null) {
                          await DBHElper.updateNote(Note(
                            id: widget.note!.id, // Have to add id here
                            title: _titleController.text,
                            subject: _subjectController.text,
                            date: _dateController.text,
                            description: _descriptionController.text,
                          ));
                        } else {
                          await DBHElper.createNote(Note(
                            title: _titleController.text,
                            subject: _subjectController.text,
                            date: _dateController.text,
                            description: _descriptionController.text,
                          ));
                        }
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ListScreen(userData: widget.userData)),
                          );
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your $hint";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
