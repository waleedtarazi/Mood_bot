// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
    
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  Future<void> sendMessage(String text) async {
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true,));
    });

    try {
      Dio dio = Dio();
      Response response = await dio.post(
        // 'http://waleedtarazi.pythonanywhere.com/testing',
        'http://192.168.43.179:5005/webhooks/rest/webhook',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ),
        data: {"message": text},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        for (var item in data) {
          if (item.containsKey('text')) {
            setState(() {
              _messages.insert(0, ChatMessage(text: item['text'], isUser: false,));

            });
          }
        }
      } else {
        throw Exception('Failed to connect to Rasa server.');
      }
    } catch (e) {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rasa Chatbot'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  children: [
                   Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (String text) async {
                          if (text.trim().isNotEmpty) {
                            await sendMessage(text);
                            _controller.clear();
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Type your message',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (_controller.text.trim().isNotEmpty) {
                          await sendMessage(_controller.text);
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({super.key, required this.text, required this.isUser});

   @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
                          backgroundColor: Colors.purple,
                          child:  Image.asset('assets/images/rasa.png',fit: BoxFit.cover)
                        ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment:
                 isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: isUser ? const Color.fromARGB(255, 66, 170, 245) : Colors.purple,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16.0),
                      topRight: const Radius.circular(16.0),
                      bottomLeft: isUser
                          ? const Radius.circular(16.0)
                          : const Radius.circular(0.0),
                      bottomRight: isUser
                          ? const Radius.circular(0.0)
                          : const Radius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUser)
                     CircleAvatar(
                          backgroundColor: Colors.purple,
                          child:  Image.asset('assets/images/man.png', fit: BoxFit.cover,)
                        ),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }
}