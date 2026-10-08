import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/data/dictionary_providers.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';

class SearchHit {
  const SearchHit({required this.entryId, required this.term});

  final int entryId;
  final String term;
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

  Future<void> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      state = const AsyncData([]);
      return;
    }
    state = await AsyncValue.guard(() async {
      final db = await ref.read(dictionaryDbProvider(_pair).future);
      final rows = await db.query(
        'lookup',
        columns: ['entry_id', 'term'],
        where: "term LIKE '%' || ? || '%'",
        whereArgs: [q, '$q￿'],
        orderBy: 'kind, length(term)',
        limit: 20,
      );
      return [
        for (final r in rows)
          SearchHit(entryId: r['entry_id']! as int, term: r['term']! as String),
      ];
    });
  }
}

final searchControllerProvider =
    AsyncNotifierProvider<SearchController, List<SearchHit>>(
      SearchController.new,
    );
