import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import '../models/Contact.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  List<Contact> allContacts = [];

  ContactBloc() : super(ContactInitial()) {
    on<FetchContacts>((event, emit) async {
      emit(ContactLoading());
      try {
        final List<Contact> contacts = await _fetchContacts();
        print(contacts.toString());
        emit(ContactLoaded(contacts: contacts));
      } catch (e) {
        print(e);
        emit(ContactError(error: 'Failed to fetch contacts'));
      }
    });

    on<SearchContacts>((event, emit) {
      final searchResults = _searchContacts(event.query);
      emit(ContactSearch(searchResults: searchResults, query: event.query));
    });
  }

  Future<List<Contact>> _fetchContacts() async {
    final response = await http.get(Uri.parse("https://testapi.io/api/vajjasivateja/contactslist"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data.toString());
      final contactsList = List<Map<String, dynamic>>.from(data['data']);
      final List<Contact> contacts = contactsList.map((contact) {
        return Contact(
          id: contact['id'],
          name: contact['name'],
          email: contact['email'],
        );
      }).toList();
      allContacts = contacts;
      return contacts;
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  List<Contact> _searchContacts(String query) {
    return allContacts.where((contact) {
      return contact.name.toLowerCase().contains(query.toLowerCase()) ||
          contact.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
