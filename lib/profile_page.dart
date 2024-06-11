import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab02/data_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late TextEditingController firstController;
  late TextEditingController lastController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  void callPressed() {
    canLaunch("tel:1234567890").then((itCan) {
      if (itCan) {
        launch("tel:1234567890");
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Error: App not found"),
                content: Text("You do not have a phone dialer installed."),
              );
            });
      }
    });
  }

  void smsPressed() {
    canLaunch("sms:1234567890").then((itCan) {
      if (itCan) {
        launch("sms:1234567890");
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Error: App not found"),
                content: Text("You do not have an SMS app installed."),
              );
            });
      }
    });
  }

  void mailPressed() {
    canLaunch("mailto:blai0327@algonquinlive.com").then((itCan) {
      if (itCan) {
        launch("mailto:blai0327@algonquinlive.com");
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Error: App not found"),
                content: Text("You do not have a Mail app installed."),
              );
            });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    firstController = TextEditingController();
    lastController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();

    SnackBar snackBar = SnackBar(
        content: Text(
            "Welcome ${DataRepository.userName}, thank you for logging in."));
    Future.delayed(const Duration(seconds: 1)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    DataRepository.loadData();
    firstController.text = DataRepository.firstName;
    lastController.text = DataRepository.lastName;
    phoneController.text = DataRepository.phone;
    emailController.text = DataRepository.email;
  }

  @override
  void dispose() {
    DataRepository.firstName = firstController.value.text;
    DataRepository.lastName = lastController.value.text;
    DataRepository.phone = phoneController.value.text;
    DataRepository.email = emailController.value.text;
    DataRepository.saveData();
    firstController.dispose();
    lastController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text("My Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 1.035,
              child: TextField(
                controller: firstController,
                decoration: const InputDecoration(
                    hintText: "Enter First Name",
                    border: OutlineInputBorder(),
                    labelText: "First Name"),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 1.035,
              child: TextField(
                  controller: lastController,
                  decoration: const InputDecoration(
                      hintText: "Enter Last Name",
                      border: OutlineInputBorder(),
                      labelText: "Last Name")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.25,
                    child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                            hintText: "Enter Phone Number",
                            border: OutlineInputBorder(),
                            labelText: "Phone Number"))),
                ElevatedButton(
                    onPressed: callPressed, child: const Icon(Icons.phone)),
                ElevatedButton(
                    onPressed: smsPressed, child: const Icon(Icons.sms)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.14,
                    child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            hintText: "Enter Email",
                            border: OutlineInputBorder(),
                            labelText: "Email"))),
                ElevatedButton(
                    onPressed: mailPressed, child: const Icon(Icons.mail)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
