import 'package:employeemanagementapp/src/model/profile.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://127.0.0.1:4001";
  Client client = Client();

  Future<List<Profile>> getProfiles() async {
    final response = await client.get("$baseUrl/api/v1/employees");
    print(response);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> createProfile(Profile data) async {
    final response = await client.post(
      "$baseUrl/api/v1/employees/add",
      headers: {"content-type": "application/json"},
      body: profileToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfile(Profile data) async {
    final response = await client.post(
      "$baseUrl/api/v1/employees/edit",
      headers: {"content-type": "application/json"},
      body: profileToJson(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProfile(int id) async {
    final response = await client.post(
      "$baseUrl/api/v1/employees/delete",
      headers: {"content-type": "application/json"},
      body: json.encode({"id": id}),
    );
    print(response);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
