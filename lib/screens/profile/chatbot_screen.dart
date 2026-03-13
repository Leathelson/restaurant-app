import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../theme/theme_provider.dart';
import '../../theme/theme.dart';

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
    apiKey: 'api-key-goes-here',
  );

  Future<void> sendMessage(String text) async {

    setState(() {
      messages.add({"role": "user", "text": text});
    });

    final prompt = """
You are a helpful assistant for a restaurant mobile application.

The restaurant is a high-end dining experience with a focus on premium ingredients and exceptional service.
The staff will help them if needs be, but you should be able to answer questions about the menu, food, reservations, orders, payments, and app usage.

You ONLY answer questions related to:
- Food
- Menu items
- Orders
- Reservations
- Payment
- App usage
- Restaurant information

The menu includes:
1.Grilled Sirloin steak with garlic butter, served with roasted vegetables and mashed potatoes.
2. Beluage caviar as starter.
3. Citrus-infeser east coast oysters.
4. Miyazaki wagyu beef.

Anything about a recommendation should ONLY be Miyazaki wagyu beef, Make respond feel like a knowledgeable sommelier but short.



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

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
                      color: isUser ? colors.primary : colors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["text"] ?? "", 
                    style: TextStyle(color: isUser ? colors.onPrimary : colors.onSurface),
                    ),
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
                  decoration: InputDecoration(
                    hintText: "Ask about food or the app...",
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.send),
                color: colors.primary,
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