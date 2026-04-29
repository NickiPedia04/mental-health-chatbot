import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_app_support/services/note_services.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class NotePage extends StatefulWidget {
  final String? docId;
  final String? header;
  final String? content;
  final Timestamp? updatedAt;

  const NotePage({
    super.key,
    this.docId,
    this.header,
    this.content,
    this.updatedAt,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController headerController;
  late TextEditingController contentController;
  Timer? _debounce;
  String? currDocId;
  String? updateDateFormat;

  Future<void> autoSave() async {
    final noteServ = noteService();

    // no saves for empty notes
    if (headerController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty) {
      return;
    }

    if (currDocId == null) {
      // create
      currDocId = await noteServ.addNote(
        headerController.text,
        contentController.text,
      );
    } else {
      // update
      await noteServ.updateNote(
        currDocId!,
        headerController.text,
        contentController.text,
      );
    }
  }

  void _onChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(seconds: 1), () {
      autoSave();
    });
  }

  @override
  void initState() {
    super.initState();

    currDocId = widget.docId;

    headerController = TextEditingController(text: widget.header ?? '');
    contentController = TextEditingController(text: widget.content ?? '');

    headerController.addListener(_onChanged);
    contentController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    headerController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void saveNote() async {
    final noteServ = noteService();

    if (widget.docId == null) {
      // create new note
      await noteServ.addNote(headerController.text, contentController.text);
    } else {
      // update current note
      await noteServ.updateNote(
        widget.docId!,
        headerController.text,
        contentController.text,
      );
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void deleteNote() async {
    final noteServ = noteService();

    if (widget.docId != null) {
      await noteServ.deleteNote(widget.docId!);
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back
                    IconButton(
                      onPressed: () {
                        saveNote();
                      },
                      icon: Icon(Icons.arrow_back_rounded, size: 30),
                    ),
                    SizedBox(width: 40),

                    // Delete
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              DeleteDialog(onConfirm: deleteNote),
                        );
                      },
                      icon: Icon(Icons.delete_outline_outlined, size: 30),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: headerController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  Divider(thickness: 1),

                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        hintText: 'Content',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),
            Text(
              widget.updatedAt != null ? "Last Updated:" : "",
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withValues(alpha: 0.4),
              ),
            ),
            Text(
              widget.updatedAt != null
                  ? DateFormat(
                      'dd - MM - yyyy',
                    ).format(widget.updatedAt!.toDate())
                  : '',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 310,
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Text(
                "Delete entry?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.red,
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Confirming will permanently delete the selected entry.\nThis action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 125,
                      height: 51,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onConfirm();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 125,
                      height: 51,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
