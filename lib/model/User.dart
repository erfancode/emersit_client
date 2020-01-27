
class User{

    final String name;
    final String username;
    final String imageUrl;
    final String role;
    final String token;


    User({this.name, this.username, this.imageUrl, this.role, this.token});

    factory User.fromJson(Map<String, dynamic> json) {
        return User(
            name: json['name'],
            username: json['username'],
            imageUrl: "",
            role: json['role'],
            token: json['token'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['username'] = this.username;
        data['name'] = this.name;
        data['role'] = this.role;
        data['token'] = this.token;
        return data;
    }
}