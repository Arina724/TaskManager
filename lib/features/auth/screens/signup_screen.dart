import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/core/snackbar/snackbar.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';
import 'package:task_manager/features/auth/screens/signin_screen.dart';
import 'package:task_manager/features/tasks/task_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const path = '/signupscreen';

  @override
  State<SignupScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<SignupScreen> {
  TextEditingController login = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  bool passView = true;
  bool passView2 = true;
  final keys = GlobalKey<FormState>();

  @override
  void dispose() {
    login.dispose();
    pass.dispose();
    pass2.dispose();
    super.dispose();
  }

  void switchViewPass() {
    setState(() {
      passView = !passView;
    });
  }

  void switchViewPass2() {
    setState(() {
      passView2 = !passView2;
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
          title: const Text('Регистрация'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.go(SigninScreen.path),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: keys,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: TextFormField(
                      
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      controller: login,
                      validator: (login) => login != null && !EmailValidator.validate(login) ? 'Введите верную почту' : null,
                      decoration:  InputDecoration(
                        hintText: 'Введите почту',
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(30),
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
                      validator: (pass) => pass != null && pass.length <= 5 ? 'Пароль должен быть больше 5 символов' : null,
                      decoration: InputDecoration(
                        hintText: 'Введите пароль',
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(30),
                          borderSide: const BorderSide(width: 2),),
                        suffix: InkWell(
                          onTap: switchViewPass,
                          child: Icon(
                            passView ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      controller: pass2,
                      obscureText: passView2,
                      validator: (pass2) => pass2 != null && pass2.length <= 5 ? 'Пароль должен быть больше 5 символов' : null,
                      decoration: InputDecoration(
                        hintText: 'Введите пароль',
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(30),
                          borderSide: const BorderSide(width: 2),),
                        suffix: InkWell(
                          onTap: switchViewPass2,
                          child: Icon(
                            passView ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
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
                          if (login.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar('Введите почту'));
                          } else if (pass.text.isEmpty || pass2.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar('Введите пароли'));
                          } else if (pass.text != pass2.text) {
                            ScaffoldMessenger.of(context).showSnackBar(MySnackbar.mySnackbar('Пароли должны совпадать'));
                          } else if (!state.isLoading) {
                            context.read<AuthCubit>().signup(login.text.trim(), pass.text.trim());
                          }
                        },
                        child: state.isLoading ? const CircularProgressIndicator() : const Text('Зарегистрироваться'),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(onPressed: () => context.go(SigninScreen.path), child: const Text('Войти'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
