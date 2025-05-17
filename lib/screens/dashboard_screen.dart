// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../models/expense_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Expense>> _latestExpensesFuture;
  late Future<List<Map<String, dynamic>>> _topCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _latestExpensesFuture = _dbHelper.getExpenses();
    _topCategoriesFuture = _dbHelper.getTop3CategoriesByExpense();
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd('es_SV').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat.yMMMMEEEEd('es_SV').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('¡Bienvenido!'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/xpnse.png',
                height: 100,
              ),
              const SizedBox(height: 10),
              Text(
                'Hoy es $formattedDate',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              // --- Caja del Top 3 ---
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE1BEE7),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top 3 categorías con más gastos:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _topCategoriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error al cargar el top de categorías: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text(
                            'Aún no se registran gastos en las categorías.',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          );
                        } else {
                          final top = snapshot.data!;
                          final icons = ['①', '②', '③'];
                          final colors = [
                            const Color(0xFFFFF9C4),
                            const Color(0xFFC8E6C9),
                            const Color(0xFFBBDEFB),
                          ];

                          return Column(
                            children: List.generate(top.length, (i) {
                              final entry = top[i];
                              final name = entry['categoryName'] as String;
                              final total =
                                  (entry['totalAmount'] as num).toDouble();

                              return Card(
                                color: colors[i],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: Text(
                                    icons[i],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  title: Text(
                                    name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Text(
                                    '\$${total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Consulta tus gastos recientes y mantén el control de tu dinero 💸',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              const Text(
                'Últimos 5 gastos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              FutureBuilder<List<Expense>>(
                future: _latestExpensesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error al cargar gastos: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text(
                      'No hay gastos registrados aún.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    final gastos = snapshot.data!.take(5).toList();
                    return Column(
                      children: gastos.map((gasto) {
                        return Card(
                          elevation: 1.5,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(gasto.description),
                            subtitle: Text(
                              '${gasto.category?.name ?? "Sin categoría"} • ${_formatDate(gasto.date)}',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            ),
                            trailing: Text(
                              '\$${gasto.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
