

class User {
  int UserID;
  String UserName;
  String UserLastname;
  String UserEmail;
  String UserPassword;
  String UserImageURL;

  User({
    required this.UserID,
    required this.UserName,
    required this.UserEmail,
    required this.UserPassword,
    required this.UserImageURL,
    required this.UserLastname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userId = json['UserID'];
    if(userId == null){
      return User(
        UserID: 0,
        UserName: "",
        UserEmail: "",
        UserPassword: "",
        UserImageURL: "",
        UserLastname: "",
      );
    }else{
      return User(
        UserID: json['UserID'],
        UserName: json['UserName'],
        UserEmail: json['UserEmail'],
        UserPassword: json['UserPassword'],
        UserImageURL: json['UserImageURL'],
        UserLastname: json['UserLastname'],
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'userID': UserID,
    'userName': UserName,
    'userEmail': UserEmail,
    'userPassword': UserPassword,
    'userImageURL': UserImageURL,
    'userLastname': UserLastname,
  };
}