import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/giveaway_bloc.dart';
import '../widgets/giveaway_list_widget.dart';
import '../widgets/participant_list_widget.dart';
import 'giveaway_create_page.dart';

class GiveawayPage extends StatelessWidget {
  const GiveawayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GiveawayBloc, GiveawayState>(
        builder: (context, state) {
          if (state is GiveawayLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GiveawayLoaded) {
            return GiveawayListWidget(giveaways: state.giveaways);
          } else if (state is GiveawayError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GiveawayCreatePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
