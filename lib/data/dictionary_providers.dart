import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taschenwoerterbuch/data/dictionary_loader.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';

final dictionaryLoaderProvider = Provider<DictionaryLoader>((ref) {
  final loader = DictionaryLoader();
  ref.onDispose(loader.close);
  return loader;
});

final dictionaryDbProvider = FutureProvider.family<Database, LangPair>(
  (ref, pair) => ref.watch(dictionaryLoaderProvider).open(pair),
);
