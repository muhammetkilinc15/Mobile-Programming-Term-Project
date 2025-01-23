import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/constraits/validators.dart';
import 'package:miloo_mobile/screens/profile/components/profile_picture.dart';
import 'package:miloo_mobile/components/custom_universities.dart';
import 'package:miloo_mobile/services/user_service.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});
  static String routeName = "/my_account";

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFetching = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  String _selectedUniversity = '';
  int _selectedUniversityId = 0;
  String _profilePictureUrl = '';

  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final userDetails = await _userService.getUserDetail();

      if (mounted) {
        setState(() {
          _firstNameController.text = userDetails.firstName;
          _lastNameController.text = userDetails.lastName;
          _userNameController.text = userDetails.userName;
          _selectedUniversity = userDetails.universityName;
          _selectedUniversityId = 1;
          _profilePictureUrl = userDetails.profileImageUrl;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching user details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: _isFetching
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildForm(),
                ),
              ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ProfilePicture(
              imageUrl: _profilePictureUrl,
              onImageSelected: (p0) {
                setState(() {
                  _profilePictureUrl = p0;
                });
              },
              isEdit: true,
            ),
            const SizedBox(height: 30),
            _buildInputField(
              controller: _firstNameController,
              label: 'First Name',
              icon: Icons.person_outline,
              validator: firstNameValidator,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              validator: lastNameValidator,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _userNameController,
              label: 'User Name',
              icon: Icons.person_outline,
              validator: userNameValidator,
            ),
            const SizedBox(height: 20),
            CustomUniversities(
              selectedUniversity: _selectedUniversity,
              onSelectedId: (int selectedUniversityId) {
                setState(() {
                  _selectedUniversityId = selectedUniversityId;
                });
              },
              onSelected: (
                String selectedUniversity,
              ) {
                setState(() {
                  _selectedUniversity = selectedUniversity;
                });
              },
              selectedUniversityId: _selectedUniversityId,
            ),
            const SizedBox(height: 30),
            DefaultButton(
              text: "Update User",
              press: _handleUpdate,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Future<void> _updateUserInfo() async {
    try {
      await _userService.updateUserInfo(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        userName: _userNameController.text,
        universityId: _selectedUniversityId,
        profileImage: _profilePictureUrl,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: const Text('Profile updated successfully'),
            backgroundColor: Colors.green[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await _updateUserInfo();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }
}
