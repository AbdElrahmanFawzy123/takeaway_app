import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/queue_system.dart';
import '../screens/simulation_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();

  int numCustomers = 50;
  double meanInterarrival = 2.0;
  double meanService = 3.0;
  int numServers = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulation Settings'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          // backgroundBlendMode: BlendMode,
          image: DecorationImage(
            image: AssetImage('assets/images/restaurant.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // بطاقة الإعدادات
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: Colors.orange,
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Simulation Parameters',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // عدد العملاء
                        TextFormField(
                          initialValue: numCustomers.toString(),
                          decoration: InputDecoration(
                            labelText: 'Number of Customers',
                            prefixIcon: const Icon(
                              Icons.people,
                              color: Colors.orange,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.orange[50],
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number of customers';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (val) => numCustomers = int.parse(val!),
                        ),
                        const SizedBox(height: 20),

                        // متوسط زمن الوصول
                        TextFormField(
                          initialValue: meanInterarrival.toString(),
                          decoration: InputDecoration(
                            labelText: 'Mean Interarrival Time (seconds)',
                            prefixIcon: const Icon(
                              Icons.timer,
                              color: Colors.orange,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.orange[50],
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter mean interarrival time';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (val) =>
                              meanInterarrival = double.parse(val!),
                        ),
                        const SizedBox(height: 20),

                        // متوسط زمن الخدمة
                        TextFormField(
                          initialValue: meanService.toString(),
                          decoration: InputDecoration(
                            labelText: 'Mean Service Time (seconds)',
                            prefixIcon: const Icon(
                              Icons.build,
                              color: Colors.orange,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.orange[50],
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter mean service time';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (val) => meanService = double.parse(val!),
                        ),
                        const SizedBox(height: 20),

                        // اختيار نوع النظام
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange.shade200),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'System Type',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              RadioListTile<int>(
                                title: const Text('Single Server 🔴'),
                                value: 1,
                                groupValue: numServers,
                                onChanged: (value) {
                                  setState(() {
                                    numServers = value!;
                                  });
                                },
                                activeColor: Colors.orange,
                              ),
                              RadioListTile<int>(
                                title: const Text('Double Server 🟢🟢'),
                                value: 2,
                                groupValue: numServers,
                                onChanged: (value) {
                                  setState(() {
                                    numServers = value!;
                                  });
                                },
                                activeColor: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // زر التشغيل
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // إظهار مؤشر تحميل
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.orange,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text('Starting Simulation...'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );

                      // بدء المحاكاة
                      var queueSystem = Provider.of<QueueSystem>(
                        context,
                        listen: false,
                      );
                      queueSystem.runSimulationLive(
                        numCustomers: numCustomers,
                        meanInterarrival: meanInterarrival,
                        meanService: meanService,
                        numServers: numServers,
                      );

                      // انتظار ثانية ونص وانتقال
                      await Future.delayed(const Duration(milliseconds: 1500));
                      if (context.mounted) {
                        Navigator.pop(context); // إغلاق التحميل
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SimulationScreen(),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.play_arrow, size: 30),
                  label: const Text(
                    'Start Live Simulation',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                ),

                const SizedBox(height: 20),

                // نص توضيحي
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Simulation will run live with real-time events. Each customer appears according to their arrival time.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
