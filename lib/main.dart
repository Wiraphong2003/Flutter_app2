import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;
  final String img;

  User(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.address,
      required this.phone,
      required this.website,
      required this.company,
      required this.img});
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });
}

class Geo {
  final String lat;
  final String lng;

  Geo({required this.lat, required this.lng});

  static fromJson(json) {}
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({required this.name, required this.catchPhrase, required this.bs});
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('List User'),
//         ),
//         body: FutureBuilder<List<User>>(
//           future: fetchUsers(context),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData) {
//               return Text('No data available');
//             } else {
//               return ListView.builder(
//                 padding: EdgeInsets.all(16.0),
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   final user = snapshot.data![index];
//                   return Card(
//                     child: ListTile(
//                       leading:
//                           CircleAvatar(backgroundImage: NetworkImage(user.img)),
//                       title: Text(user.name),
//                       subtitle: Text(user.email),
//                       trailing: Icon(Icons.arrow_forward_ios),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => UserDetailPage(user: user),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<User>> _userList;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _userList = fetchUsers(context);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<User> _filterUsers(List<User> users, String query) {
    return users.where((user) {
      final id = user.id.toString(); // Convert id to a string for comparison
      final name = user.name.toLowerCase();
      final email = user.email.toLowerCase();
      final searchLower = query.toLowerCase();
      return id.contains(searchLower) ||
          name.contains(searchLower) ||
          email.contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('List User'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                onChanged: (query) {
                  setState(() {
                    // Update the user list based on the search query
                    _userList = fetchUsers(context).then((users) =>
                        _filterUsers(users, query)); // Filtering users
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<User>>(
                future: _userList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(), // แสดงวงกลมโหลด
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return Text('No data available');
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(15.0),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.img)),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailPage(user: user),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Future<List<User>> fetchUsers(BuildContext context) async {
//   final String jsonData =
//       await DefaultAssetBundle.of(context).loadString('dataS/user.json');
//   final List<dynamic> jsonList = json.decode(jsonData);

//   List<User> users = jsonList.map((json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//       username: json['username'],
//       email: json['email'],
//       address: Address(
//         street: json['address']['street'],
//         suite: json['address']['suite'],
//         city: json['address']['city'],
//         zipcode: json['address']['zipcode'],
//         geo: Geo(
//           lat: json['address']['geo']['lat'],
//           lng: json['address']['geo']['lng'],
//         ),
//       ),
//       phone: json['phone'],
//       website: json['website'],
//       company: Company(
//         name: json['company']['name'],
//         catchPhrase: json['company']['catchPhrase'],
//         bs: json['company']['bs'],
//       ),
//       img: json['img'],
//     );
//   }).toList();

//   return users;
// }

Future<List<User>> fetchUsers(BuildContext context) async {
  // final response = await http.get(Uri.parse('http://10.160.81.172:8080/users'));
  final response = await http
      .get(Uri.parse('https://jolly-cyan-bell-bottoms.cyclic.cloud/users'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);

    List<User> users = jsonList.map((json) {
      return User(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        address: Address(
          street: json['address']['street'],
          suite: json['address']['suite'],
          city: json['address']['city'],
          zipcode: json['address']['zipcode'],
          geo: Geo(
            lat: json['address']['geo']['lat'],
            lng: json['address']['geo']['lng'],
          ),
        ),
        phone: json['phone'],
        website: json['website'],
        company: Company(
          name: json['company']['name'],
          catchPhrase: json['company']['catchPhrase'],
          bs: json['company']['bs'],
        ),
        img: json['img'],
      );
    }).toList();

    return users;
  } else {
    throw Exception('Failed to load users');
  }
}

class UserDetailPage extends StatelessWidget {
  final User user;

  UserDetailPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // จัดวางในแนวนอน (X-axis) ให้อยู่กึ่งกลาง
              crossAxisAlignment: CrossAxisAlignment
                  .center, // จัดวางในแนวตั้ง (Y-axis) ให้อยู่กึ่งกลาง
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: Image.network(
                        user.img,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // จัดวางในแนวนอน (X-axis) ให้อยู่กึ่งกลาง
              crossAxisAlignment: CrossAxisAlignment
                  .center, // จัดวางในแนวตั้ง (Y-axis) ให้อยู่กึ่งกลาง
              children: [
                Text(
                  '${user.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Center(
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(1),
                    child: Container(
                      width: 355,
                      height: 170,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons
                                    .info, // สามารถเปลี่ยนไอคอนตามที่คุณต้องการ
                                // color: Color.fromARGB(255, 152, 0,0,), // เปลี่ยนสีไอคอนตามที่คุณต้องการ
                                color: Color(0xFFFF9800), // rgb(255, 152, 0)
                                size: 24, // เปลี่ยนขนาดไอคอนตามที่คุณต้องการ
                              ),
                              SizedBox(
                                  width:
                                      8), // เพิ่มระยะห่างระหว่างไอคอนกับข้อความ
                              Text(
                                "Information",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text('ID: ${user.id}',
                              style: TextStyle(fontSize: 16)),
                          Text('Username: ${user.username}',
                              style: TextStyle(fontSize: 16)),
                          Text('Email: ${user.email}',
                              style: TextStyle(fontSize: 16)),
                          Text('Phone: ${user.phone}',
                              style: TextStyle(fontSize: 16)),
                          Text('Website: ${user.website}',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Center(
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(1),
                    child: Container(
                      width: 355,
                      height: 120,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons
                                    .location_on, // สามารถเปลี่ยนไอคอนตามที่คุณต้องการ
                                color: Color(
                                    0xFFFF9800), // เปลี่ยนสีไอคอนตามที่คุณต้องการ
                                size: 24, // เปลี่ยนขนาดไอคอนตามที่คุณต้องการ
                              ),
                              SizedBox(
                                  width:
                                      8), // เพิ่มระยะห่างระหว่างไอคอนกับข้อความ
                              Text(
                                "Address",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text('Street: ${user.address.street}'),
                          Text('Suite: ${user.address.suite}'),
                          Text('City: ${user.address.city}'),
                          Text('Zipcode: ${user.address.zipcode}'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Center(
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(1),
                    child: Container(
                      width: 355,
                      height: 110,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons
                                    .work, // สามารถเปลี่ยนไอคอนตามที่คุณต้องการ
                                color: Color(
                                    0xFFFF9800), // เปลี่ยนสีไอคอนตามที่คุณต้องการ
                                size: 24, // เปลี่ยนขนาดไอคอนตามที่คุณต้องการ
                              ),
                              SizedBox(
                                  width:
                                      8), // เพิ่มระยะห่างระหว่างไอคอนกับข้อความ
                              Text(
                                "Company",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Text('Name: ${user.company.name}'),
                          // Text('Catch Phrase: ${user.company.catchPhrase}'),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Catch Phrase: ${user.company.catchPhrase}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text('Business: ${user.company.bs}'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

            // Text("Information",
            //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // Text('ID: ${user.id}'),
            // Text('Username: ${user.username}'),
            // Text('Email: ${user.email}'),
            // Text('Phone: ${user.phone}'),
            // Text('Website: ${user.website}'),
            // SizedBox(height: 16),

            // Text('Address:',
            //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // Text('Street: ${user.address.street}'),

            // Text('Suite: ${user.address.suite}'),
            // Text('City: ${user.address.city}'),
            // Text('Zipcode: ${user.address.zipcode}'),
            SizedBox(height: 16),
            // Text('Company:',
            //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // Text('Name: ${user.company.name}'),
            // // Text('Catch Phrase: ${user.company.catchPhrase}'),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: 'Catch Phrase: ${user.company.catchPhrase}',
            //         style: TextStyle(
            //           color: Colors.black,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Text('Business: ${user.company.bs}'),
          ],
        ),
      ),
    );
  }
}
