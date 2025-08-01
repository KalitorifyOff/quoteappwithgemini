import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streakdemo/features/streak_management/bloc/streak_bloc.dart';

class StreakDisplayPage extends StatelessWidget {
  const StreakDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Streak'),
      ),
      body: BlocBuilder<StreakBloc, StreakState>(
        builder: (context, state) {
          if (state is StreakLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StreakLoaded) {
            if (state.streak == null || state.streak!.streakCount == 0) {
              return const Center(
                child: Text('Start a new streak today!'),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Current Streak:',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      '${state.streak!.streakCount} days',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Last accessed: ${state.streak!.lastAccessed.toLocal().toIso8601String().split('T').first}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<StreakBloc>().add(UpdateStreak());
                      },
                      child: const Text('Update Streak'),
                    ),
                  ],
                ),
              );
            }
          } else if (state is StreakError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
