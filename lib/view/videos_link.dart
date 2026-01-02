
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parknson_admin/controller/login_controller.dart';
import 'dart:html' as html;


class VideosLink extends StatefulWidget {
  VideosLink({super.key});

  @override
  State<VideosLink> createState() => _VideosLinkState();
}

class _VideosLinkState extends State<VideosLink> {
  /// Controllers
  final TextEditingController titleController = TextEditingController();

  final TextEditingController subscriptionController = TextEditingController();

  final TextEditingController videoUrlController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  final LoginController controller = Get.find<LoginController>(tag: 'login_controller');


  @override
  void initState() {
    Future.delayed(Duration.zero,()async{
      await controller.getVideosLink();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Page Title
                Text(
                  "Patient Videos Management",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                /// Form Card
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _inputField(
                                controller: titleController,
                                label: "Video Title",
                                icon: Icons.video_library,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _inputField(
                                controller: subscriptionController,
                                label: "Subscription",
                                icon: Icons.lock_outline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _inputField(
                                controller: videoUrlController,
                                label: "Video URL",
                                icon: Icons.link,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _inputField(
                                controller: notesController,
                                label: "Notes / Visibility",
                                icon: Icons.visibility_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        /// Action Button + Loader
                        Align(
                          alignment: Alignment.centerRight,
                          child: Obx(() {
                            final isFormValid = _isFormValid();

                            final isLoading = controller.createVideoStatus.value ==
                                ApiStatus.loading;

                            return FilledButton.icon(
                              icon: isLoading
                                  ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Icon(Icons.add),
                              label: Text(
                                isLoading ? "Creating..." : "Add Video",
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {

                                /// Validation
                                if (!_isFormValid()) {
                                  Get.snackbar(
                                    "Missing Information",
                                    "Please fill all fields before creating a video",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                await controller.createVideoLink(
                                  videoUrl: videoUrlController.text.trim(),
                                  title: titleController.text.trim(),
                                  subscribtion: subscriptionController.text.trim(),
                                  notes: notesController.text.trim(),
                                );

                                /// Clear fields on success
                                if (controller.createVideoStatus.value == ApiStatus.success) {
                                  titleController.clear();
                                  subscriptionController.clear();
                                  videoUrlController.clear();
                                  notesController.clear();

                                  Get.snackbar(
                                    "Success",
                                    "Video created successfully",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                }
                              },

                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// Preview Section
                Text(
                  "Existing Videos",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),


                Obx(() {
                  if (controller.getVideosStatus.value == ApiStatus.loading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (controller.videos.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          "No videos found",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Title")),
                          DataColumn(label: Text("Subscription")),
                          DataColumn(label: Text("Link")),
                        ],
                        rows: controller.videos.map((video) {
                          return DataRow(
                            cells: [
                              DataCell(Text(video.title)),
                              DataCell(Text(video.subscribe)),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.open_in_new),
                                  tooltip: "Open Video",
                                  onPressed: () {
                                    html.window.open(video.videoUrl, '_blank');
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),

              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable Input
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  bool _isFormValid() {
    return titleController.text.trim().isNotEmpty &&
        subscriptionController.text.trim().isNotEmpty &&
        videoUrlController.text.trim().isNotEmpty &&
        notesController.text.trim().isNotEmpty;
  }
}

