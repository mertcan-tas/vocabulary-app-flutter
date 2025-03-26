import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/word.dart';
import 'package:flutter_application_2/services/isar_service.dart';

class KelimeEkle extends StatefulWidget {
  final IsarService isarService;
  const KelimeEkle({super.key, required this.isarService});

  @override
  State<KelimeEkle> createState() => _KelimeEkleState();
}

class _KelimeEkleState extends State<KelimeEkle> {
  final _formKey = GlobalKey<FormState>();
  final _englishController = TextEditingController();
  final _turkishController = TextEditingController();
  final _storyController = TextEditingController();
  bool isLearner = false;

  static const List<String> list = <String>[
    "Noun",
    "Adjective",
    "Verb",
    "Adverb",
    "Phrasal Verb",
  ];

  String dropdownValue = list.first;

  Future<void> _saveWord() async {
    if (_formKey.currentState!.validate()) {
      var engword = _englishController.text;
      var trword = _turkishController.text;
      var stry = _storyController.text;

      Word word = Word(
        englishWord: engword,
        turkishWord: trword,
        wordType: dropdownValue,
        story: stry,
      );
      await widget.isarService.saveWord(word);
    }
  }

  @override
  void dispose() {
    _englishController.dispose();
    _turkishController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lütfen gerekli alanı doldur";
                  }
                  return null;
                },
                controller: _englishController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'English Word',
                  hintText: 'English Word',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lütfen gerekli alanı doldur";
                  }
                  return null;
                },
                controller: _turkishController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Turkish Word',
                  hintText: 'Turkish Word',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: DropdownButtonFormField<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Idiom',
                  hintText: 'Idiom',
                ),

                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items:
                    list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                maxLines: 3,
                controller: _storyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Story',
                  hintText: 'Story',
                ),
              ),
            ),

            Row(
              spacing: 3,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    activeColor: Colors.deepOrange.shade400,
                    value: isLearner,
                    onChanged: (value) {
                      setState(() {
                        isLearner = !isLearner;
                      });
                    },
                  ),
                ),
                Text(
                  "Bunu Öğrendim",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),

            OutlinedButton.icon(
              onPressed: () {
                bool isValid = _formKey.currentState!.validate();
                if (isValid) {
                  _saveWord();
                  _formKey.currentState?.reset();

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Kelime Kaydedildi')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lütfen gerekli verileri doğrulayın'),
                      duration: Duration(milliseconds: 200),
                    ),
                  );
                }
              },
              label: Text("Kaydet", style: TextStyle(color: Colors.black54)),
              icon: Icon(Icons.save, color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}
