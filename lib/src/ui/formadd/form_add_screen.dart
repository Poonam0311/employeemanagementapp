import 'package:flutter/material.dart';
import 'package:employeemanagementapp/src/api/api_service.dart';
import 'package:employeemanagementapp/src/model/profile.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Profile profile;

  FormAddScreen({this.profile});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class Department {
  const Department(this.name, this.id);
  final String name;
  final int id;
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldFirstNameValid;
  bool _isFieldLastNameValid;
  bool _isFieldDesignationValid;
  bool _isFieldDepartmentValid;
  bool _isFieldDateOfBirthValid;
  bool _isFieldDateOfJoiningValid;
  bool _isFieldEmailValid;
  bool _isFieldContactValid;

  TextEditingController _controllerFirstName = TextEditingController();
  TextEditingController _controllerLastName = TextEditingController();
  TextEditingController _controllerDesignation = TextEditingController();
  TextEditingController _controllerDepartment = TextEditingController();
  TextEditingController _controllerDateOfBirth = TextEditingController();
  TextEditingController _controllerDateOfJoining = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerContact = TextEditingController();
  List<Department> depts = [
    const Department('Advertisement', 1),
    const Department('Engineering', 2),
    const Department('Accounts', 3)
  ];
  Department selectedDepartment;

  @override
  void initState() {
    if (widget.profile != null) {
      _isFieldDepartmentValid = true;
      _isFieldDateOfBirthValid = true;
      _isFieldDateOfJoiningValid = true;
      _isFieldDesignationValid = true;
      _isFieldFirstNameValid = true;
      _isFieldLastNameValid = true;
      _controllerFirstName.text = widget.profile.first_name;
      _controllerLastName.text = widget.profile.last_name;
      _controllerDesignation.text = widget.profile.designation;
      print(widget.profile);
      selectedDepartment = depts
          .where((element) => element.name == widget.profile.department)
          .first;
      _controllerDateOfBirth.text = widget.profile.dob;
      _controllerDateOfJoining.text = widget.profile.date_of_joining;
      _isFieldEmailValid = true;
      _controllerEmail.text = widget.profile.email;
      _isFieldContactValid = true;
      _controllerContact.text = widget.profile.contact_number.toString();
    } else {
      setState(() {
        selectedDepartment = depts.first;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.profile == null ? "Form Add" : "Change Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldFirstName(),
                _buildTextFieldLastName(),
                _buildTextFieldEmail(),
                _buildTextFieldContact(),
                _buildTextFieldDesignation(),
                _buildTextFieldDepartment(),
                _buildTextFieldDateOfBirth(),
                _buildTextFieldDateOfJoining(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.profile == null
                          ? "Submit".toUpperCase()
                          : "Update Data".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_isFieldDateOfBirthValid == null ||
                          !_isFieldDateOfBirthValid ||
                          _isFieldDateOfJoiningValid == null ||
                          !_isFieldDateOfJoiningValid ||
                          _isFieldDesignationValid == null ||
                          !_isFieldDesignationValid ||
                          _isFieldLastNameValid == null ||
                          !_isFieldLastNameValid ||
                          _isFieldFirstNameValid == null ||
                          _isFieldEmailValid == null ||
                          _isFieldContactValid == null ||
                          !_isFieldFirstNameValid ||
                          !_isFieldEmailValid ||
                          !_isFieldContactValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Please fill all fields"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String first_name = _controllerFirstName.text.toString();
                      String last_name = _controllerLastName.text.toString();
                      String designation =
                          _controllerDesignation.text.toString();
                      String department = selectedDepartment.id.toString();
                      String dob = _controllerDateOfBirth.text.toString();
                      String date_of_joining =
                          _controllerDateOfJoining.text.toString();
                      String email = _controllerEmail.text.toString();
                      int contact_number =
                          int.parse(_controllerContact.text.toString());
                      Profile profile = Profile(
                          id: 0,
                          first_name: first_name,
                          last_name: last_name,
                          designation: designation,
                          department: department,
                          email: email,
                          contact_number: contact_number,
                          dob: dob,
                          date_of_joining: date_of_joining);
                      if (widget.profile == null) {
                        print(profile);
                        _apiService.createProfile(profile).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(
                                _scaffoldState.currentState.context, true);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Submit data failed"),
                            ));
                          }
                        });
                      } else {
                        profile.id = widget.profile.id;
                        _apiService.updateProfile(profile).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(
                                _scaffoldState.currentState.context, true);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Update data failed"),
                            ));
                          }
                        });
                      }
                    },
                    color: Colors.orange[600],
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldFirstName() {
    return TextField(
      controller: _controllerFirstName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "First name",
        errorText: _isFieldFirstNameValid == null || _isFieldFirstNameValid
            ? null
            : "First name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldFirstNameValid) {
          setState(() => _isFieldFirstNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldLastName() {
    return TextField(
      controller: _controllerLastName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Last name",
        errorText: _isFieldLastNameValid == null || _isFieldLastNameValid
            ? null
            : "Last name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldLastNameValid) {
          setState(() => _isFieldLastNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldDesignation() {
    return TextField(
      controller: _controllerDesignation,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Designation",
        errorText: _isFieldDesignationValid == null || _isFieldDesignationValid
            ? null
            : "Designation is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldDesignationValid) {
          setState(() => _isFieldDesignationValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldDepartment() {
    return DropdownButton(
      value: (selectedDepartment != null) ? selectedDepartment : depts.first,
      items: depts.map((Department d) {
        return DropdownMenuItem(
          value: d,
          child: Row(
            children: [
              Text(
                d.name,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedDepartment = value;
        });
      },
    );
    // return TextField(
    //   controller: _controllerDepartment,
    //   keyboardType: TextInputType.text,
    //   decoration: InputDecoration(
    //     labelText: "Department",
    //     errorText: _isFieldDepartmentValid == null || _isFieldDepartmentValid
    //         ? null
    //         : "Department is required",
    //   ),
    //   onChanged: (value) {
    //     bool isFieldValid = value.trim().isNotEmpty;
    //     if (isFieldValid != _isFieldDepartmentValid) {
    //       setState(() => _isFieldDepartmentValid = isFieldValid);
    //     }
    //   },
    // );
  }

  Widget _buildTextFieldDateOfBirth() {
    return TextField(
      controller: _controllerDateOfBirth,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Date of Birth(YYYY-MM_DD)",
        errorText: _isFieldDateOfBirthValid == null || _isFieldDateOfBirthValid
            ? null
            : "Enter valid Date of Birth",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (_dateValidator(value) != null) {
          isFieldValid = false;
        }
        if (isFieldValid != _isFieldDateOfBirthValid) {
          setState(() => _isFieldDateOfBirthValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldDateOfJoining() {
    return TextField(
      controller: _controllerDateOfJoining,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Date of Joining(YYYY-MM_DD)",
        errorText:
            _isFieldDateOfJoiningValid == null || _isFieldDateOfJoiningValid
                ? null
                : "Enter valid Date of Joining",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (_dateValidator(value) != null) {
          isFieldValid = false;
        }
        if (isFieldValid != _isFieldDateOfJoiningValid) {
          setState(() => _isFieldDateOfJoiningValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Enter valid Email",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (_emailValidator(value) != null) {
          isFieldValid = false;
        }
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldContact() {
    return TextField(
      controller: _controllerContact,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Contact Number",
        errorText: _isFieldContactValid == null || _isFieldContactValid
            ? null
            : "Enter valid Contact Number",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (_phoneNumberValidator(value) != null) {
          isFieldValid = false;
        }
        if (isFieldValid != _isFieldContactValid) {
          setState(() => _isFieldContactValid = isFieldValid);
        }
      },
    );
  }

  String _phoneNumberValidator(String value) {
    Pattern pattern = r'/^^(?:[+0]9)?[0-9]{10}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Phone Number';
    else
      return null;
  }

  String _emailValidator(String value) {
    Pattern pattern = r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Phone Number';
    else
      return null;
  }

  String _dateValidator(String value) {
    Pattern pattern = r"^\d{4}-\d{2}-\d{2}$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Phone Number';
    else
      return null;
  }
}
