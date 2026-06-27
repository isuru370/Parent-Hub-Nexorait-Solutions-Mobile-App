// lib/features/profile/presentation/pages/profile_page.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../auth/data/model/student_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_stat_card.dart';
import 'widgets/temporary_id_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StudentModel? _student;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  void _loadStudentData() {
    final studentJson = StorageService.getJson(StorageKeys.student);

    if (studentJson != null) {
      setState(() {
        _student = StudentModel.fromJson(studentJson);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _student == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            )
          : CustomScrollView(
              slivers: [
                // Profile Header
                SliverToBoxAdapter(child: ProfileHeader(student: _student!)),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Stats Row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ProfileStatCard(
                            label: 'Grade',
                            value: _student!.gradeName ?? 'N/A',
                            icon: Icons.school,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ProfileStatCard(
                            label: 'Student ID',
                            value: _student!.customId,
                            icon: Icons.badge,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // ✅ Temporary ID Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TemporaryIdCard(student: _student!),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Personal Information Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        fontFamily: AppFonts.heading,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ProfileInfoCard(student: _student!),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Guardian Information Section
                if (_student!.hasGuardian)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Guardian Information',
                        style: TextStyle(
                          fontFamily: AppFonts.heading,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                if (_student!.hasGuardian)
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                if (_student!.hasGuardian)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildGuardianCard(),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Academic Details Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Academic Details',
                      style: TextStyle(
                        fontFamily: AppFonts.heading,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildAcademicCard(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Settings Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: AppFonts.heading,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: AppColors.border.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          ProfileMenuItem(
                            icon: Icons.edit,
                            title: 'Edit Profile',
                            subtitle: 'Update your personal information',
                            onTap: () {
                              // Navigate to edit profile
                            },
                          ),
                          const Divider(height: 1, indent: 56),
                          ProfileMenuItem(
                            icon: Icons.lock,
                            title: 'Change Password',
                            subtitle: 'Update your account password',
                            onTap: () {
                              // Navigate to change password
                            },
                          ),
                          const Divider(height: 1, indent: 56),
                          ProfileMenuItem(
                            icon: Icons.notifications,
                            title: 'Notifications',
                            subtitle: 'Manage notification preferences',
                            onTap: () {
                              // Navigate to notification settings
                            },
                          ),
                          const Divider(height: 1, indent: 56),
                          ProfileMenuItem(
                            icon: Icons.help,
                            title: 'Help & Support',
                            subtitle: 'Get help or contact support',
                            onTap: () {
                              // Navigate to help page
                            },
                          ),
                          const Divider(height: 1, indent: 56),
                          ProfileMenuItem(
                            icon: Icons.logout,
                            title: 'Logout',
                            subtitle: 'Sign out from your account',
                            onTap: _showLogoutDialog,
                            iconColor: AppColors.error,
                            textColor: AppColors.error,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
    );
  }

  Widget _buildGuardianCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.family_restroom,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _student!.guardianFullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (_student!.guardianMobile != null)
                        Text(
                          _student!.guardianMobile!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      if (_student!.guardianNic != null)
                        Text(
                          'NIC: ${_student!.guardianNic}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                if (_student!.guardianMobile != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: AppColors.success,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              icon: Icons.school,
              label: 'Grade',
              value: _student!.gradeName ?? 'N/A',
            ),
            const Divider(height: 16),
            _buildInfoRow(
              icon: Icons.class_,
              label: 'Class Type',
              value: _student!.classTypeDisplay,
            ),
            const Divider(height: 16),
            _buildInfoRow(
              icon: Icons.business_center,
              label: 'School',
              value: _student!.studentSchool ?? 'Not specified',
            ),
            const Divider(height: 16),
            _buildInfoRow(
              icon: Icons.check_circle,
              label: 'Admission Status',
              value: _student!.admissionDisplay,
              color: _student!.admission
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    final textColor = color ?? AppColors.textPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Logout logic
              // context.read<AuthBloc>().add(LogoutEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
