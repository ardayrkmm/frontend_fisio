import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_bloc.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_event.dart';
import 'package:frontend_fisio/features/Pages/MainPages/bloc/navbar_state.dart';

class CustomBottomNavbar extends StatelessWidget {
  CustomBottomNavbar({super.key});

  final List navItems = [
    {"icon": Icons.home_rounded, "label": "Home"},
    {"icon": Icons.bar_chart_rounded, "label": "Stat"},
    {"icon": Icons.directions_run_rounded, "label": "Activity"},
    {"icon": Icons.person_rounded, "label": "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(navItems.length, (index) {
              final isActive = state.selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  context.read<NavigationBloc>().add(ChangeTab(index));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: isActive ? 20 : 0,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isActive ? const Color(0xFF6C63FF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        navItems[index]["icon"],
                        color: isActive ? Colors.white : Colors.grey,
                        size: 26,
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 8),
                        Text(
                          navItems[index]["label"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}
