// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar/isar.dart';

part 'word.g.dart';

@collection
class Word {
  Id id = Isar.autoIncrement;
  late String englishWord;
  late String turkishWord;
  late String wordType;
  String? story;

  bool isLearner = false;

  Word({
    required this.englishWord,
    required this.turkishWord,
    required this.wordType,
    this.story,
  });

  // CopyWith metodu eklendi
  Word copyWith({
    Id? id,
    String? englishWord,
    String? turkishWord,
    String? wordType,
    String? story,
    List<int>? imageBytes,
    bool? isLearner,
  }) {
    return Word(
        englishWord: englishWord ?? this.englishWord,
        turkishWord: turkishWord ?? this.turkishWord,
        wordType: wordType ?? this.wordType,
        story: story ?? this.story,
      )
      ..id = id ?? this.id
      ..isLearner = isLearner ?? this.isLearner;
  }
}
