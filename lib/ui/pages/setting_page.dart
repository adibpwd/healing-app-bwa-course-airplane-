import 'package:airplane/cubit/auth_cubit.dart';
import 'package:airplane/cubit/edit_password_user_cubit.dart';
import 'package:airplane/cubit/edit_user_cubit.dart';
import 'package:airplane/cubit/page_cubit.dart';
import 'package:airplane/models/user_model.dart';
import 'package:airplane/services/auth_service.dart';
import 'package:airplane/shared/theme.dart';
import 'package:airplane/ui/widgets/custom_button.dart';
import 'package:airplane/ui/widgets/custom_text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // const SettingPage({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formkeyUpdatePassword = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  final TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  final TextEditingController hobbyController = TextEditingController(text: "");

  File? image;
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    Widget inputSection() {
      nameController.text = userModel!.name;
      emailController.text = userModel!.email;
      hobbyController.text = userModel!.hobby;

      Widget profileInput() {
        return InkWell(
          onTap: () async {
            final ImagePicker _picker = ImagePicker();
            final XFile? imageInput =
                await _picker.pickImage(source: ImageSource.gallery);
            setState(() {
              image = File(imageInput!.path);
            });
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(6),
            margin: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1,
                color: kBlackColor.withOpacity(0.3),
              ),
            ),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(60),
                child: image == null
                    ? Image(
                        image: CachedNetworkImageProvider(
                          userModel!.imageUrl,
                        ),
                        // width: 150,
                        // height: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        image!,
                        // width: 150,
                        // height: 150,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        );
      }

      Widget nameInput() {
        return CustomTextFormField(
          title: "Full Name",
          hintText: "Your full name",
          controller: nameController,
        );
      }

      Widget emailInput() {
        return CustomTextFormField(
          title: "Email Address",
          hintText: "Your email address",
          controller: emailController,
        );
      }

      Widget hobbyInput() {
        return CustomTextFormField(
          title: "Hobby",
          hintText: "Your hobby",
          controller: hobbyController,
        );
      }

      Widget updateUserButton() {
        return BlocConsumer<EditUserCubit, EditUserState>(
          listener: (context, state) {
            if (state is EditUserFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: kRedColor,
                  content: Text(state.error),
                ),
              );
            }
            if (state is EditUserSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: kRedColor,
                  content: Text("Success update profile"),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EditUserLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return CustomButton(
              title: "Update Profile",
              onPressed: () {
                if (userModel != null) {
                  context.read<EditUserCubit>().updateUser(
                    user: {
                      "id": userModel!.id,
                      "email": emailController.text,
                      "name": nameController.text,
                      "hobby": hobbyController.text,
                      "balance": userModel!.balance,
                      "imageUrl": userModel!.imageUrl,
                    },
                    image: image,
                  ).whenComplete(() {
                    context.read<AuthCubit>().getCurentUser(userModel!.id);
                  });
                }
              },
            );
          },
        );
      }

      return Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        child: Column(
          children: [
            profileInput(),
            nameInput(),
            emailInput(),
            hobbyInput(),
            updateUserButton(),
          ],
        ),
      );
    }

    Widget inputUpdatePasswordSection() {
      Widget passwordInput() {
        return CustomTextFormField(
          title: "Password",
          hintText: "Your password",
          obsecureText: true,
          controller: passwordController,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Must be filled';
            }
            return null;
          },
        );
      }

      Widget confirmPasswordInput() {
        return CustomTextFormField(
          title: "Confirm Password",
          hintText: "Confirm Your password",
          obsecureText: true,
          controller: confirmPasswordController,
          validator: (val) {
            if (val!.isEmpty) {
              return 'Must be filled';
            } else if (val != passwordController.text) {
              return 'Passwords are not the same';
            } else {
              return null;
            }
          },
        );
      }

      Widget updateButton() {
        return BlocConsumer<EditPasswordUserCubit, EditPasswordUserState>(
          listener: (context, state) {
            if (state is EditPasswordUserFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: kRedColor,
                  content: Text(state.error),
                ),
              );
            }
            if (state is EditPasswordUserSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: kRedColor,
                  content: Text("Success update password"),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EditPasswordUserLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return CustomButton(
              title: "Update Password",
              onPressed: () {
                _formkeyUpdatePassword.currentState!.validate();
                context
                    .read<EditPasswordUserCubit>()
                    .updatePasswordUser(passwordController.text);
              },
            );
          },
        );
      }

      return Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
        child: Form(
          key: _formkeyUpdatePassword,
          child: Column(
            children: [
              passwordInput(),
              confirmPasswordInput(),
              updateButton(),
            ],
          ),
        ),
      );
    }

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: kRedColor,
              content: Text(state.error),
            ),
          );
        } else if (state is AuthInitial) {
          context.read<PageCubit>().setPage(0);
          Navigator.pushNamedAndRemoveUntil(
              context, "/sign-in", (route) => false);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is AuthSuccess) {
          userModel = state.user;
          return SafeArea(
            child: ListView(
              // shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: defaultMargin,
                vertical: defaultMargin,
              ),
              children: [
                // title(),
                inputSection(),
                SizedBox(height: 12),
                inputUpdatePasswordSection(),
                SizedBox(height: 32),
                CustomButton(
                  title: "Sign Out",
                  onPressed: () {
                    context.read<AuthCubit>().signOut();
                  },
                  margin: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                ),
                SizedBox(height: 100)
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
