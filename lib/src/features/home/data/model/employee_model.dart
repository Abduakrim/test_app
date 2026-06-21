class EmployeeModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? maidenName;
  final int? age;
  final String? gender;
  final String? phone;
  final String? username;
  final String? birthDate;
  final String? image;
  final String? role;
  final CompanyModel? company;

  const EmployeeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.maidenName,
    this.age,
    this.gender,
    this.phone,
    this.username,
    this.birthDate,
    this.image,
    this.role,
    this.company,
  });

  String get fullName => '$firstName $lastName';
  String get avatarUrl => image ?? '';
  String get title => company?.title ?? 'Developer';
  String get department => company?.department ?? 'Engineering';
  bool get isActive => (id % 2 == 0);

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      maidenName: json['maidenName'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      phone: json['phone'] as String?,
      username: json['username'] as String?,
      birthDate: json['birthDate'] as String?,
      image: json['image'] as String?,
      role: json['role'] as String?,
      company: json['company'] != null
          ? CompanyModel.fromJson(json['company'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'maidenName': maidenName,
      'age': age,
      'gender': gender,
      'phone': phone,
      'username': username,
      'birthDate': birthDate,
      'image': image,
      'role': role,
      'company': company?.toJson(),
    };
  }
}

class CompanyModel {
  final String department;
  final String name;
  final String title;

  const CompanyModel({
    required this.department,
    required this.name,
    required this.title,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      department: json['department'] as String? ?? '',
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department': department,
      'name': name,
      'title': title,
    };
  }
}