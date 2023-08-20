import 'package:flutter/material.dart';
import 'dart:convert';

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
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({required this.name, required this.catchPhrase, required this.bs});
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('List User'),
        ),
        body: FutureBuilder<List<User>>(
          future: fetchUsers(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No data available');
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      leading:
                          CircleAvatar(backgroundImage: NetworkImage(user.img)),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailPage(user: user),
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
    );
  }
}

Future<List<User>> fetchUsers(BuildContext context) async {
  final String jsonData =
      await DefaultAssetBundle.of(context).loadString('dataS/user.json');
  final List<dynamic> jsonList = json.decode(jsonData);

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
}

class UserDetailPage extends StatelessWidget {
  final User user;

  UserDetailPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Detail'),
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
              height: 10,
            ),
            Text("Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('ID: ${user.id}'),
            Text('Username: ${user.username}'),
            Text('Email: ${user.email}'),
            Text('Phone: ${user.phone}'),
            Text('Website: ${user.website}'),
            SizedBox(height: 16),
            Text('Address:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Street: ${user.address.street}'),
            Text('Street: ${user.address.street}'),
            Text('Suite: ${user.address.suite}'),
            Text('City: ${user.address.city}'),
            Text('Zipcode: ${user.address.zipcode}'),
            SizedBox(height: 16),
            Text('Company:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Name: ${user.company.name}'),
            Text('Catch Phrase: ${user.company.catchPhrase}'),
            Text('Business: ${user.company.bs}'),
          ],
        ),
      ),
    );
  }
}
