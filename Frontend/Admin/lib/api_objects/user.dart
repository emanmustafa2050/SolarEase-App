import 'dart:io';
import 'package:app/filterpost.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    String _token = user.useKey!;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options); // Continue with the request
        },
        onError: (DioError e, handler) {
          // Handle errors globally
          print(e.response?.data);
          return handler.next(e); // Continue with the error
        },
      ),
    );
  }
}

class User {
  Dio dio = Dio();
  String username;
  String password;
  String email;
  String city;
  String location;
  String phoneNumber;
  String? useKey;
  int? id;
  //String image = "http://solareasegp.runasp.net/ProfileImages/profile.png";

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.location,
    required this.phoneNumber,
    required this.city,
  });
  bool isempty() {
    if (this.username != "" &&
        this.password != "" &&
        this.email != "" &&
        this.location != "" &&
        this.phoneNumber != "" &&
        this.city != "")
      return false;
    else
      return true;
  }

  Map<String, dynamic> tojsonLogin() {
    return {
      "email": this.email,
      "password": this.password,
    };
  }

  //api for login
  Future<String> checkuser() async {
    try {
      print(this.password);
      print(this.email);
      var response = await dio.post(
          "http://solareasegp.runasp.net/api/AuthAdmins/Login",
          data: tojsonLogin());
      this.username = response.data["name"];
      this.location = response.data["location"];
      this.phoneNumber = response.data["phoneNumber"];
      this.city = response.data["city"];
      this.useKey = response.data["jwtToken"];
      this.id = response.data["id"];

      return "Ok";
    } on DioException catch (e) {
      print(e.response);
      if (e.response?.statusCode == 400) {
        return e.response?.data['errors'].values.first[0];
      } else {
        return e.response.toString();
      }
    }
  }
}
