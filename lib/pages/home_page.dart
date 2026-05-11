import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_app_support/components/custom_button.dart';
import 'package:mental_app_support/pages/note_page.dart';
import 'package:mental_app_support/services/note_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final noteServ = noteService();
  String temp = FirebaseAuth.instance.currentUser!.uid;
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
                    SizedBox(width: 40),
                    SizedBox(width: 40),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => NotePage()),
                        );
                      },
                      icon: Icon(Icons.add_circle_outline, size: 30),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: noteServ.getNote(),
                builder: (context, snapshot) {
                  // Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final docs = snapshot.data!.docs;

                  // if empty
                  if (docs.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(height: 100),
                        Text(
                          "You have not created any entries",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Start writing your first journal ⭐",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          textButton: '+ Create Entry',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => NotePage()),
                          ),
                        ),
                      ],
                    );
                  }

                  final notes = docs;

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];

                      return Column(
                        children: [
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotePage(
                                    docId: note.id,
                                    header: note['header'],
                                    content: note['content'],
                                    updatedAt: note['updatedAt'],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 55,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        // Header
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            note['header'].toString().isNotEmpty
                                                ? note['header']
                                                : '(No Title)',
                                          ),
                                        ),

                                        // Body
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Row Left => Content
                                              Expanded(
                                                child: Text(
                                                  note['content']
                                                          .toString()
                                                          .isNotEmpty
                                                      ? note['content']
                                                      : '(No content)',
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 10),

                                              // Row right => Dates
                                              Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(height: 2),
                                                    Text(
                                                      note['createdAt'] != null
                                                          ? 'Date Created:\n${DateFormat('dd - MM - yyyy').format(note['createdAt'].toDate())}'
                                                          : '',

                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inversePrimary
                                                            .withValues(
                                                              alpha: 0.4,
                                                            ),
                                                      ),
                                                    ),
                                                    Text(
                                                      note['updatedAt'] != null
                                                          ? 'Last Updated:\n${DateFormat('dd - MM - yyyy').format(note['updatedAt'].toDate())}'
                                                          : '',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inversePrimary
                                                            .withValues(
                                                              alpha: 0.4,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
