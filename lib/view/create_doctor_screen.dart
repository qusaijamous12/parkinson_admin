import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parknson_admin/controller/login_controller.dart';
import 'package:parknson_admin/shared/color_manager.dart';

class CreateDoctorScreen extends StatefulWidget {
  const CreateDoctorScreen({super.key});

  @override
  State<CreateDoctorScreen> createState() => _CreateDoctorScreenState();
}

class _CreateDoctorScreenState extends State<CreateDoctorScreen> {
  final _loginController = Get.find<LoginController>(tag: 'login_controller');
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController profileImageController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController uidController = TextEditingController();

  double rate = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: ColorManager.kPrimary,
        elevation: 0,
        title: const Text(
          'Create Doctor Account',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          _buildForm(context),

          /// 🔹 Modern Loader Overlay
          Obx(() {
            if (_loginController.createAccountStatus.value == ApiStatus.loading) {
              return _modernLoader();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _profilePreview(),
            const SizedBox(height: 24),

            _formCard(
              child: Column(
                children: [
                  _inputField(
                    controller: userNameController,
                    label: 'Doctor Name',
                    icon: Icons.person_outline,
                  ),
                  _inputField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _inputField(
                    controller: phoneController,
                    label: 'Mobile Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _inputField(
                    controller: majorController,
                    label: 'Major / Specialty',
                    icon: Icons.medical_services_outlined,
                  ),
                  _inputField(
                    controller: imageUrlController,
                    label: 'Image URL',
                    icon: Icons.image_outlined,
                  ),
                  _inputField(
                    controller: profileImageController,
                    label: 'Profile Image URL',
                    icon: Icons.account_circle_outlined,
                  ),
                  _inputField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.password_outlined,
                  ),
                  const SizedBox(height: 16),
                  _ratingSelector(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'Create Doctor Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernLoader() {
    return Container(
      color: Colors.black.withOpacity(0.25),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation(
                    ColorManager.kPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Creating Doctor Account...',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Please wait',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _profilePreview() {
    return CircleAvatar(
      radius: 48,
      backgroundColor: ColorManager.kPrimary.withOpacity(0.1),
      child: const Icon(
        Icons.medical_services,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  Widget _formCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) =>
        value == null || value.isEmpty ? 'Required field' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _ratingSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Doctor Rating',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Slider(
          value: rate,
          min: 1,
          max: 5,
          divisions: 4,
          label: rate.toString(),
          activeColor: ColorManager.kPrimary,
          onChanged: (value) {
            setState(() => rate = value);
          },
        ),
      ],
    );
  }

  // ================= LOGIC =================

  void _submit() async {
    final _loginController = Get.find<LoginController>(tag: 'login_controller');
    if (!_formKey.currentState!.validate()) return;

    final doctorData = {
      "email": emailController.text,
      "user_name": userNameController.text,
      "mobile_number": phoneController.text,
      "major": majorController.text,
      "image_url": imageUrlController.text,
      "profile_image": profileImageController.text,
      "uid": uidController.text,
      "rate": rate.toInt(),
      "user_type": "doctor",
    };

    debugPrint('Create Doctor Payload: $doctorData');

    await _loginController.createAccount(email: doctorData['email'].toString(),
        name: doctorData['user_name'].toString(),
        password: passwordController.text,
        phoneNumber: phoneController.text,
        image: imageUrlController.text,
        gender: '-',
        rate: rate,
        major: majorController.text);


    // TODO:
    // Call controller.createDoctor(doctorData)
    // Show success snackbar
    // Navigate back
  }
}
