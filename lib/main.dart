import 'package:flutter/material.dart';
import 'create_exam_page.dart';

//Düzenlemesi
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kayıtlı Sorular Ekranı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıtlı Sorular Ekranı'),
      ),
      body: _questions.isEmpty
          ? const Center(
              child: Text('Kayıtlı sorunuz bulunmamaktadır.'),
            )
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_questions[index]['soru']),
                    subtitle: _buildOptions(_questions[index]['options']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editQuestion(index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteQuestion(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Map<String, dynamic>? newQuestion = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateExamPage()),
          );

          if (newQuestion != null) {
            setState(() {
              _questions.add(newQuestion);
            });
          }
        },
        tooltip: 'Soru Oluştur',
        child: const Icon(Icons.question_answer_sharp),
      ),
    );
  }

  Widget _buildOptions(List<dynamic> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map<Widget>((sik) {
        return Text(sik);
      }).toList(),
    );
  }

  void _editQuestion(int index) async {
    final Map<String, dynamic>? updatedQuestion = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateExamPage(
          initialQuestion: _questions[index],
        ),
      ),
    );

    if (updatedQuestion != null) {
      setState(() {
        _questions[index] = updatedQuestion;
      });
    }
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }
}
