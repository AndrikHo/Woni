import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woni/core/theme/woni_theme.dart';
import 'package:woni/core/state/app_state.dart';
import 'package:woni/woni_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const WoniApp());
}

class WoniApp extends StatefulWidget {
  const WoniApp({super.key});

  @override
  State<WoniApp> createState() => _WoniAppState();
}

class _WoniAppState extends State<WoniApp> {
  final _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: ListenableBuilder(
        listenable: _appState,
        builder: (context, _) => MaterialApp(
          title: 'woni',
          debugShowCheckedModeBanner: false,
          theme: WoniTheme.light(),
          darkTheme: WoniTheme.dark(),
          themeMode: _appState.themeMode,
          home: const WoniShell(),
        ),
      ),
    );
  }
}
