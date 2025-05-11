import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/giveaway_bloc.dart';
import '../widgets/create_giveaway_button.dart';
import '../widgets/giveaway_card.dart';
import 'giveaway_details_page.dart';

class GiveawaysListPage extends StatefulWidget {
  const GiveawaysListPage({super.key});

  @override
  State<GiveawaysListPage> createState() => _GiveawaysListPageState();
}

class _GiveawaysListPageState extends State<GiveawaysListPage> {
  @override
  void initState() {
    super.initState();
    context.read<GiveawayBloc>().add(LoadGiveaways());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GiveawayBloc, GiveawayState>(
        builder: (context, state) {
          if (state is GiveawayLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GiveawayLoaded) {
            if (state.giveaways.isEmpty) {
              return const Center(child: Text('No hay sorteos todavía.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.giveaways.length,
              itemBuilder: (context, index) {
                final giveaway = state.giveaways[index];
                return GiveawayCard(
                  giveaway: giveaway,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GiveawayDetailsPage(giveaway: giveaway),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is GiveawayError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: const CreateGiveawayButton(),
    );
  }
}
