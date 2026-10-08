import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taschenwoerterbuch/core/paths.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';

class DictionaryLoader {
  DictionaryLoader();

  final _open = <LangPair, Future<Database>>{};

  /// Open database for given [LangPair].
  Future<Database> open(LangPair pair) {
    return _open.putIfAbsent(pair, () => _load(pair));
  }

  /// Close all open databases.
  Future<void> close() async {
    final pending = _open.values.toList();
    _open.clear();
    for (final future in pending) {
      try {
        await (await future).close();
      } catch (_) {}
    }
  }

  /// Load the given [LangPair] and open its database.
  Future<Database> _load(LangPair pair) async {
    try {
      final path = await Paths.dictionaryFile(pair);
      await _ensureCopied(Paths.dictionaryAsset(pair), path);
      return await openDatabase(path, readOnly: true, singleInstance: true);
    } catch (_) {
      _open.remove(pair);
      rethrow;
    }
  }

  Future<void> _ensureCopied(String asset, String target) async {
    final data = await rootBundle.load(asset);
    final file = File(target);
    if (await file.exists() && await file.length() == data.lengthInBytes) {
      return;
    }
    await file.parent.create(recursive: true);
    final tmp = File('$target.tmp');
    await tmp.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
    await tmp.rename(target);
  }
}
