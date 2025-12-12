import 'package:flutter/material.dart';

import '../../../../core/barrels/auth_barrel.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: AppTexts.changePassword),
      body: ModalProgressHUD(
        inAsyncCall: context.select<AuthenticationBloc, bool>(
          (bloc) => bloc.state is ChangePasswordLoading,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: _changePasswordForm(),
          ),
        ),
      ),
    );
  }

  void _clearFields() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  Widget _changePasswordForm() {
    return BlocConsumer<AuthenticationBloc, AuthState>(
      listener: (context, state) {
        if (state is ChangePasswordFailure) {
          CustomToast.error(context, state.message);
        } else if (state is ChangePasswordSuccess) {
          CustomToast.success(context, state.response.data?.message ?? "");
          _clearFields();
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              _oldPasswordField(),
              20.verticalSpace,
              _newPasswordField(),
              20.verticalSpace,
              _confirmPasswordField(),
              40.verticalSpace,
              _submitButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _oldPasswordField() {
    return CustomTextFormField(
      label: AppTexts.oldPassword,
      hint: AppTexts.enterOldPassword,
      controller: _oldPasswordController,
      isPassword: true,
      validator: AppValidators.combine([AppValidators.required()]),
    );
  }

  Widget _newPasswordField() {
    return CustomTextFormField(
      label: AppTexts.newPassword,
      hint: AppTexts.enterNewPassword,
      controller: _newPasswordController,
      isPassword: true,
      validator: AppValidators.combine([
        AppValidators.required(),
        AppValidators.minLength(6),
      ]),
    );
  }

  Widget _confirmPasswordField() {
    return CustomTextFormField(
      label: AppTexts.confirmPassword,
      hint: AppTexts.reEnterNewPassword,
      controller: _confirmPasswordController,
      isPassword: true,
      validator: AppValidators.combine([
        AppValidators.required(),
        AppValidators.minLength(6),
        (value) {
          if (value != _newPasswordController.text) {
            return AppTexts.passwordsDoNotMatch;
          }
          return null;
        },
      ]),
    );
  }

  Widget _submitButton() {
    return CustomButton(
      text: AppTexts.updatePassword,
      onPressed: _onSubmit,
      radius: 10.r,
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.unfocusFocusScope();
      _changePasswordEvent();
    }
  }

  void _changePasswordEvent() {
    context.read<AuthenticationBloc>().add(
      ChangePasswordEvent(
        params: ChangePasswordRequestModel(
          email: SessionManager.currentUser?.email ?? "",
          currentPassword: _oldPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
        ),
      ),
    );
  }
}


