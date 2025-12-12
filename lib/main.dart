import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10 Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          primary: const Color(0xFF6750A4),
          surfaceVariant: const Color(0xFFE7E0EC),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE8DEF8),
          centerTitle: true,
        ),
      ),
      home: const TextPreviewerScreen(),
    );
  }
}

// SCREEN 1: INPUT
class TextPreviewerScreen extends StatefulWidget {
  const TextPreviewerScreen({super.key});

  @override
  State<TextPreviewerScreen> createState() => _TextPreviewerScreenState();
}

class _TextPreviewerScreenState extends State<TextPreviewerScreen> {
  final TextEditingController _textController = TextEditingController();
  double _fontSize = 16.0;

  void _navigateToPreview(BuildContext context) async {
    // 1. Переходимо на другий екран і ЧЕКАЄМО (await) результату
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          text: _textController.text,
          fontSize: _fontSize,
        ),
      ),
    );

    if (!mounted) return;

    // 2. Якщо result == null (натиснули "Назад" на телефоні), виводимо дефолтне повідомлення
    String message = result ?? "Don't know what to say";

    _showResultDialog(message);
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://emojiisland.com/cdn/shop/products/Robot_Emoji_Icon_abe1111a-1293-4668-bdf9-9ceb05cff58e_large.png?v=1571606090',
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text previewer")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "Text",
                hintText: "Enter some text",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 50),

            Row(
              children: [
                Text("Font size: ${_fontSize.toInt()}", style: const TextStyle(fontSize: 16)),
                Expanded(
                  child: Slider(
                    value: _fontSize,
                    min: 10,
                    max: 100,
                    activeColor: Colors.deepPurple,
                    onChanged: (double value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () => _navigateToPreview(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text("Preview"),
            ),
          ],
        ),
      ),
    );
  }
}

// SCREEN 2: PREVIEW
class PreviewScreen extends StatelessWidget {
  final String text;
  final double fontSize;

  const PreviewScreen({
    super.key,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Повертаємо null (сигнал, що натиснули "Назад")
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  text.isEmpty ? "No text" : text,
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Повертаємо результат "Cool!" на перший екран
                    Navigator.pop(context, 'Cool!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("OK"),
                ),

                const SizedBox(width: 20),

                OutlinedButton(
                  onPressed: () {
                    // Повертаємо результат "Let’s try something else"
                    Navigator.pop(context, 'Let’s try something else');
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}