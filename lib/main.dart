import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_theme.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/features/search/search_screen.dart';
import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_button.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_dialog.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_nav_bar.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_progress_indicator.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_text_field.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: const Locale('de'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SearchScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _navItems = [
    SketchNavItem(icon: Icons.search, label: 'Suche'),
    SketchNavItem(icon: Icons.table_chart_outlined, label: 'Konjugation'),
    SketchNavItem(icon: Icons.settings_outlined, label: 'Einstellungen'),
  ];

  final _searchController = TextEditingController();
  int _tab = 0;
  double _progress = 0.3;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDialog() {
    showSketchDialog<void>(
      context: context,
      title: 'Eintrag löschen?',
      content: const Text('Dieser Eintrag wird aus deiner Liste entfernt.'),
      actions: [
        Builder(
          builder: (ctx) => SketchButton(
            label: 'Abbrechen',
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ),
        Builder(
          builder: (ctx) => SketchButton(
            label: 'Löschen',
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              _navItems[_tab].label,
              style: AppTypography.headlineSerif.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const _Section('Buttons'),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  SketchButton(label: 'Aktiv', onPressed: () {}),
                  const SketchButton(label: 'Inaktiv', onPressed: null),
                ],
              ),
            ),
            const _Section('Textfelder'),
            SketchTextField(
              label: 'Suchbegriff',
              hint: 'z. B. maison',
              controller: _searchController,
            ),
            const SizedBox(height: 8),
            const SketchTextField(
              label: 'Passwort',
              obscureText: true,
              errorText: 'Mindestens 8 Zeichen',
            ),
            const SizedBox(height: 8),
            const SketchTextField(
              label: 'Deaktiviert',
              hint: 'Nicht editierbar',
              enabled: false,
            ),
            const _Section('Dialog'),
            Align(
              alignment: Alignment.centerLeft,
              child: SketchButton(
                label: 'Dialog öffnen',
                onPressed: _openDialog,
              ),
            ),
            const _Section('Fortschritt'),
            SketchProgressBar(value: _progress),
            const SizedBox(height: 8),
            const SketchProgressBar(),
            const SizedBox(height: 8),
            Row(
              children: [
                const SketchSpinner(),
                const SizedBox(width: 16),
                SketchButton(
                  label: '+10 %',
                  onPressed: () => setState(
                    () => _progress = _progress >= 1 ? 0 : _progress + .1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SketchNavBar(
        items: _navItems,
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.sectionTitle.copyWith(
          color: context.colors.textLabel,
        ),
      ),
    );
  }
}
