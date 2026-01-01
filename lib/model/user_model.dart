class UserModel{
  final String ?email;
  final String ?imageUrl;
  final String ?mobileNumber;
  final String ?profileImage;
  final String ?uid;
  final String ?userName;
  final String ?userType;


  UserModel({
    this.email,
    this.imageUrl,
    this.mobileNumber,
    this.profileImage,
    this.uid,
    this.userName,
    this.userType
});


  factory UserModel.fromJson(final Map<String,dynamic> json){
    return UserModel(
      email: json['email'],
      imageUrl: json['image_url'],
      mobileNumber: json['mobile_number'],
      profileImage: json['profile_image'],
      uid: json['uid'],
      userName: json['user_name'],
      userType: json['user_type']
    );
  }

}

class AppointmentModel{
  final String ?contactNumber;
  final String ?patientName;
  final String ?patientUid;
  final String ?status;
  final String ?time;


  AppointmentModel({
    this.contactNumber,
    this.patientName,
    this.patientUid,
    this.status,
    this.time
});


  factory AppointmentModel.fromJson(final Map<String,dynamic> json){
    return AppointmentModel(
      contactNumber: json['contact_number'],
      patientName: json['patient_name'],
      patientUid: json['patient_uid'],
      status: json['status'],
      time: json['time']
    );
  }


}