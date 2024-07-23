import 'dart:io';
import 'package:app/filterpost.dart';
import 'package:dio/dio.dart';

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
          print("losttttttttttttttttttttt");
          print(e.response?.data);
          return handler.next(e); // Continue with the error
        },
      ),
    );
  }
}

class Post {
  Dio dio = Dio();
  int? id;
  bool isusedChange;
  String categoryChange;
  double priceChange;
  File? imageFile;
  String brandChange;
  double capacityChange;
  String unitChange;
  double? voltChange;
  String locationChange;
  String? phone;
  String photo = "http://solareasegp.runasp.net/ProfileImages/profile.png";
  String cityChange;
  String descriptionChange;
  String? ownerPhoto =
      "http://solareasegp.runasp.net/ProfileImages/profile.png";
  String? date;
  String? ownerName;
  Post(
      {required this.brandChange,
      required this.capacityChange,
      required this.categoryChange,
      required this.cityChange,
      required this.descriptionChange,
      required this.imageFile,
      required this.isusedChange,
      required this.locationChange,
      required this.priceChange,
      required this.unitChange,
      required this.voltChange});
}

/************************************************************************* */
Future<String> getPoststoFilter(List<Post> posts) async {
  ApiService a = ApiService(); //lock authurization for now
  posts.clear();

  try {
    var response = await a._dio
        .get("http://solareasegp.runasp.net/api/Posts/InActive?sortBy=a");
    print(response);
    for (var p in response.data) {
      Post temp = Post(
          brandChange: '',
          capacityChange: 0,
          categoryChange: '',
          cityChange: '',
          descriptionChange: '',
          imageFile: null,
          isusedChange: true,
          locationChange: '',
          priceChange: 0,
          unitChange: '',
          voltChange: 0);
      temp.id = p['id'];
      temp.isusedChange = p["isUsed"];

      temp.categoryChange = p["categoryName"];

      temp.priceChange = p["price"].toDouble();

      temp.brandChange = p["brand"];

      temp.capacityChange = p["capacity"].toDouble();
      temp.unitChange = p["measuringUnit"];

      if (temp.categoryChange == "Battery")
        temp.voltChange = p["volt"].toDouble();
      temp.locationChange = p["location"];
      temp.phone = p["phoneNumber"];
      temp.ownerPhoto = "http://solareasegp.runasp.net/" + p["profileImageUrl"];
      temp.date = p["createdOn"];
      temp.ownerName = p["personName"];
      temp.photo = "http://solareasegp.runasp.net/" + p["productImageUrl"];

      temp.cityChange = p["city"];
      if (p["description"] != null) temp.descriptionChange = p["description"];
      posts.add(temp);
    }
    print("ok*****************");
    return "Ok";
  } catch (e) {
    print(e);
    return "Oops! Something went wrong.";
  }
}

/**************************************************************************** */
// api for reject post
Future<String> rejectPost(int id) async {
  ApiService a = ApiService(); //lock authurization for now
  Dio dio = Dio();
  try {
    var response = await a._dio
        .delete("http://solareasegp.runasp.net/api/Posts/RejectPost/$id");
    print("rejected******************************");
    return "Ok";
  } catch (e) {
    print(e);
    return "Oops! Something went wrong.";
  }
}

// api for accept post
Future<String> acceptPost(int id) async {
  ApiService a = ApiService(); //lock authurization for now
  Dio dio = Dio();
  try {
    var response = await a._dio
        .put("http://solareasegp.runasp.net/api/Posts/ApprovePost/$id");
    print("Accept******************************");
    return "Ok";
  } catch (e) {
    print(e);
    return "Oops! Something went wrong.";
  }
}
