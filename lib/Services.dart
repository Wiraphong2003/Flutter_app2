// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<List<User>> fetchUsersFromApi() async {
//   final response = await http.get(Uri.parse('http://localhost:8080/users'));

//   if (response.statusCode == 200) {
//     final List<dynamic> jsonData = json.decode(response.body);
//     return jsonData.map((json) => User.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load users');
//   }
// }
// class Address {
//   // ... other fields and constructors ...

//   factory Address.fromJson(Map<String, dynamic> json) {
//     return Address(
//       street: json['street'],
//       suite: json['suite'],
//       city: json['city'],
//       zipcode: json['zipcode'],
//       geo: Geo.fromJson(json['geo']),
//     );
//   }
// }

// class Company {
//   // ... other fields and constructors ...

//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       name: json['name'],
//       catchPhrase: json['catchPhrase'],
//       bs: json['bs'],
//     );
//   }
// }
