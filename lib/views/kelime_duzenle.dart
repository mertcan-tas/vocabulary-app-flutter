import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/word.dart';
import 'package:flutter_application_2/services/isar_service.dart';

class KelimeDuzenle extends StatefulWidget {
  final IsarService isarService;
  final Word word;

  const KelimeDuzenle({
    super.key,
    required this.isarService,
    required this.word,
  });

  @override
  State<KelimeDuzenle> createState() => _KelimeDuzenleState();
}

class _KelimeDuzenleState extends State<KelimeDuzenle> {
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

  Future<void> _updateWord() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedWord = widget.word.copyWith(
          englishWord: _englishController.text,
          turkishWord: _turkishController.text,
          wordType: dropdownValue,
          story: _storyController.text,
          isLearner: isLearner,
        );

        await widget.isarService.updateWord(updatedWord);

        // Başarılı kayıt sonrası
        Navigator.of(
          context,
        ).pop(true); // true parametresi güncelleme başarılı olduğunu gösterir
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Güncelleme başarısız: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    _englishController.text = widget.word.englishWord;
    _turkishController.text = widget.word.turkishWord;
    _storyController.text = widget.word.story!;
    isLearner = widget.word.isLearner;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kelimeyi Düzenle",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange.shade400,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded, size: 28, color: Colors.white),
        ),
      ),
      body: Padding(
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
                        setState(() {});
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
                  _updateWord();
                },
                label: Text("Kaydet", style: TextStyle(color: Colors.black54)),
                icon: Icon(Icons.save, color: Colors.black38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
