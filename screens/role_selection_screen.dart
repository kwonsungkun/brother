import 'package:flutter/material.dart';
import 'package:project/screens/home_page.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('나는 누구인가요?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRoleButton(
                        context,
                        icon: Icons.home_work_outlined, 
                        iconColor: Colors.purple.shade300,
                        label: '임대인',
                        subLabel: '(집주인)',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                      ),
                      _buildRoleButton(context, icon: Icons.person_outline, iconColor: Colors.grey.shade500, label: '임차인', subLabel: '(세입자)'),
                      _buildRoleButton(context, icon: Icons.home_outlined, iconColor: Colors.blue.shade400, label: '자가거주민', subLabel: '(부모님/내집)'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  TextButton(
                    onPressed: () {},
                    child: Text('부동산 중개인이신가요?', style: TextStyle(color: Colors.grey.shade700, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, {required IconData icon, required Color iconColor, required String label, required String subLabel, VoidCallback? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 48, color: iconColor),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subLabel, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
