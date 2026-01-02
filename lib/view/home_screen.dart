import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parknson_admin/controller/login_controller.dart';
import 'package:parknson_admin/shared/color_manager.dart';
import 'package:parknson_admin/view/create_doctor_screen.dart';
import 'package:parknson_admin/view/videos_link.dart';
import 'package:redacted/redacted.dart';

import '../model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _loginController=Get.find<LoginController>(tag: 'login_controller');

  @override
  void initState() {
    Future.delayed(Duration.zero,()async{
      await _loginController.getAllUsers();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: ColorManager.kPrimary,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Parkinson Care System',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _statsSection(isTablet)),
            const SizedBox(height: 24),


            Expanded(
              child: isTablet
                  ? Row(
                children: const [
                  Expanded(child: UsersSection()),
                  SizedBox(width: 16),
                  Expanded(child: DoctorsSection()),
                ],
              )
                  : ListView(
                children: const [
                  SizedBox(
                    height: 400,
                    child: UsersSection(),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 400,
                    child: DoctorsSection(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 20,
        children: [
          FloatingActionButton.extended(
            backgroundColor: ColorManager.kPrimary,
            elevation: 6,
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text(
              'Create Doctor',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: ()=>Get.to(()=>CreateDoctorScreen()),
          ),
          FloatingActionButton.extended(
            backgroundColor: ColorManager.kPrimary,
            elevation: 6,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Videos Link',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: ()=>Get.to(()=>VideosLink()),
          )
        ],
      ),
    );
  }

  Widget _statsSection(bool isTablet) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _redactedCard(
           DashboardCard(
            title: 'Total Users',
            value: '${_loginController.allUsers.length}',
            icon: Icons.people,
          ),
        ),
        _redactedCard(
           DashboardCard(
            title: 'Doctors',
            value: '${_loginController.allDoctors.length}',
            icon: Icons.medical_services,
          ),
        ),
        _redactedCard(
           DashboardCard(
            title: 'Appointments',
            value: '${_loginController.allAppointments.length}',
            icon: Icons.event,
          ),
        ),
        _redactedCard(
          const DashboardCard(
            title: 'Reports',
            value: '1,120',
            icon: Icons.bar_chart,
          ),
        ),
      ],
    );
  }


  Widget _redactedCard(Widget child) {
    return child.redacted(
      context: context,
      redact: _loginController.getAllUsersStatus.value == ApiStatus.loading,
      configuration:  RedactedConfiguration(
        animationDuration: Duration(milliseconds: 800),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.kPrimary.withOpacity(0.9),
            ColorManager.kPrimary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorManager.kPrimary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}


class UsersSection extends StatelessWidget {
  const UsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.find<LoginController>(tag: 'login_controller');

    return _sectionContainer(
      title: 'Users',
      child: Expanded(
        child: Obx(() {
          // 🔄 Loading
          if (controller.getAllUsersStatus.value == ApiStatus.loading) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (_, __) => _redactedUserTile(context),
            );
          }

          // 📭 Empty
          if (controller.allUsers.isEmpty) {
            return const Center(
              child: Text(
                'No users found',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          // ✅ Data
          return ListView.separated(
            itemCount: controller.allUsers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final user = controller.allUsers[index];
              return _userTile(user);
            },
          );
        }),
      ),
    );
  }

  Widget _userTile(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorManager.kPrimary,
            child: Text(
              (user.userName ?? 'U')[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
      
        ],
      ),
    );
  }

  Widget _redactedUserTile(BuildContext context) {
    final _loginController=
    Get.find<LoginController>(tag: 'login_controller');
    return Obx(()=>Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
    ).redacted(context: context, redact: _loginController.getAllUsersStatus.value==ApiStatus.loading));
  }
}


class DoctorsSection extends StatelessWidget {
  const DoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.find<LoginController>(tag: 'login_controller');

    return _sectionContainer(
      title: 'Doctors',
      child: Expanded(
        child: Obx(() {
          if (controller.getAllUsersStatus.value == ApiStatus.loading) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (_, __) => _redactedDoctorTile(context),
            );
          }

          if (controller.allDoctors.isEmpty) {
            return const Center(
              child: Text(
                'No doctors found',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: controller.allDoctors.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final doctor = controller.allDoctors[index];
              return _doctorTile(doctor);
            },
          );
        }),
      ),
    );
  }

  Widget _doctorTile(UserModel doctor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorManager.kPrimary,
            child: const Icon(Icons.medical_services, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.userName ?? 'Doctor',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.email ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _redactedDoctorTile(BuildContext context) {
    final _loginController=
    Get.find<LoginController>(tag: 'login_controller');
    return Obx(()=>Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
    ).redacted(context: context, redact: _loginController.getAllUsersStatus.value==ApiStatus.loading));
  }
}



Widget _sectionContainer({required String title, required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}
