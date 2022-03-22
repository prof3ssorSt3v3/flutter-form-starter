import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Form'),
        ),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  //controller for first text field
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  //we can access myController.text inside functions
  //State variables for form field values
  String? _name;
  String? _email;

  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // usernameController.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    // print('Username text field: ${usernameController.text}');
  }

  void showValues(BuildContext context) {
    print('Name:' + usernameController.text);
    print('Email:' + emailController.text);
  }

  void _tellUser(String message, Color colour) {
    Text msg = Text(
      message,
      style:
          TextStyle(color: colour, fontSize: 24, fontWeight: FontWeight.w500),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: msg),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      //let's us check currentState and call validate
      // autovalidateMode: AutovalidateMode.always,
      onChanged: () {
        //when any field in the form changes
        // print('calling onChanged() on form');
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildUsername(),
            _buildEmail(),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  //triggers all the validator: (){}
                  _tellUser('You are validated. Feels good 🤩', Colors.green);
                  // If the form is valid, display a snackbar. In the real world,

                  //validation has been passed so we can save the form
                  _formKey.currentState!.save();
                  //triggers the onSave in each form field

                  //now create your object to send to the server
                  Map<String, dynamic> userData = {
                    'name': _name,
                    'email': _email
                  };
                  //call a function to post the data
                } else {
                  //form failed validation so exit
                  _tellUser('Try again. Such sad. 😞', Colors.red);
                  return;
                }
              },
              child: const Text('Submit', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _styleField(String label, String hint, IconData? icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
      border: UnderlineInputBorder(),
      icon: icon == null ? Container(width: 0) : Icon(icon),
      // prefixIcon: Icon(Icons.verified_user),
      // prefixIcon is inside the text field
      // suffixIcon: IconButton(
      // icon: Icon(Icons.visibility),
      // onPressed: () {
      //could be used to toggle the visibility
      //password reveal
      // },
      // ),
    );
  }

  TextFormField _buildUsername() {
    return TextFormField(
      decoration:
          _styleField('Username', 'Pick a Username', Icons.verified_user),
      controller: usernameController,
      obscureText: false, //for passwords set to true
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      validator: (String? value) {
        print('called validator in username');
        if (value == null || value.isEmpty || value.characters.length < 6) {
          return 'too short';
        }
        return null; //all good if null
      },
      onChanged: (String? value) {
        print('Username onChanged $value');
      },
      onSaved: (String? value) {
        print('username onSaved triggered');
        setState(() {
          _name = value;
        });
      },
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
        decoration:
            _styleField('Email', 'Guess what you write here', Icons.email),
        controller: emailController,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.lightBlue, fontSize: 20),
        //textFormField has a validator
        //it gets called onChange and onSubmit
        validator: (String? value) {
          print('called validator in email');
          if (value == null || value.isEmpty) {
            return 'Please enter something';
            //becomes the new errorText value
          }
          if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return 'Please enter a valid email Address';
          }
          return null; //means all is good
        },
        onSaved: (String? value) {
          //save the email value in the state variable
          print('email onSaved triggered.');
          //wrap in setState() if we need to trigger something
          setState(() {
            _email = value;
          });
        },
        onChanged: (String? value) {
          print('called onChanged in email.');
        });
  }
}
