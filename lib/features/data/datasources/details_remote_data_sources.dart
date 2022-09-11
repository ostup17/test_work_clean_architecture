import 'dart:convert';

import 'package:architecture/features/data/config.dart';
import 'package:architecture/features/data/model/details_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/error/exception.dart';

abstract class DetailsRemoteDataSorce {
  Future<List<DetailsModel>>getAllDetails();
}

class DetailsRemoteDataSorceImpl implements DetailsRemoteDataSorce {
  final http.Client client;

  DetailsRemoteDataSorceImpl({required this.client});
  
  @override 
  Future<List<DetailsModel>> getAllDetails() async {
    final response = await http.get(
        Uri.parse(ConfigUrl.details),
        headers: {'Content-Type': 'application/json'}
    );
    if(response.statusCode == 200) {
      final details = json.decode(response.body);
      return (details as List).map((e) => DetailsModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }
}
