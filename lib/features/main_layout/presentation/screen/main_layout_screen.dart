import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota/features/home/presentation/screen/home_screen.dart';
import 'package:nota/features/main_layout/presentation/controller/main_cubit.dart';
import 'package:nota/features/mind_map/presentation/screen/mind_maps_list_screen.dart';
import 'package:nota/features/tips/presentation/screen/tips_screen.dart';
import 'package:nota/features/soon/presentation/screen/soon_screen.dart';
import 'package:nota/features/voice_notes/presentation/screen/voice_notes_screen.dart';
import 'package:nota/features/main_layout/presentation/widget/floating_nav_bar.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: const _MainLayoutContent(),
    );
  }
}

class _MainLayoutContent extends StatelessWidget {
  const _MainLayoutContent();

  final List<Widget> _screens = const [
    HomeScreen(),
    MindMapsListScreen(),
    TipsScreen(),
    VoiceNotesScreen(),
    SoonScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<MainCubit>().state;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: const FloatingNavBar(),
    );
  }
}
