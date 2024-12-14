import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/cubit/auth_state.dart';
import 'package:task_manager/features/auth/screens/signin_screen.dart';

class SignoutScreen extends StatelessWidget {
  const SignoutScreen({super.key});
  static const path = '/signoutscreen';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.user == null) {
          context.go(SigninScreen.path);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Выход'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outlined,
                  ),
                  Text('Ваша почта:'),
                ],
              ),
              
                  Text('${user!.email}'),
              
              const SizedBox(
                height: 20,
              ),
              TextButton(onPressed:(){ 
                context.read<AuthCubit>().signout;
                context.go(SigninScreen.path
                );}, child: const Text('Выйти'))
            ],
          ),
        ),
      ),
    );
  }
}
