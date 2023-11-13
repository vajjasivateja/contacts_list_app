part of 'contact_bloc.dart';

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<Contact> contacts;

  ContactLoaded({required this.contacts});
}

class ContactError extends ContactState {
  final String error;

  ContactError({required this.error});
}

class ContactSearch extends ContactState {
  final List<Contact> searchResults;
  final String query;

  ContactSearch({required this.searchResults, required this.query});
}