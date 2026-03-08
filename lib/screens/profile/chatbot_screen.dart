import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: 'YOUR_API_KEY_HERE',
  );

  Future<void> sendMessage(String text) async {

    setState(() {
      messages.add({"role": "user", "text": text});
    });

    final prompt = """
You are a helpful assistant for a restaurant mobile application.

You ONLY answer questions related to:
- Food
- Menu items
- Orders
- Reservations
- Payment
- App usage
- Restaurant information

If the user asks something unrelated, politely respond:
"I'm here to help with food and app related questions."

User question:
$text
""";

    final response = await model.generateContent([Content.text(prompt)]);

    setState(() {
      messages.add({
        "role": "bot",
        "text": response.text ?? "Sorry, I couldn't answer that."
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Assistant")),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {

                final msg = messages[index];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.orange : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["text"] ?? ""),
                  ),
                );
              },
            ),
          ),

          Row(
            children: [

              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Ask about food or the app...",
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = _controller.text;
                  _controller.clear();
                  sendMessage(text);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}