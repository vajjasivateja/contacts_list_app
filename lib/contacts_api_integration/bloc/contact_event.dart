part of 'contact_bloc.dart';

// Bloc Events
abstract class ContactEvent {}

class FetchContacts extends ContactEvent {}

class SearchContacts extends ContactEvent {
  final String query;

  SearchContacts({required this.query});
}
