import 'package:chegg_no_question_notifier/model/availability_status.dart';
import 'package:chegg_no_question_notifier/service/notification_service.dart';
import 'package:flutter/material.dart';


class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  // used to handle the input from the user
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<AvailabilityStatus>? _availabilityStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20.0),
          child: buildColumn()),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
              hintText: 'Enter username', border: OutlineInputBorder()),
        ),
        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
              hintText: 'Enter password', border: OutlineInputBorder()),
          obscureText: true,
        ),
        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
        ElevatedButton(
            onPressed: () {
              setState(() {
                NotificationService notificationService = NotificationService(
                    username: _usernameController.text,
                    password: _passwordController.text);
                _availabilityStatus = notificationService.fetchQuestionStatus();
              });
            },
            child: const Text('Check Status')),
        const Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
        (_availabilityStatus != null) ? buildFutureBuilder() : Container()
      ],
    );
  }

  FutureBuilder<AvailabilityStatus> buildFutureBuilder() {
    return FutureBuilder<AvailabilityStatus>(
        future: _availabilityStatus,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String output = snapshot.data!.available
                ? 'Question Available'
                : 'Question Not Available';
            return Text(output);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        });
  }
}
