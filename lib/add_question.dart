import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  File? _imageFile;
  String? _correctAnswer;

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> questionData = {
        'soru': _questionController.text,
        'options': [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ],
        'correctAnswer': _correctAnswer,
        'image': _imageFile,
      };

      Navigator.pop(context, questionData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soru Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Icon(Icons.add_a_photo,
                                size: 50, color: Colors.grey),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _questionController,
                  decoration: const InputDecoration(labelText: 'Soru'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen Cevabı Giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildOptionTextField(_option1Controller, 'ŞIK A'),
                _buildOptionTextField(_option2Controller, 'ŞIK B'),
                _buildOptionTextField(_option3Controller, 'ŞIK C'),
                _buildOptionTextField(_option4Controller, 'ŞIK D'),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _correctAnswer,
                  onChanged: (value) {
                    setState(() {
                      _correctAnswer = value;
                    });
                  },
                  items: [
                    'ŞIK A',
                    'ŞIK B',
                    'ŞIK C',
                    'ŞIK D',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Doğru Cevap'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen Doğru Şıkkı Seçiniz.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Soruyu Kaydet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen Şık Giriniz.';
        }
        return null;
      },
    );
  }
}
