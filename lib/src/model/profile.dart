import 'dart:convert';

class Profile {
  int id;
  String first_name;
  String last_name;
  String designation;
  String department;
  String email;
  int contact_number;
  String dob;
  String date_of_joining;

  Profile(
      {this.id = 0,
      this.first_name,
      this.last_name,
      this.designation,
      this.department,
      this.email,
      this.contact_number,
      this.dob,
      this.date_of_joining});

  factory Profile.fromJson(map) {
    return Profile(
        id: map["id"],
        first_name: map["first_name"],
        last_name: map["last_name"],
        designation: map["designation"],
        department: map["department"],
        email: map["email"],
        contact_number: map["contact_number"],
        dob: map['dob'],
        date_of_joining: map['date_of_joining']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": first_name,
      "last_name": last_name,
      "designation": designation,
      "department": department,
      "email": email,
      "contact_number": contact_number,
      "dob": dob,
      "date_of_joining": date_of_joining
    };
  }

  @override
  String toString() {
    return 'Profile{id: $id,first_name: $first_name,last_name: $last_name,designation: $designation,department: $department,email: $email,contact_number: $contact_number,dob: $dob,date_of_joining: $date_of_joining}';
  }
}

List<Profile> profileFromJson(jsonData) {
  final data = json.decode(jsonData);
  return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
}

String profileToJson(Profile data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
