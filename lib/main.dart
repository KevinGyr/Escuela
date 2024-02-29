import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late Database _db;

@override
void initState() {
  super.initState();

  initDB();
}

void initDB() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'login_database.db'),
      onCreate: (db, version){
      return db.execute(
        "CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT)",
      );
    },
    version: 1,
    );
    checkAndInsertData();
}

Future<void> checkAndInsertData() async {
  //
  final count = 
    Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM users'));
  if (count == 0){
    await _db.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO users(id,username,password) VALUES(?,?,?)',
        [1, 'John', '12345']);
      await txn.rawInsert(
        'INSERT INTO users(id,username,password) VALUES(?,?,?)',
        [2, 'Alice', '12345']);
      await txn.rawInsert(
        'INSERT INTO users(id,username,password) VALUES(?,?,?)',
        [3, 'Kevin', '25072']);
      });
    }
  }

  Future<void> _login() async {
    final List<Map<String, dynamic>> users = await _db.query('users',
    where: 'username = ? AND password = ?',
    whereArgs: [_usernameController.text, _passwordController.text]);

  }
  

  @override
  
  Widget build(BuildContext context) {

    Future<void> _login() async {
      final List<Map<String, dynamic>> users = await _db.query('users',
          where: 'username = ? AND password = ?',
          whereArgs: [_usernameController.text, _passwordController.text]);

      if (users.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

      } else {
        showDialog(
          context: context as BuildContext,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Invalid username or password.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    
                  },
                ),
              ],
            );
          },
        );
      }

    }// than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
  );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome!'),
       ),
    );
  }
}