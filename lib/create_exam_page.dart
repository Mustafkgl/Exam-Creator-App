import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateExamPage extends StatefulWidget {
  final Map<String, dynamic>? initialQuestion; // Başlangıç sorusu parametresi

  const CreateExamPage({super.key, this.initialQuestion});

  @override
  _CreateExamPageState createState() => _CreateExamPageState();
}

class _CreateExamPageState extends State<CreateExamPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  File? _imageFile;
  String? _correctAnswer;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuestion != null) {
      // Eğer başlangıç sorusu varsa, form alanlarını doldur
      _questionController.text = widget.initialQuestion!['soru'];
      _option1Controller.text = widget.initialQuestion!['sik'][0];
      _option2Controller.text = widget.initialQuestion!['sik'][1];
      _option3Controller.text = widget.initialQuestion!['sik'][2];
      _option4Controller.text = widget.initialQuestion!['sik'][3];
      _correctAnswer = widget.initialQuestion!['correctAnswer'];
      _imageFile = widget.initialQuestion!['image'];
    }
  }

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
        'sik': [
          _option1Controller.text,
          _option2Controller.text,
          _option3Controller.text,
          _option4Controller.text,
        ],
        'correctAnswer': _correctAnswer,
        'image': _imageFile,
      };

      Navigator.pop(context, questionData); // Veriyi geri gönder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialQuestion == null
            ? 'Soru Oluştur'
            : 'Soruyu Düzenle'), // Başlık dinamik olarak değişiyor
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
                      return 'Lütfen Soru Giriniz.';
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
                      return 'Lütfen Doğru Cevabı Seçiniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.initialQuestion == null
                      ? 'Soruyu Kaydet'
                      : 'Soruyu Düzenle'),
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
          return 'Lütfen Gerekli Şıkkı Giriniz.';
        }
        return null;
      },
    );
  }
}
