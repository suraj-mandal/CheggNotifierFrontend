import 'dart:async';

import 'package:chegg_no_question_notifier/exceptions/service_exceptions.dart';
import 'package:chegg_no_question_notifier/model/availability_status.dart';
import 'package:chegg_no_question_notifier/service/chegg_question_status_service.dart';
import 'package:chegg_no_question_notifier/widgets/separator.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.import 'package:chegg_no_question_notifier/exceptions/service_exceptions.dart';

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
  AvailabilityStatus? _availabilityStatus;

  bool isTimerOn = false;
  bool isLoading = false;

  bool passwordVisible = false;

  bool statusButtonDisabled = false;

  String? _error;

  void checkForQuestion() async {
    setState(() {
      _error = null;
      _availabilityStatus = null;
      isLoading = true;
      statusButtonDisabled = true;
    });
    CheggQuestionStatusService notificationService = CheggQuestionStatusService(
        username: _usernameController.text, password: _passwordController.text);
    try {
      var status = await notificationService.fetchQuestionStatus();
      setState(() {
        isLoading = false;
        _availabilityStatus = status;
        statusButtonDisabled = false;
      });
    } catch (e) {
      String serviceError = fetchErrorString(e);
      setState(() {
        isLoading = false;
        _error = serviceError;
        statusButtonDisabled = false;
      });
    }
  }

  void reset() {
    setState(() {
      _error = null;
      _availabilityStatus = null;
      isLoading = false;
      isTimerOn = false;
      statusButtonDisabled = false;
    });
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    hintText: 'Enter Chegg Expert Username',
                    border: OutlineInputBorder(),
                    labelText: 'Expert Username'),
              ),
              const Separator(),
              TextField(
                controller: _passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                    hintText: 'Enter password',
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    )),
              ),
              const Separator(),
              ElevatedButton(
                  onPressed: statusButtonDisabled ? null : checkForQuestion,
                  child: const Text('Check Status')),
              const Separator(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isTimerOn
                      ? ElevatedButton(
                          onPressed: reset, child: const Text('Stop Timer'))
                      : ElevatedButton(
                          onPressed: () {
                            // save the details to a cache db to be accessed later

                            // simulate the timer that will send api requests after every 30 seconds
                            setState(() {
                              isTimerOn = true;
                            });

                            checkForQuestion();

                            Timer.periodic(const Duration(seconds: 60),
                                (timer) {
                              if (!isTimerOn) {
                                debugPrint('Timer is canceled!');
                                timer.cancel();
                              } else if (!isLoading) {
                                debugPrint(timer.tick.toString());
                                checkForQuestion();
                              }
                            });
                          },
                          child: const Text('Time it'))
                ],
              ),
              const Separator(),
              isLoading ? const CircularProgressIndicator() : Container(),
              _availabilityStatus != null
                  ? buildResult(_availabilityStatus)
                  : Container(),
              buildError(_error)
            ],
          )),
    );
  }

  String fetchErrorString(Object e) {
    if (e is ServerException) {
      return 'Server is down. Try again later';
    } else if (e is BadRequestException) {
      return 'Invalid credentials';
    } else if (e is ClientException) {
      return 'Not connected to internet';
    } else {
      return 'Application has failed! Contact the developer';
    }
  }

  Widget buildError(String? error) {
    if (error != null) {
      return Text(error);
    }
    return Container();
  }

  Text buildResult(AvailabilityStatus? status) {
    return status!.available
        ? const Text('Question available')
        : const Text('Question not available');
  }

  // Column buildColumn() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[],
  //   );
  // }

  // FutureBuilder<AvailabilityStatus> buildFutureBuilder() {
  //   return FutureBuilder<AvailabilityStatus>(
  //       future: _availabilityStatus,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           String output = snapshot.data!.available
  //               ? 'Question Available'
  //               : 'Question Not Available';
  //           isLoading = false;
  //           _availabilityStatus = null;
  //           return Text(output);
  //         } else if (snapshot.hasError) {
  //           isLoading = false;
  //           _availabilityStatus = null;
  //           return Text('${snapshot.error}');
  //         }

  //         return isLoading ? const CircularProgressIndicator() : Container();
  //       });
  // }
}
