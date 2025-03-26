import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/word.dart';
import 'package:flutter_application_2/services/isar_service.dart';
import 'package:flutter_application_2/views/kelime_duzenle.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KelimelerListesi extends StatefulWidget {
  final IsarService isarService;

  const KelimelerListesi({super.key, required this.isarService});

  @override
  State<KelimelerListesi> createState() => _KelimelerListesiState();
}

class _KelimelerListesiState extends State<KelimelerListesi> {
  List<Word> _kelimeler = [];
  List<Word> _filteredKelimeler = [];
  bool _isLoading = true;

  static const List<String> list = <String>[
    "All",
    "Noun",
    "Adjective",
    "Verb",
    "Adverb",
    "Phrasal Verb",
  ];

  String dropdownValue = list.first;
  bool _showLearned = false;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await widget.isarService.getAllWords();
    setState(() {
      _kelimeler = words;
      _isLoading = false;
      applyFilter();
    });
  }

  void _toggleUpdateWord(Word word, bool newValue) async {
    await widget.isarService.toggleWordLearned(word: word);
    final index = _kelimeler.indexWhere((element) => element.id == word.id);
    setState(() {
      // Use the copyWith method to create a new instance with updated value
      _kelimeler[index] = _kelimeler[index].copyWith(isLearner: newValue);
    });
    applyFilter();
  }

  void applyFilter() {
    List<Word> filtered = List.from(_kelimeler);

    if (dropdownValue != 'All') {
      filtered =
          filtered
              .where((element) => element.wordType == dropdownValue)
              .toList();
    }

    if (_showLearned) {
      filtered = filtered.where((element) => !element.isLearner).toList();
    }

    setState(() {
      _filteredKelimeler = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_kelimeler.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/svg/no-data.svg",
                height: 150,
                semanticsLabel: 'No Data',
              ),
              const SizedBox(height: 15),
              const Text("Bir Şey Bulamadık"),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 17, right: 17, top: 17),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.filter_alt_off_outlined, size: 22),
                          SizedBox(width: 5),
                          Text("Filtrele", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      SizedBox(
                        width: 170,
                        height: 45,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15),
                            labelText: 'Idiom',
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                            applyFilter();
                          },
                          items:
                              list.map<DropdownMenuItem<String>>((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Öğrendiklerimi gizle",
                          style: TextStyle(fontSize: 14),
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: _showLearned,
                            activeColor: Colors.deepOrange.shade400,
                            onChanged: (value) {
                              setState(() {
                                _showLearned = value;
                              });
                              applyFilter();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredKelimeler.length,
              itemBuilder: (context, index) {
                final word = _filteredKelimeler[index];
                return Dismissible(
                  key: Key(word.id.toString()),
                  direction: DismissDirection.horizontal,
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Düzenle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.edit, color: Colors.white, size: 22),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.delete, color: Colors.white, size: 22),
                        const SizedBox(width: 5),
                        Text(
                          'Sil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      // Sağa sürükle - Silme işlemi
                      widget.isarService.deleteWord(wordID: word.id);
                      setState(() {
                        _kelimeler.removeWhere((e) => e.id == word.id);
                        _filteredKelimeler.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kelime Silindi'),
                          duration: Duration(milliseconds: 200),
                        ),
                      );
                    }
                  },
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      // Sağa sürükleme onayı
                      return await showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: const Text("Silinsin mi?"),
                              content: Text(
                                "${word.englishWord} silinecek, emin misin?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("İptal"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text(
                                    "Sil",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    } else if (direction == DismissDirection.endToStart) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => KelimeDuzenle(
                                isarService: widget.isarService,
                                word: word,
                              ),
                        ),
                      );
                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kelime Güncellendi'),
                            duration: Duration(milliseconds: 700),
                          ),
                        );
                        _loadWords(); // Listeyi yenile
                      }
                      return false; // Item'ın dismiss olmasını engelle
                    }
                    return false;
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(word.englishWord),
                          subtitle: Text(word.turkishWord),
                          leading: Transform.scale(
                            scale: 0.8,
                            child: Chip(label: Text(word.wordType)),
                          ),
                          trailing: Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              activeColor: Colors.deepOrange.shade400,
                              value: word.isLearner,
                              onChanged:
                                  (value) => _toggleUpdateWord(word, value),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                size: 16,
                                color: Colors.black38,
                              ),
                              SizedBox(width: 5),
                              Text("Hatırlatıcı Not"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
