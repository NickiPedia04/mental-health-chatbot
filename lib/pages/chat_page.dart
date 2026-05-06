import 'package:flutter/material.dart';
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

    _messageInputController.clear();

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

  const ChatSidebarOpen({
    super.key,
    required this.onToggle,
    required this.sessions,
    required this.currSess,
    required this.onSessTap,
    required this.onNewSess,
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
                    trailing: PopupMenuButton<String>(
                      iconColor: sessName == currSess
                          ? Theme.of(context).colorScheme.inversePrimary
                          : null,
                      onSelected: (value) {
                        if (value == "rename") {
                          print("Rename Selected");
                        } else if (value == "delete") {
                          print("Delete Selected");
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: "rename", child: Text('Rename')),
                        PopupMenuDivider(),
                        PopupMenuItem(value: "delete", child: Text('Delete')),
                      ],
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
