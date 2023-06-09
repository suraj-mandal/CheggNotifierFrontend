import 'package:chegg_no_question_notifier/pages/user_details_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CheggNotifierApp());
}

class CheggNotifierApp extends StatelessWidget {
  const CheggNotifierApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chegg Question Notifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserDetailsPage(title: 'Chegg Question Checker'),
    );
  }
}
