import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/data/dictionary_providers.dart';
import 'package:taschenwoerterbuch/data/fold.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';

/// A search hit with multiple entries.
/// Example: `SearchHit("maison", [{id: 78, pos: "noun"}, {id: 98, pos: "adj"}])`.
class SearchHit {
  const SearchHit({required this.term, required this.entries});

  final String term;
  final List<({int id, String? pos})> entries;
}

class SearchController extends AsyncNotifier<List<SearchHit>> {
  LangPair _pair = LangPair.frDe;

  LangPair get pair => _pair;

  @override
  Future<List<SearchHit>> build() async {
    await ref.watch(dictionaryDbProvider(_pair).future);
    return const [];
  }

  void setPair(LangPair pair) {
    _pair = pair;
    ref.invalidateSelf();
  }

  int _requestId = 0;

  Future<void> search(String query) async {
    final id = ++_requestId;
    final q = fold(query.trim());
    if (q.isEmpty) {
      state = const AsyncData([]);
      return;
    }
    final result = await AsyncValue.guard(() async {
      final db = await ref.read(dictionaryDbProvider(_pair).future);
      final rows = await db.query(
        "lookup l JOIN entry e ON e.id = l.entry_id",
        columns: ["l.term", "l.entry_id", "e.pos", "MIN(l.kind) AS kind"],
        where: "l.term_fold LIKE '%' || ? || '%'",
        whereArgs: [q],
        groupBy: "l.term, l.entry_id",
        orderBy: "kind, length(l.term_fold), l.term_fold, l.term, l.entry_id",
        limit: 100,
      );
      final grouped = <String, List<({int id, String? pos})>>{};
      for (final r in rows) {
        grouped.putIfAbsent(r['term']! as String, () => []).add((
          id: r['entry_id']! as int,
          pos: r['pos'] as String?,
        ));
      }
      return [
        for (final e in grouped.entries)
          SearchHit(term: e.key, entries: e.value),
      ];
    });
    if (id == _requestId) state = result;
  }
}

final searchControllerProvider =
    AsyncNotifierProvider<SearchController, List<SearchHit>>(
      SearchController.new,
    );
