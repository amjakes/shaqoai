import 'package:flutter/material.dart';

import '../screens/workspace_shell.dart';
import 'colors.dart';

void runShaqoAiApp() => runApp(const ShaqoAiApp());

class ShaqoAiApp extends StatelessWidget {
  const ShaqoAiApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ShaqoAI',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: appBackground,
          colorScheme:
              const ColorScheme.dark(primary: appCyan, secondary: appViolet),
          appBarTheme: const AppBarTheme(
              backgroundColor: appBackground,
              surfaceTintColor: Colors.transparent),
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: appSurface),
        ),
        home: const WorkspaceShell(),
      );
}
