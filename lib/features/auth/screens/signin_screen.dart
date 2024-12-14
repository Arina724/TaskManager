import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';
import 'package:task_manager/features/auth/screens/signup_screen.dart';
import 'package:task_manager/features/tasks/task_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});
  static const path = '/signinscreen';

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController login = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool passView = true;
  final keys = GlobalKey<FormState>();

  @override
  void dispose() {
    login.dispose();
   pass.dispose();
    super.dispose();
  }

  void switchViewPass() {
    setState(() {
      passView = !passView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.user != null) {
          context.go(TaskScreen.path);
        } else if (state.user == null && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error!),
            backgroundColor: Colors.red.withAlpha(150),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Вход'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: keys,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      controller: login,
                      validator: (login) => login != null && !EmailValidator.validate(login) ? 'Введите верную почту' : null,
                      decoration: InputDecoration(
                        hintText: 'Введите почту',
                        border: OutlineInputBorder(borderRadius:  BorderRadius.circular(30),
                        borderSide: const BorderSide(width: 2),)
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      controller: pass,
                      obscureText: passView,
                      validator:  (pass) => pass != null && pass.length <= 5? 'Пароль должен быть больше 5 символов' : null,
                      decoration: InputDecoration(
                        hintText: 'Введите пароль',
                        suffix: InkWell(
                          onTap: switchViewPass,
                          child: Icon(
                            passView ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(borderRadius:  BorderRadius.circular(30),
                        borderSide: const BorderSide(width: 2),)
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          state.isLoading ? null : context.read<AuthCubit>().signin(login.text.trim(), pass.text.trim());
                        },
                        child: state.isLoading ? const CircularProgressIndicator() : const Text('Войти'),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                      onPressed: () {
                        context.go(SignupScreen.path);
                      },
                      child: const Text('Зарегистрироваться'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
