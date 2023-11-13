import 'package:contacts_list_app/res/colors.dart';
import 'package:contacts_list_app/custom_pie_chart/PieChart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../custom_pie_chart/CustomPieChart.dart';
import 'bloc/contact_bloc.dart';
import 'models/Contact.dart';

class ContactsScreen extends StatelessWidget {
  final ContactBloc contactBloc = ContactBloc();

  ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => contactBloc..add(FetchContacts()),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: ContactList(),
        ),
      ),
    );
  }
}

class ContactList extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        if (state is ContactLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContactLoaded || state is ContactSearch) {
          final contacts = state is ContactSearch ? state.searchResults : (state as ContactLoaded).contacts;
          contacts.sort((a, b) => a.name.compareTo(b.name));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSearchTextField(context),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
                child: Text(
                  "Contacts",
                  style: TextStyle(color: blackColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              CustomPieChart(
                pieCharts: [
                  PieChart(color: Colors.red, name: "Hot", percentage: 25, value: 35),
                  PieChart(color: Colors.orange, name: "Warm", percentage: 25, value: 35),
                  PieChart(color: Colors.blue, name: "Cold", percentage: 50, value: 90),
                ],
                // change percentage values that sum up in total of 100%
                strokeWidth: 10,
                normalText: 'Total Prospects',
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContactListItem(contact: contacts[index]),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is ContactError) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: Text('Something went wrong.'));
        }
      },
    );
  }

  Widget buildSearchTextField(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: primaryBlueGradient1,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: TextField(
            controller: searchController,
            onChanged: (query) {
              context.read<ContactBloc>().add(SearchContacts(query: query));
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search...',
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.normal),
              labelStyle: const TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.normal),
              prefixIcon: const Icon(Icons.search_sharp, color: Colors.black54, size: 25),
              prefixIconColor: Colors.black54,
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: GestureDetector(
                          child: const Icon(Icons.close, size: 15, color: Colors.white),
                          onTap: () {
                            searchController.clear();
                            context.read<ContactBloc>().add(SearchContacts(query: ""));
                          },
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContactListItem extends StatelessWidget {
  final Contact contact;

  const ContactListItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: whiteColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      shadowColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Card(
            elevation: 4,
            color: whiteColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
            shadowColor: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${contact.name[0]}${contact.name.split(" ").last[0]}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          title: buildHighlightedText(contact.name, context),
          subtitle: buildSubtitleText(contact.email, context),
        ),
      ),
    );
  }

  Widget buildHighlightedText(String text, BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        String searchQuery = "";
        if (state is ContactSearch) {
          searchQuery = state.query;
        }

        if (searchQuery.isEmpty) {
          return Text(
            text,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
          );
        }

        final lowerText = text.toLowerCase();
        final lowerQuery = searchQuery.toLowerCase();

        int start = 0;
        final spans = <TextSpan>[];

        while (start < lowerText.length) {
          final matchIndex = lowerText.indexOf(lowerQuery, start);
          if (matchIndex == -1) {
            spans.add(TextSpan(
              text: text.substring(start),
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
            ));
            break;
          }
          if (matchIndex > start) {
            spans.add(TextSpan(
              text: text.substring(start, matchIndex),
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
            ));
          }
          final matchEnd = matchIndex + lowerQuery.length;
          spans.add(
            TextSpan(
              text: text.substring(matchIndex, matchEnd),
              style: const TextStyle(color: secondaryBlue, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          );

          start = matchEnd;
        }
        return Text.rich(TextSpan(children: spans));
      },
    );
  }

  Widget buildSubtitleText(String text, BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        return Text(
          text,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.normal, fontSize: 16),
        );
      },
    );
  }
}
