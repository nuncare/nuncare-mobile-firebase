class Doctor {
  String? id;
  String firebaseId;
  String firstName;
  String lastName;
  String bio;
  String sex;
  String hospital;
  String speciality;
  String? otherSpeciality;
  String university;
  String countryUniversity;
  int years;
  String img;
  String phone;
  String district;
  String region;
  String city;
  String address;
  double lng;
  double lat;
  String email;
  String orderNumber;
  String promotion;
  String deviceId;
  bool isActive;
  bool isPhoneHidden;
  bool isOrderNumberHidden;
  String kycStatus;

  Doctor({
    this.id,
    required this.firebaseId,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.sex,
    required this.hospital,
    required this.speciality,
    this.otherSpeciality,
    required this.years,
    required this.img,
    required this.phone,
    required this.district,
    required this.region,
    required this.city,
    required this.address,
    required this.lat,
    required this.lng,
    required this.email,
    required this.orderNumber,
    required this.promotion,
    required this.isActive,
    required this.deviceId,
    required this.university,
    required this.countryUniversity,
    required this.isOrderNumberHidden,
    required this.isPhoneHidden,
    required this.kycStatus,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'],
      firebaseId: json['firebaseId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      bio: json['bio'] ?? '',
      sex: json['sex'] ?? '',
      hospital: json['hospital'] ?? '',
      speciality: json['speciality'],
      otherSpeciality: json['otherSpeciality'],
      university: json['university'],
      countryUniversity: json['countryUniversity'],
      years: json['years'] ?? 0,
      img: json['img'] ?? '',
      district: json['district'],
      phone: json['phone'],
      region: json['region'],
      city: json['city'],
      address: json['address'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      email: json['email'],
      orderNumber: json['orderNumber'],
      promotion: json['promotion'],
      isActive: json['isActive'],
      deviceId: json['deviceId'],
      isOrderNumberHidden: json['isOrderNumberHidden'],
      isPhoneHidden: json['isPhoneHidden'],
      kycStatus: json['kycStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'sex': sex,
      'hospital': hospital,
      'speciality': speciality,
      'otherSpeciality': otherSpeciality,
      'university': university,
      'countryUniversity': countryUniversity,
      'years': years,
      'img': img,
      'phone': phone,
      'region': region,
      'city': city,
      'address': address,
      'lat': lat,
      'lng': lng,
      'email': email,
      'orderNumber': orderNumber,
      'promotion': promotion,
      'isActive': isActive,
      "isPhoneHidden": isPhoneHidden,
      "isOrderNumberHidden": isOrderNumberHidden,
      "kycStatus": kycStatus,
    };
  }

  factory Doctor.defaultDoctor() {
    return Doctor(
      id: '',
      firebaseId: '',
      firstName: '',
      lastName: '',
      bio: '',
      sex: '',
      hospital: '',
      speciality: '',
      university: '',
      countryUniversity: '',
      years: 0,
      img: '',
      phone: '',
      district: '',
      region: '',
      city: '',
      address: '',
      lat: 0,
      lng: 0,
      email: '',
      orderNumber: '',
      isActive: true,
      deviceId: '',
      promotion: '',
      isOrderNumberHidden: false,
      isPhoneHidden: false,
      kycStatus: 'NOT_STARTED',
    );
  }
}
