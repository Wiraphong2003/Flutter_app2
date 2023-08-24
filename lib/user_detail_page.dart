import 'package:flutter/material.dart';

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
            Text('ID: ${user.id}'),
            Text('Name: ${user.name}'),
            Text('Username: ${user.username}'),
            Text('Email: ${user.email}'),
            Text('Phone: ${user.phone}'),
            Text('Website: ${user.website}'),
            SizedBox(height: 16),
            Text('Address:'),
            Text('Street: ${user.address.street}'),
            Text('Suite: ${user.address.suite}'),
            Text('City: ${user.address.city}'),
            Text('Zipcode: ${user.address.zipcode}'),
            SizedBox(height: 16),
            Text('Company:'),
            Text('Name: ${user.company.name}'),
            Text('Catch Phrase: ${user.company.catchPhrase}'),
            Text('Business: ${user.company.bs}'),
            SizedBox(height: 16),
            Image.network(
              user.img,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Text('Error loading image');
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
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
