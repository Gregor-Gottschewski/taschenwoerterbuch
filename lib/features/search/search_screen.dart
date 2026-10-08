import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';
import 'package:taschenwoerterbuch/features/search/search_controller.dart';
import 'package:taschenwoerterbuch/features/search/widgets/direction_switch.dart';
import 'package:taschenwoerterbuch/features/search/widgets/search_bar_bottom.dart';

import '../../shared/widgets/sketch_progress_indicator.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchTextController = TextEditingController();
  LangPair _pair = LangPair.frDe;

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(_onQueryChanged);
  }

  void _onQueryChanged() {
    ref
        .read(searchControllerProvider.notifier)
        .search(_searchTextController.text);
  }

  void _togglePair() {
    setState(() => _pair = _pair.reversed);
    ref.read(searchControllerProvider.notifier).setPair(_pair);
    _onQueryChanged();
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onQueryChanged);
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hits = ref.watch(searchControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Wörterbuch',
                  style: AppTypography.headlineSerif.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: hits.when(
                  data: (list) =>
                      ListView(children: [for (final h in list) Text(h.term)]),
                  loading: () => const Center(child: SketchSpinner()),
                  error: (e, _) => Text('Wörterbuch nicht ladbar: $e'),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DirectionSwitch(pair: _pair, onPressed: _togglePair),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SearchBarBottom(controller: _searchTextController),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
