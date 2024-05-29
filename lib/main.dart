import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lab 02 Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController loginController;
  late TextEditingController passController;
  var passText = "";
  var source = "assets/question-mark.png";
  EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  void buttonClick() {
    setState(() {
      passText = passController.value.text;
      if(passText == "QWERTY123") {
        source = "assets/idea.png";
      } else {
        source = "assets/stop.png";
      }
      showDialog<String>(
        context: context,
        builder: (BuildContext context) =>  AlertDialog(
          title: const Text('Save Login Details?'),
          content: const Text('Would you like to save your username and password for next time?'),
          actions: <Widget>[
            ElevatedButton(onPressed: okClicked, child: const Text("Ok")),
            ElevatedButton(onPressed: cancelClicked, child: const Text("Cancel"))
          ],
        ),
      );
    });
  }

  void okClicked() async {
      prefs.setString("username", loginController.value.text);
      prefs.setString("password", passController.value.text);
      Navigator.pop(context);
  }

  void cancelClicked() async {
      prefs.remove("username");
      prefs.remove("password");
      Navigator.pop(context);
  }

  void clearData() async {
    loginController.text = "";
    passController.text = "";
    prefs.remove("username");
    prefs.remove("password");
  }

  @override
  void initState() {
    super.initState();
    loginController = TextEditingController();
    passController = TextEditingController();
    prefs.getString("username").then((String value) {
      if(value != "") {
        loginController.text = value;
        SnackBar snackBar = SnackBar(
            content: Text("Welcome $value, previous login details loaded."),
            action: SnackBarAction(label: "Clear Data", onPressed: clearData));
        Future.delayed(const Duration(seconds: 1)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    });
    prefs.getString("password").then((String value) {
      if(value != "") {
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(controller: loginController,
                decoration: const InputDecoration(
                    hintText:"Enter Username",
                    border: OutlineInputBorder(),
                    labelText: "Login"
                )),
            TextField(controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText:"Enter Password",
                    border: OutlineInputBorder(),
                    labelText: "Password"
                )),
            ElevatedButton(onPressed: buttonClick, child: const Text("Login")),
            Image.asset(source, width: 300, height: 300),
          ],
        ),
      ),
    );
  }
}
