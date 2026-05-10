import 'package:PIGRUPO8SEMESTRE3main/routes/app_routes.dart';
import 'package:PIGRUPO8SEMESTRE3main/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewmodel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LoginViewmodel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (_, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.cinza,
            iconTheme: IconThemeData(
              color: AppColors.preto,
            ),
            centerTitle: true,
            title: Image.asset(
              AppColors.logo,
              key: ValueKey(AppColors.logo),
              width: 160,
              height: 80,
              fit: BoxFit.contain,
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    AppColors.mudarContraste();
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: AppColors.cinzaClaro,
                ), 
                child: 
                  Icon(Icons.accessibility, size: 30, color: AppColors.preto)
              ),
            ]
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.branco,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //const SizedBox(height: 20),
                        Image.asset(
                          'lib/assets/packbag.png',
                          height: 400,
                          fit: BoxFit.contain,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            border: AppColors.contraste
                                ? Border.all(
                                    color: AppColors.preto,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Form(
                            key: viewModel.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: viewModel.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: viewModel.emailValidator,
                                  style: TextStyle(color: AppColors.preto),
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: AppColors.pretoClaro),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.pretoClaro),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.pretoClaro, width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.pretoClaro),
                                    filled: true,
                                    fillColor: AppColors.branco,
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: viewModel.passwordController,
                                  obscureText: viewModel.obscurePassword,
                                  validator: viewModel.passwordValidator,
                                  style: TextStyle(color: AppColors.preto),
                                  decoration: InputDecoration(
                                    labelText: "Senha",
                                    labelStyle: TextStyle(color: AppColors.pretoClaro),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.pretoClaro),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.pretoClaro, width: 2),
                                    ),
                                    prefixIcon: Icon(Icons.lock_outlined, color: AppColors.pretoClaro),
                                    suffixIcon: IconButton(
                                      onPressed:
                                          viewModel.togglePasswordVisibility,
                                      icon: Icon(
                                        viewModel.obscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: AppColors.pretoClaro
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.branco,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: viewModel.isLoading
                                            ? null
                                            : () => viewModel.login(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.laranja,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                        ),
                                        child: viewModel.isLoading
                                            ? SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: AppColors.branco,
                                                    ),
                                              )
                                            : Text(
                                                'Entrar',
                                                style: TextStyle(
                                                  color: AppColors.branco,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.register,
                                        );
                                      },
                                      child: Text(
                                        "Criar conta",
                                        style: TextStyle(color: AppColors.contraste? AppColors.laranja : Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.recuperar,
                                        );
                                      },
                                      child: Text(
                                        "Recuperar senha",
                                        style: TextStyle(color: AppColors.contraste? AppColors.laranja : Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
