import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:parknson_admin/view/home_screen.dart';

import '../model/user_model.dart';
import '../shared/utils.dart';
import '../view/LayoutResponsive.dart';

enum ApiStatus{
  initial,
  loading,
  success,
  failure
}

class LoginController extends GetxController{

  final _firebaseFireStore=FirebaseFirestore.instance;
  final _firebaseAuth=FirebaseAuth.instance;
  final isLoading=RxBool(false);
  // final _userModel=Rxn<UserModel>();
  // final allUsers=RxList<UserModel>([]);
  // final allCompany=RxList<UserModel>([]);
  final _userModel=Rxn<UserModel>();

  final loginStatus=Rx<ApiStatus>(ApiStatus.loading);




  Future<void> adminLogin({required String email,required String password})async{
    loginStatus(ApiStatus.loading);
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value)async{
        if(value.user?.uid!=null){
          await getUserData(uid: value.user!.uid);
          if(_userModel.value!=null){

            if (_userModel.value?.userType == 'admin') {
              Get.offAll(() => const HomeScreen());
              Utils.myToast(title: 'Login Success');
            }else{
              Utils.myToast(title: 'Login Failed!');
            }

          }
        }
        else{
          isLoading(false);
          // Utils.myToast(title: 'Login Failed!');

        }

      }).catchError((error){
        print('there is an error in login ${error.toString()}');
        // Utils.myToast(title: error.toString());

      });
    }catch(error){
      isLoading(false);
      // Utils.myToast(title: error.toString());
    }
  }

  Future<void> getUserData({required String uid}) async {
    try {
      final result =
      await _firebaseFireStore.collection('users').doc(uid).get();
      if (result.data() != null) {
        _userModel(UserModel.fromJson(result.data()!));
      } else {
        _userModel(null);
        Utils.myToast(title: 'Please Check your network!');
      }
    } catch (e) {
      print('there is an error in get user Data $e');
    }
  }


  final getAllUsersStatus=Rx<ApiStatus>(ApiStatus.initial);
  final _allUser=RxList<UserModel>([]);
  final _allDoctors=RxList<UserModel>([]);
  final _allAppointments=RxList<AppointmentModel>([]);

  Future<void> getAllUsers()async{
    try{
      _allDoctors.clear();
      _allUser.clear();
      _allAppointments.clear();

      getAllUsersStatus(ApiStatus.loading);

      final result=await _firebaseFireStore.collection('users').get();
      if(result.docs.isNotEmpty){
        final allUsers=result.docs.map((e) => UserModel.fromJson(e.data())).toList();
        for(final i in allUsers){
          if(i.userType=='user'){
            _allUser.add(i);
          }
          else if(i.userType=='doctor'){
            _allDoctors.add(i);
          }

        }

      }
      
      final result2=await _firebaseFireStore.collection('appointments').get();
      if(result2.docs.isNotEmpty){
        final allAppointments=result2.docs.map((e) => AppointmentModel.fromJson(e.data())).toList();
        _allAppointments.addAll(allAppointments);
      }
      
      getAllUsersStatus(ApiStatus.success);

      Utils.printLog('SSSS${_allUser.length}');


    }catch(error){
      Utils.printLog('Error When Get All Users ${error.toString()}');
      getAllUsersStatus(ApiStatus.failure);

    }
  }


  final createAccountStatus = Rx<ApiStatus>(ApiStatus.initial);

  Future<void> createAccount({
    required String email,
    required String name,
    required String password,
    required String phoneNumber,
    required String gender,
    required final num rate,
    required final String major,
    required final String image
  }) async {
    try {
      createAccountStatus(ApiStatus.loading);
      final auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (auth.user != null) {
        await saveDataToFireStore(
          email: email,
          name: name,
          imageUrl: image,
          phone: phoneNumber,
          uid: auth.user!.uid,
          gender: gender,
          rate: rate,
          major: major,
        );
        Get.offAll(()=> HomeScreen());
        createAccountStatus(ApiStatus.success);

      } else {
        Utils.myToast(title: 'There is an error');
        createAccountStatus(ApiStatus.failure);

      }
    } catch (e) {
      print('there is an error $e');
      Utils.myToast(title: 'There is an error ${e.toString()}');
      createAccountStatus(ApiStatus.failure);



    }
  }

  Future<void> saveDataToFireStore({
    required String email,
    required String name,
    required String phone,
    required String uid,
    required String gender,
    required final String imageUrl,
    required final num rate,
    required final String major,

  }) async {
    try {
      await _firebaseFireStore.collection('users').doc(uid).set({
        'email': email,
        'user_name': name,
        'mobile_number': phone,
        'image_url':imageUrl,
        'major':major,
        'uid': uid,
        'rate':rate,
        'profile_image': imageUrl,
        'user_type':'doctor'
      });
    } catch (e) {
      Utils.printLog('There is an error in saveDataToFireStore method  ${e.toString()}');
    }
  }




  List<UserModel> get allUsers=>_allUser;
  List<UserModel> get allDoctors=>_allDoctors;
  List<AppointmentModel> get allAppointments=>_allAppointments;




}