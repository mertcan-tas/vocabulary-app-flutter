import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/word.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

class IsarService {
  late Isar isar;

  Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      isar = await Isar.open([WordSchema], directory: directory.path);
      debugPrint("Isar Başlatıldı ${directory.path}");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveWord(Word word) async {
    try {
      await isar.writeTxn(() async {
        final id = await isar.words.put(word);
        debugPrint(
          "yeni kelime olan $word.englishWord => $id'si ile veri oluşturuldu",
        );
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateWord(Word updatedWord) async {
    try {
      await isar.writeTxn(() async {
        // Mevcut kelimeyi ID ile bul
        final existingWord = await isar.words.get(updatedWord.id);

        if (existingWord == null) {
          throw Exception('Kelime bulunamadı: ${updatedWord.id}');
        }

        // Güncellenmiş alanları kopyala
        final mergedWord = existingWord.copyWith(
          englishWord: updatedWord.englishWord,
          turkishWord: updatedWord.turkishWord,
          wordType: updatedWord.wordType,
          isLearner: updatedWord.isLearner,
          // Diğer alanlar...
        );

        // Güncellenmiş kelimeyi kaydet
        await isar.words.put(mergedWord);
      });
    } catch (e) {
      debugPrint('Güncelleme hatası: $e');
      rethrow; // Hatanın üst katmana iletilmesi için
    }
  }

  Future<List<Word>> getAllWords() async {
    try {
      final allWords = await isar.words.where().anyId().findAll();
      return allWords;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> deleteWord({required int wordID}) async {
    try {
      await isar.writeTxn(() async {
        final success = await isar.words.delete(wordID);
        debugPrint('Word deleted: $success');
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toggleWordLearned({required Word word}) async {
    try {
      await isar.writeTxn(() async {
        word.isLearner = !word.isLearner;
        await isar.words.put(word);
      });
      debugPrint("${word.id} güncellendi");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getAllDeleteWords() async {
    try {
      await isar.writeTxn(() async {
        await isar.words.clear();
        debugPrint("tüm kelimeler silindi");
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
