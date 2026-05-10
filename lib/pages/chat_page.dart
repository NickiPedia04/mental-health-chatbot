import 'package:flutter/material.dart';
import 'package:mental_app_support/components/custom_textfield.dart';
import 'package:mental_app_support/services/ai_services.dart';
import 'package:mental_app_support/services/chat_services.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  bool isSidebarClose = true;
  final TextEditingController _messageInputController = TextEditingController();
  Map<String, List<Map<String, dynamic>>> sessions = {'Session 1': []};
  String currSess = "Session 1";
  final ScrollController _scrollController = ScrollController();
  final ChatServices _chatServices = ChatServices();
  final AIServices _aiService = AIServices();

  Future<void> createNewSess() async {
    int sessNumber = 1;

    while (sessions.containsKey("Session $sessNumber")) {
      sessNumber++;
    }

    final newSessName = "Session $sessNumber";

    setState(() {
      sessions[newSessName] = [];
      currSess = newSessName;
    });

    await _chatServices.createSess(newSessName);
  }

  void switchSess(String sessName) {
    setState(() {
      currSess = sessName;
    });
  }

  String getCurrTime() {
    final currentTime = DateTime.now();
    return "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}";
  }

  void onToggle() {
    setState(() {
      isSidebarClose = !isSidebarClose;
    });
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessage() async {
    final activateSess = currSess;

    final text = _messageInputController.text.trim();

    if (text.isEmpty) return;

    final time = getCurrTime();

    setState(() {
      sessions[activateSess]!.insert(0, {
        "text": text,
        "isReceiver": false,
        "time": time,
      });
    });

    await _chatServices.sendMessages(activateSess, text, false);

    _messageInputController.clear();

    setState(() {
      sessions[activateSess]!.insert(0, {
        "text": "Typing...",
        "isReceiver": true,
        "time": getCurrTime(),
      });
    });

    scrollToBottom();

    final aiReply = await _aiService.sendMessage(text);

    setState(() {
      sessions[activateSess]!.removeAt(0);

      sessions[activateSess]!.insert(0, {
        'text': aiReply,
        'isReceiver': true,
        'time': getCurrTime(),
      });
    });

    await _chatServices.sendMessages(activateSess, aiReply, true);

    FocusScope.of(context).unfocus();

    // reply test
    // Future.delayed(const Duration(milliseconds: 500), () async {
    //   setState(() {
    //     sessions[currSess]!.insert(0, {
    //       "text": "I'm here for you",
    //       "isReceiver": true,
    //       "time": getCurrTime(),
    //     });
    //   });
    //   await _chatServices.sendMessages(currSess, "I'm here for you", true);
    //   scrollToBottom();
    // });
  }

  // rename chat sess
  Future<void> renameSess(String oldSess, String newSess) async {
    if (newSess.trim().isEmpty) return;

    final oldMessages = sessions[oldSess]!;

    setState(() {
      sessions.remove(oldSess);

      sessions[newSess] = oldMessages;

      if (currSess == oldSess) {
        currSess = newSess;
      }
    });

    await _chatServices.renameSess(oldSess, newSess);
  }

  // delete sess
  Future<void> deleteSess(String sessName) async {
    setState(() {
      sessions.remove(sessName);

      if (currSess == sessName) {
        if (sessions.isNotEmpty) {
          currSess = sessions.keys.first;
        } else {
          sessions['Session 1'] = [];

          currSess = 'Session 1';
        }
      }
    });

    await _chatServices.deleteSess(sessName);

    if (sessions.length == 1 && sessions.containsKey('Session 1')) {
      await _chatServices.createSess('Session 1');
    }
  }

  // initialize chat
  Future<void> initializeChat() async {
    final loadedSess = await _chatServices.loadSess();

    Map<String, List<Map<String, dynamic>>> loadedData = {};

    for (String sessName in loadedSess) {
      final messages = await _chatServices.loadMessages(sessName);

      loadedData[sessName] = messages;
    }

    if (!mounted) return;

    setState(() {
      if (loadedSess.isEmpty) {
        sessions = {"Session 1": []};

        currSess = "Session 1";
      } else {
        sessions = loadedData;
        currSess = loadedSess.first;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    initializeChat();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currMessages = sessions[currSess] ?? [];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Row(
          children: [
            isSidebarClose
                ? ChatSidebarClose(onToggle: onToggle)
                : ChatSidebarOpen(
                    onToggle: onToggle,
                    sessions: sessions,
                    currSess: currSess,
                    onSessTap: switchSess,
                    onNewSess: createNewSess,
                    onRename: renameSess,
                    onDelete: deleteSess,
                  ),
            Expanded(
              child: Column(
                children: [
                  // Messages
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      itemCount: currMessages.length,
                      itemBuilder: (context, index) {
                        final msg = currMessages[index];

                        return ChatBubble(
                          isReceiver: msg['isReceiver'],
                          text: msg['text'],
                          time: msg['time'],
                        );
                      },
                    ),
                  ),
                  // Input Textfield
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 17,
                      right: 17,
                      bottom: 10,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.attachment_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _messageInputController,
                              decoration: InputDecoration(
                                hintText: "Enter message here...",
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withValues(alpha: 0.4),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: sendMessage,
                            icon: Icon(
                              Icons.send_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatSidebarClose extends StatelessWidget {
  final VoidCallback onToggle;

  const ChatSidebarClose({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              onToggle();
            },
            icon: Icon(Icons.keyboard_double_arrow_right_outlined),
          ),
          SizedBox(height: 10),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_circle_outline_outlined),
          ),
        ],
      ),
    );
  }
}

class ChatSidebarOpen extends StatelessWidget {
  final VoidCallback onToggle;
  final Map<String, List<Map<String, dynamic>>> sessions;
  final String currSess;
  final Function(String) onSessTap;
  final VoidCallback onNewSess;
  final Function(String, String) onRename;
  final Function(String) onDelete;

  const ChatSidebarOpen({
    super.key,
    required this.onToggle,
    required this.sessions,
    required this.currSess,
    required this.onSessTap,
    required this.onNewSess,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final sessKeys = sessions.keys.toList();
    return Container(
      width: 210,
      height: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Column(
        children: [
          // Sidebar toggle
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: IconButton(
              onPressed: () {
                onToggle();
              },
              icon: Icon(Icons.keyboard_double_arrow_left_outlined),
            ),
          ),

          // New Session
          ListTile(
            leading: Icon(Icons.add_circle_outline_outlined),
            title: Text('New Session'),
            onTap: onNewSess,
          ),

          // Search Textfield
          Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 17),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(
                    context,
                  ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                ),
                hintText: "Search",
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 17),
            child: Divider(
              color: Theme.of(
                context,
              ).colorScheme.inversePrimary.withValues(alpha: 0.2),
              thickness: 2,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: sessKeys.length,
              itemBuilder: (context, index) {
                final sessName = sessKeys[index];

                return Material(
                  color: sessName == currSess
                      ? Theme.of(
                          context,
                        ).colorScheme.inversePrimary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  child: ListTile(
                    selected: sessName == currSess,

                    title: Text(
                      sessName,
                      style: TextStyle(
                        color: sessName == currSess
                            ? Theme.of(context).colorScheme.inversePrimary
                            : null,
                      ),
                    ),
                    onTap: () {
                      onSessTap(sessName);
                    },
                    trailing: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                      child: PopupMenuButton<String>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            width: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: 0.3),
                          ),
                        ),
                        elevation: 0,
                        onSelected: (value) {
                          // rename sess
                          if (value == "rename") {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => RenameSessionDialog(
                                oldSess: sessName,
                                onRename: onRename,
                              ),
                            );
                            print("Rename Selected");
                          }
                          // delete sess
                          else if (value == "delete") {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => DeleteDialog(
                                onDelete: onDelete,
                                targetedSess: sessName,
                              ),
                            );
                            print("Delete Selected");
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: "rename", child: Text('Rename')),
                          PopupMenuDivider(
                            thickness: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.inversePrimary.withValues(alpha: 0.2),
                          ),
                          PopupMenuItem(value: "delete", child: Text('Delete')),
                        ],
                        icon: Icon(Icons.more_vert),
                        iconColor: sessName == currSess
                            ? Theme.of(context).colorScheme.inversePrimary
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RenameSessionDialog extends StatelessWidget {
  final String oldSess;

  final TextEditingController _renameSessionController =
      TextEditingController();

  final Function(String, String) onRename;

  RenameSessionDialog({
    super.key,
    required this.oldSess,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 310,
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Rename $oldSess",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextfield(
                hintText: oldSess,
                textController: _renameSessionController,
                horzonPadding: 0,
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
                      onRename(oldSess, _renameSessionController.text.trim());
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

class DeleteDialog extends StatelessWidget {
  final String targetedSess;

  final Function(String) onDelete;

  const DeleteDialog({
    super.key,
    required this.onDelete,
    required this.targetedSess,
  });

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
                      onDelete(targetedSess);
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

class ChatBubble extends StatelessWidget {
  final bool isReceiver;
  final String text;
  final String time;

  const ChatBubble({
    super.key,
    required this.isReceiver,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17, right: 17, bottom: 10),
      child: Align(
        alignment: isReceiver
            ?
              // Bot
              Alignment.centerLeft
            :
              // User
              Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: 225),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isReceiver
                ?
                  // bot
                  Theme.of(context).colorScheme.primary
                :
                  // user
                  Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  time,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
