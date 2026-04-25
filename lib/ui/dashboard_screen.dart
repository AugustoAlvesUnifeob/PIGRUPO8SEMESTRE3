import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import 'package:PIGRUPO8SEMESTRE3main/routes/app_routes.dart';
import '../ui/machine_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel()..init(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
          title: Image.asset(
            'lib/assets/pblogo.png',
            width: 160,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),

        body: Consumer<DashboardViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bom dia!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    viewModel.formattedDate,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Center(
                      child: Image.asset(
                        'lib/assets/graficoDashboard.png',
                        width: 400,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  const SizedBox(height: 16),

                  ...viewModel.machines.map((machine) {
                    return MachineCard(
                      machine: machine,
                      showPecasCortadas: machine.id == 'corte',
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}