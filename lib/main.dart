import 'package:flutter/material.dart';
import 'package:lab02/data_repository.dart';
import 'package:lab02/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: "Login"),
        '/profile': (context) => const ProfilePage()
      },
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
  late TextEditingController loginController;
  late TextEditingController passController;

  var passText = "";
  var source = "assets/question-mark.png";

  void buttonClick() {
    setState(() {
      passText = passController.value.text;
      if (passText != "") {
        source = "assets/idea.png";
      } else {
        source = "assets/stop.png";
      }
      if (passText != "") {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Save Login Details?'),
            content: const Text(
                'Would you like to save your username and password for next time?'),
            actions: <Widget>[
              ElevatedButton(onPressed: okClicked, child: const Text("Ok")),
              ElevatedButton(
                  onPressed: cancelClicked, child: const Text("Cancel"))
            ],
          ),
        );
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Invalid Username/Password'),
            content: const Text(
                'Invalid value for username or password, please try again'),
            actions: <Widget>[
              ElevatedButton(onPressed: retry, child: const Text("Ok"))
            ],
          ),
        );
      }
    });
  }

  void okClicked() async {
    DataRepository.prefs.setString("username", loginController.value.text);
    DataRepository.prefs.setString("password", passController.value.text);
    Navigator.pop(context);
    Navigator.pushNamed(context, '/profile');
  }

  void cancelClicked() async {
    DataRepository.prefs.remove("username");
    DataRepository.prefs.remove("password");
    Navigator.pop(context);
  }

  void clearData() async {
    loginController.text = "";
    passController.text = "";
    DataRepository.prefs.remove("username");
    DataRepository.prefs.remove("password");
  }

  void retry() {
    setState(() {
      source = "assets/question-mark.png";
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    loginController = TextEditingController();
    passController = TextEditingController();

    DataRepository.prefs.getString("username").then((String value) {
      if (value != "") {
        loginController.text = value;
        DataRepository.userName = value;
        SnackBar snackBar = SnackBar(
            content: const Text("Welcome, previous login details loaded."),
            action: SnackBarAction(label: "Clear Data", onPressed: clearData));
        Future.delayed(const Duration(seconds: 1)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    });
    DataRepository.prefs.getString("password").then((String value) {
      if (value != "") {
        passController.text = value;
      }
    });
  }

  @override
  void dispose() {
    loginController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
                controller: loginController,
                decoration: const InputDecoration(
                    hintText: "Enter Username",
                    border: OutlineInputBorder(),
                    labelText: "Login")),
            TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: "Enter Password",
                    border: OutlineInputBorder(),
                    labelText: "Password")),
            ElevatedButton(onPressed: buttonClick, child: const Text("Login")),
            Image.asset(source, width: 300, height: 300),
          ],
        ),
      ),
    );
  }
}
