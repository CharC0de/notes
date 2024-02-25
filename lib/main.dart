import 'package:flutter/material.dart';
import 'demo.dart';
import 'helper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const AcadNote(),
    ),
  );
}

class AcadNote extends StatefulWidget {
  const AcadNote({super.key});

  // This widget is the root of your application.

  @override
  State<AcadNote> createState() => _AcadNoteState();
}

class _AcadNoteState extends State<AcadNote> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Academic Notes',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
      ),
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey.shade300,
              brightness: Brightness.dark)),
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      //create a new class for this
      home: FormScreen(),
    );
  }
}
